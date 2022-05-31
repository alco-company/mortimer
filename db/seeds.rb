# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# dashboard
d1 = Dashboard.create name: "ALCO's instrumentbrædt", layout: "application", body: "<div style='margin: 2rem'>This is the default<b>dashboard</b>!</div>"
cal1 = Calendar.create name: "ALCO's kalender"
alco = Account.create name: "ALCO", dashboard: d1, calendar: cal1

cal2 = Calendar.create name: "ALCO monitor's kalender"
whd = Participant.create account: alco, name: "Uberspeicher", state: 'confirmed', calendar: cal2, participantable: User.create(  user_name: "Überspeicher", account: alco, email: "monitor@speicher.ltd", password: "ad1411bd2803wd2208", password_confirmation: "ad1411bd2803wd2208", confirmed_at: DateTime.now )

services = %w( Products StockedProducts Stocks Suppliers StockLocations Employees PunchClocks Roles Teams )
sg = { "Products" => "pim", "StockedProducts" => "wms", "Stocks" => "wms", "StockLocations" => "wms", "Suppliers" => "scm", "Employees" => "hr", "Roles" => "hr", "Teams" => "hr", "PunchClocks" => "hr" }
services.each{ |s| Service.create name: s, menu_label: s.underscore, index_url: "/#{s.underscore}", service_group: sg[s] }

role_types = { 
  god: { name: 'super user', context: ' ', role: 'ISNECUDPF' }, 
  user: { name: 'users and teams', context: 'users teams', role: 'ISNECUDPF' },  
  role: { name: 'role', context: 'roles', role: 'ISNECUDPF' },  
  pim: { name: 'pim', context: 'suppliers products', role: 'ISNECUDPF' },  
  stock: { name: 'stock', context: 'stocked_products stocks stock_items stock_locations stock_transactions', role: 'ISNECUDPF' },  
  time: { name: 'enter_leave', context: 'employees punch_clocks enter_leaves', role: 'ISNECUDPF' }, 
}
roles = {}
role_types.each{ |k,v| roles[k] = Role.create account: Account.first, name: v[:name], context: v[:context], role: v[:role] }
Roleable.create role: roles[:god], roleable: whd #.participantable

team_types = { 
  uber: { name: 'Sherifferne', roles: [ :god ] },
  mgr: { name: 'Management', roles: [ :user, :role, :pim, :stock, :time ]},
  product: { name: 'Product Management', roles: [ :pim ]},
  stock: { name: 'Stock Personel', roles: [ :stock ]},
  hr: { name: 'Human Resource', roles: [ :time ]}
}
teams = {}
team_types.each do |k,v|
   part = Participant.create account: alco, name: v[:name], participantable: Team.create
   v[:roles].each{ |r| Roleable.create role: roles[r], roleable: part }
   ParticipantTeam.create participant: whd, team: part.participantable
end
