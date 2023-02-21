#
#
# f_days_acc - accumulated number of holi-days (2,08 days pr month)
# ff_days - number of 'feriefridage' / 'omsorgsdage' - same same
# 
class Employee < AbstractResource
  include Assetable

  has_secure_token :access_token
  has_one_attached :mug_shot
  has_and_belongs_to_many :pupils

  accepts_nested_attributes_for :pupils, allow_destroy: true

  validates :pin_code, uniqueness: true
  
  def self.working
    where('assets.state': ['IN','BREAK'])
  end

  def working?
    ['IN','BREAK'].include? state
  end
  #
  # default_scope returns all posts that have not been marked for deletion yet
  #
  def self.default_scope
  #   where("assetable" deleted_at: nil)
    Employee.all.joins(:asset)
  end

  #
  # implement on every model where search makes sense
  # get's called from controller specific find_resources_queried
  #
  def self.search_by_model_fields lot, query
    default_scope.where "assets.name ilike '%#{query}%' "
  end

  def signed_pupils=(ppls)
    pupils.delete_all
    ppls.keys.each { |k| pupils << Pupil.find(k) }
  end

  #
  # used by clone_from method on abstract_resource
  # to exclude has_many associations which should not be cloned
  # when making a copy of some instance of a model
  #
  def excluded_associations_from_cloning
    []
  end

  def broadcast_create
    broadcast_prepend_later_to "pos_employees", 
      partial: "pos/employees/list_employee", 
      target:  "pos_employees_#{self.id}",  
      locals: { employee: self, user: Current.user }

  end

  def broadcast_update
    # broadcast_replace_later_to "employee_#{self.id}_calendar", 
    #   partial: "employees/calendar", 
    #   target: "employee_#{self.id}_calendar", 
    #   locals: { resource: self, user: Current.user }

    buttons = Current.account.system_parameters_include("pos/employee/buttons")
    reason = self.asset.asset_work_transactions.last.try(:event).try(:name) || ""

    broadcast_replace_later_to "pos_employees", 
      partial: "pos/employees/list_employee", 
      target: "pos_employees_#{self.id}", 
      locals: { employee: self, user: Current.user }

    broadcast_replace_later_to "employee_#{self.asset.id}_pupils", 
      partial: "pos/employees/employee_pupils", 
      target: "pupils", 
      locals: { resource: self.asset, user: Current.user }
      
    broadcast_replace_later_to "employee_#{self.asset.id}_state", 
      partial: "pos/employees/employee_state", 
      target: "employee_state", 
      locals: { resource: self.asset, reason: reason, user: Current.user }

        
    broadcast_replace_later_to "employee_#{self.asset.id}_state_buttons", 
      partial: "pos/employees/employee_state_buttons", 
      target: "employee_state_buttons", 
      locals: { resource: self.asset, user: Current.user, buttons: buttons }

  end


  def self.print_record params
    @resources = Employee.all.order(birthday: "asc")
    # @resources =Employee.search( Employee.all.where(account: params[:speicher_account]), params[:q]).order(social_security_number: "asc") unless params[:q].blank?

    html = params[:context].render_to_string "employees/time_sheet", layout: 'print_a4_landscape', encoding: "UTF-8", locals: {resources: @resources}
    t = File.open Rails.root.join("tmp","export.html"), "wb"
    t << html
    t.close
    #
    # solution maybee on https://github.com/mileszs/wicked_pdf/issues/754
    #
    pdf=WickedPdf.new.pdf_from_string html, 
      page_size: 'A4',
      page_width: '210mm',
      page_height: '297mm',
      orientation: 'Landscape',
      # dpi: 1200, 
      margin: { top: 0, bottom: 0, left: 0, right: 0 },
      print_media_type: true,  
      extra: '--disable-smart-shrinking',
      lowquality: true

    t = File.open Rails.root.join("tmp","export.pdf"), "wb"
    t << pdf
    t.close
    "export.pdf"
  end


end
