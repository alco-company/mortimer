module Views
  #
  # the date component is a wrapper for the date_field form input field
  #
  class Components::Form::ActionButtons < Phlex::HTML
    include Phlex::Rails::Helpers::LinkTo

    def initialize( resource: nil, delete_url: nil, deleteable: false )
      @resource = resource
      @delete_url = delete_url
      @deleteable = deleteable
    end

    def template()
      div( class: "fixed w-screen max-w-md bottom-0 w-2/3 flex justify-start px-4 border-t border-gray-200 bg-gray-50 py-5 sm:px-6 z-10") do
        div( class: "flex-none w-1/3 h-14") do
          if @deleteable
            link_to( @delete_url, class: "button delete-button", data: { turbo_confirm: 'Are you sure?', turbo_method: :delete, action: "click->form-sleeve#toggle" }) { helpers.t :delete} 
          end
        end
        div( class: "flex justify-end w-2/3") do
          div( class: "flex-initial sm:space-x-3") do
            button( data: { form_sleeve_target: "cancel", action: "click->form-sleeve#cancel"}, type: "button", class: "button cancel-button") { helpers.t :cancel}
            button( data: { form_sleeve_target: "save"}, type: "submit", class: "button save-button") do
              span( class: "group-disabled:hidden") {@resource.new_record? ? helpers.t(:create) : helpers.t(:update)}
              span( class: "hidden group:disabled:block group-disabled:cursor-wait") { helpers.t('.updating') }
            end
          end
        end
      
      end
    end
  end
end
