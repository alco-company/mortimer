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
