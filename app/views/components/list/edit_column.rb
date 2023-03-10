module Views
  class Components::List::EditColumn < Phlex::HTML
    include Phlex::Rails::Helpers::LinkTo

    def initialize( **attribs )
      @url = attribs[:url]
      @edit_label =  attribs[:edit_label] || I18n.t('edit')
    end

    def template()
      span do 
        link_to( @url, class:"float-right sm:hidden", data_action: "click->switchboard#toggleListFormSleeve", data_turbo_frame: 'form_slideover' ) do
          span( class:"material-symbols-outlined" ) {"chevron_right"}
        end
        link_to( @edit_label, @url, class: "hidden sm:inline-flex items-center px-2.5 py-1.5 border border-transparent text-xs font-medium rounded text-gray-700 bg-gray-100 hover:bg-indigo-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500", data: { action: "click->switchboard#toggleListFormSleeve", 'turbo-action': 'advance', 'turbo-frame': 'form_slideover' } )
      end
    end

  end
end
