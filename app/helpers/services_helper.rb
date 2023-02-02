module ServicesHelper

  SG = {
    time: '<span class="p-1 material-symbols-outlined">schedule</span>',
    hr: '<span class="p-1 material-symbols-outlined">wc</span>',
    asset: '<span class="p-1 material-symbols-outlined">corporate_fare</span>',
    wms: '<span class="p-1 material-symbols-outlined">pallet</span>',
    scm: '<span class="p-1 material-symbols-outlined">conveyor_belt</span>',
    pim: '<span class="p-1 material-symbols-outlined">trolley</span>',
    crm: '<span class="p-1 material-symbols-outlined">tenancy</span>',
    scope: '<span class="p-1 material-symbols-outlined">roofing</span>',
    service: '<span class="p-1 material-symbols-outlined">dry_cleaning</span>',
    supporting: '<span class="p-1 material-symbols-outlined">settings</span>',
  }

  def service_group_icon service
    raw SG[service.downcase.to_sym]
  end
end
