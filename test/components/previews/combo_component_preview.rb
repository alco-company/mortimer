class ComboComponentPreview < ViewComponent::Preview
  def with_simple_list
    resource = ProductService.new.new_product(Account.first)
    form_with model: resource, url: resource_url(), id: resource_form, data: { form_sleeve_target: 'form' }, class: "h-full flex flex-col bg-white shadow-xl overflow-y-scroll" do |form|
      form.fields_for :assetable do |asset_form|
        render(Resource::ComboComponent.new( form: asset_form, attr: :supplier_id, label: t('.supplier'), type: :single_drop_search, url: "/suppliers" ))
      end
    end

  end
end