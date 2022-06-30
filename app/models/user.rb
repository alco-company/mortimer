class User < AbstractResource
  has_paper_trail ignore: %i[remember_token session_token]

  include Participantable

  CONFIRMATION_TOKEN_EXPIRATION = 10.minutes

  has_secure_password
  has_secure_token :remember_token
  has_secure_token :session_token

  before_save :downcase_email
  before_save :downcase_unconfirmed_email

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, presence: true
  validates :unconfirmed_email, format: { with: URI::MailTo::EMAIL_REGEXP, allow_blank: true }
  validates :user_name, presence: true, uniqueness: true

  attr_accessor :current_password

  has_one :profile, dependent: :destroy
  belongs_to :account

  delegate :time_zone, to: :profile

  #
  # default_scope returns all posts that have not been marked for deletion yet
  #
  def self.default_scope
    #   where("assetable" deleted_at: nil)
    User.all.joins(:participant)
  end

  def name
    user_name
  end

  #
  # does the user have access to seed/act on notifications?
  #
  def can_view_notifications?
    true
  end

  def confirm!
    if unconfirmed_or_reconfirming?
      return false if unconfirmed_email.present? && !update(email: unconfirmed_email, unconfirmed_email: nil)

      update_columns(confirmed_at: Time.current)
    else
      false
    end
  end

  def confirmed?
    confirmed_at.present?
  end

  def unconfirmed_or_reconfirming?
    unconfirmed? || reconfirming?
  end

  def confirmable_email
    if unconfirmed_email.present?
      unconfirmed_email
    else
      email
    end
  end

  def generate_confirmation_token
    signed_id expires_in: CONFIRMATION_TOKEN_EXPIRATION, purpose: :confirm_email
  end

  def reconfirming?
    unconfirmed_email.present?
  end

  def unconfirmed?
    !confirmed?
  end

  MAILER_FROM_EMAIL = 'no-reply@greybox.speicher.ltd'

  def send_confirmation_email!
    confirmation_token = generate_confirmation_token
    UserMailer.confirmation(self, confirmation_token).deliver_now
  end

  PASSWORD_RESET_TOKEN_EXPIRATION = 10.minutes

  def generate_password_reset_token
    signed_id expires_in: PASSWORD_RESET_TOKEN_EXPIRATION, purpose: :reset_password
  end

  def send_password_reset_email!
    password_reset_token = generate_password_reset_token
    UserMailer.password_reset(self, password_reset_token).deliver_now
  end

  def self.authenticate_by(attributes)
    passwords, identifiers = attributes.to_h.partition do |name, _value|
      !has_attribute?(name) && has_attribute?("#{name}_digest")
    end.map(&:to_h)

    raise ArgumentError, 'One or more password arguments are required' if passwords.empty?
    raise ArgumentError, 'One or more finder arguments are required' if identifiers.empty?

    if (record = unscoped.find_by(identifiers))
      record if passwords.count { |name, value| record.public_send(:"authenticate_#{name}", value) } == passwords.size
    else
      new(passwords)
      nil
    end
  end

  def state
    return :created if confirmed_at.nil?

    # return :invited if self.confirmed_at.nil? and !self.invited_at.nil?
    :confirmed
  end

  #
  # implement on every model where search makes sense
  # get's called from controller specific find_resources_queried
  #
  def self.search_by_model_fields(_lot, query)
    default_scope.where "user_name like '%#{query}%' or participants.name like '%#{query}%' "
  end

  #
  # used by clone_from method on abstract_resource
  # to exclude has_many associations which should not be cloned
  # when making a copy of some instance of a model
  #
  def excluded_associations_from_cloning
    []
  end

  #
  # authorize user for action on endpoint
  #
  def can(action, endpoint)
    return true if is_a_god?

    all_roles.each { |r| return true if r.can(action, endpoint) }
    say "no roles allow #{action} on #{endpoint}"
    false
  rescue StandardError
    say "User #{id} failed checking if #{action} against #{endpoint} is authorized"
    false
  end

  def can_list_service?(service)
    can :index, service.index_url.split('/').last.singularize
  end

  def can_impersonate?
    is_a_god?
  end

  #
  # by birth
  #
  def is_a_god?
    id == 1
  end

  def all_roles
    (teams.map(&:roles).flatten + roles).uniq
  end

  def all_tasks
    teams.map(&:task).flatten.uniq
  end

  private

  def downcase_email
    self.email = email.downcase
  end

  def downcase_unconfirmed_email
    return if unconfirmed_email.nil?

    self.unconfirmed_email = unconfirmed_email.downcase
  end
end
