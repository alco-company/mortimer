# CHANGELOG

I started this as another project - hermes - which evolved into 'astronaut' which was a bespoke customer project further developed by [Michal Szymanski](https://github.com/michalsz); the basic idea on how to persist data is, however, the same - with 4-5 core entities: Event, Asset, Participant, Message, (and Document). 

The distinction between Message and Document isn't quite clear because I haven't decided on whether Documents really are a particular form of Messages, or entities in their own right, yet.

The Key Issue being that one/more Participants will exchange/persist a Message/Document and it will be an Event them doing it - and there is a good change that the exchange
is pertaining to an Asset!

In the REFERENCES you will find a lot of people, resources, etc

## KEEP AN EYE ON

* [competition to TurboStream](https://github.com/unabridged/motion)

## TODO

### Consider using Railway

<https://railway.app/>

### Download button - CSV

<button
  type="submit"
  class="btn btn-primary btn-link"
  name="format"
  value="xls">Download Excel</button>

(standard Rails controller catches the format parameter and renders the appropriate template)
respond_to do |format|
  format.html
  format.xls { csv=@users.to_csv(col_sep: "\t"); send_data csv, filename: "users-#{Date.today}.xls"
end



Upgrade to Rails 7.1 asap - we need default_url_options for Hotwire and TurboStream

setup necessary domains:

* mortimer.green
* mortimer.guru
* mortimer.ltd
* mortimer.plus
* mortimer.pro
* mortimer.run
* mortimer.today
* mortimer.watch

green for testing/demo, guru for wiki/docs, ltd for production, plus for business+, pro for business, run for backgroundjobs, today for marketing, watch for monitoring

Entities to be added:

* employees portal (to allowing employees a GDPR safe view on the information stored, links to refute, confirm, resign,more)
* equipment/real estate/tools/cars/more (TCO, depreciation,identification,location,usage,more)
* product (variant) design/calculation/planning - PIM work in a number of domains (graphics, patents/documents,more ) - collaboration
* leads/supplier
* purchase inquiries
* call (to making notes/comments on phone calls, and uptake leads, and sales inquiries/orders)
* lead/customer portal (to allow the lead/customer a GDPR safe view on their engagement with the company, recent offers, orders, invoices, more)
* order confirmation
* picklist
* b/l aka receipt
* freight/carrier documents
* invoice
* all the documents should be pixel perfect 'on screen' as well as in print

## DONE

### 2023-02-15

publishing PDFs doesn't work either -
created bin/commit to automate rbc, yardoc, git add, and git commit
isolating doc in greybox/doc and using <https://www.honeybadger.io/blog/documentation-worklow-rails/> to generate docs @ <https://mortimer.guru>
bin/commit will allow you to commit with a message from the command line - e.g. bin/commit "added documentation" - it will also commit the docs

### 2023-02-01

changed to publishing pdf's in the docs folder

### 2022-12-26

08:00 phone support
14:30 looking for produts for PILEA
18:00 done


### 2022-12-25

08:00 deliver switch to TTF
09:05 work on asset_workday_sum
18:15 done
19:00 meeting in Fund Manegement Board for Enghavehuset

### 2022-12-24

06:45 work on asset_workday_sum
14:30 move free_time to last_year
18:10 setting buttons right on employee
21:30 added organizations
23:45 search 'n new button

### 2022-12-23

07:45 uris for all the things - phone, email, address, website, more

### 2022-12-17

06:45 start work on refactoring abstract_{controller,service}, more
01:14 commit af ændringer til resource_url + abstract_ & _service 


### 2022-12-12

07:40 work on pos/employees UI
11:30 work on /sidekiq authentication
13:50 work on pos/employees UI
13:50 add error_controller
18:15 depstage


### 2022-12-11

had a visit from Nykredit - real estate agent giving an evaluation of Drosselvej 21

08:30 work on pos/employees UI
18:30 -

### 2022-12-04

08:30 fix ProfileService error
08:50 fix PrintserverService error

### 2022-12-03

08:10 cont' work on tasks for employees
12:30 Pilea project interview with Blue Capital asset manager
13:30 working on Outlet attributes on elements
15:00 break
21:30 cont' working on Outlet attributes on elements


### 2022-12-02

08:30 cont' work on tasks for employee
08:57 yarn upgrade-interactive <- important to run periodically!
11:30 bundle update


### 2022-12-27

11:05 work on tasks for employee

### 2022-12-26

11:05 parameterize buttons, employee "tasks"
11:19 start work on tasks for employee
13:45 -

### 2022-12-21

07:03 finish documentation for NUXT site
09:30 fixing output on pos/employee stats_tab
12:30 etablish backup script on docker4
13:30 installing sniffnet - not that it works though 
14:20 fixing clicks on enter/leave buttons when other tabs are in focus

### 2022-12-20

07:30 Pilea product hunt
21:00 RT add PG_AFSNIT to bordprinter label

### 2022-12-19

09:45 system_parameters
20:05 depstage

### 2022-12-16

07:35 mail mm
08:30 support på stregkoder - Nordthy
09:00 Sindico - opkald Mia - voicemail
09:15 ret lagervare navn når produkt navn rettes
10:15 support på TTF - Firewalla
10:30 service component to every controller
14:15 RT ny bruger på Vindø
14:30 service component to every controller
15:30 allow delete for role and punch_clock
16:40 depstage

### 2022-12-15

06:40 Nordthy forligs- / statusmøde
13:30 gennemgå timeregistrering m/Bo til Elmelund
17:35 printserver ip/port

### 2022-12-14

07:45 glemt

### 2022-12-13

07:45 glemt

### 2022-12-12

07:45 email from LHL RT
08:15 planlæg PILEA m/Andreas
09:05 RT problem med printserver på Vindø - rootCA.pem faldet ud (igen)
11:30 printserver Vindø printer ikke korrekt spillekort
15:30 asset_work_transactions + asset_workday_sum

### 2022-12-10

10:00 Move STEN to a new server on servicepoint
17:10 -

### 2022-12-09

07:15 forgot what I did today :(
14:15 -

### 2022-12-08

08:10 modals layout
10:36 asset_work_transaction & asset_workday_sum - calc time spent

### 2022-12-07

06:05 asset_workday_sum
08:30 pos/employees/:id/show layout
10:32 navigator.geopos
14:28 employee pbx_extension
16:54 get pos location data
19:30 modals layout
22:30 -


### 2022-12-06

06:40 asset_workday_sum
13:30 Sindico - markedsafsøgning
16:00 pause
19:30 asset_workday_sum
22:30 -

### 2022-12-05

06:55 asset_workday_sum
20:30 -

### 2022-12-04

09:35 background_jobs
16:45 asset_workday_sum
21:30 -

### 2022-12-03

09:45 background_jobs
20:00 -

### 2022-12-02

07:15 background_jobs
17:00 -

### 2022-12-01

06:45 background_jobs
12:00 maglev
13:00 translations

### 2022-11-30

07:05 asset_workday_sum
14:20 cron_task

### 2022-11-29

08:30 translations, refactoring regressions
13:00 meet Elmelund virtual
14:00 particulars ref counters
18:30 done

### 2022-11-28

08:30 awt calculations, cont'ed
14:30 setting up background_jobs - wip
      [setting up cron job in Dokku](https://github.com/dokku/dokku/issues/4695)

### 2022-11-25

08:30 awt calculations, cont'ed

### 2022-11-24

07:55 awt calculations
09:00 refactore token_approved, wip

### 2022-11-23

07:45 list_employees
11:50 awt calculations

### 2022-11-22

07:00 presentation to Elmelund
16:00

### 2022-11-21

08:00 working on punch_clocks

### 2022-11-20

08:00 working on asset_work_transactions and pupil_transactions

### 2022-11-18

08:00 working on pos/employees/:id

### 2022-11-17

08:00 working on pupil_transactions

### 2022-11-16

08:00 working on work_schedules

### 2022-11-15

08:00 working on work_schedules
21:00 problems with Google Material Symbols

yarn add material-symbols
cp material-symbols-outlined.woff2 assets/fonts
add path to application.rb

### 2022-11-14

08:00 working on work_schedules

### 2022-11-13

08:00 working on work_schedules

### 2022-11-12

08:00 working on work_schedules

### 2022-11-11

08:00 working on work_schedules

### 2022-11-10

08:00 working on work_schedules

### 2022-11-09

08:00 working on work_schedules

### 2022-11-08

08:00 working on work_schedules

### 2022-11-07

08:00 working on work_schedules

### 2022-11-04

08:00 working on work_schedules

### 2022-11-03

08:00 working on work_schedules

### 2022-11-02

stayed with Bo while Anne was in Münster on business
14:00 worked in the shop on planing some oak

### 2022-11-01

05:45 another super night's sleep - woke up to election day - took a piss at 4:30
08:15 voted - then drove to visit/work with my brother
15:30 added locations

stayed with Bo while Anne was in Münster on business

### 2022-10-31

05:45 been sleeping like a baby - after a busy weekend, redecorating the hall and stairways to the basement
08:15 Elmelund - have to redefine schedules!
13:36 `gem install jekyll bundler` && `jekyll new docs` && `cd docs && bundle add just-the-docs`
13:41 `bundle exec jekyll serve`
13:57 `yardoc --output-dir docs/dev app/**/*.rb`

### 2022-10-28

08:00 another day at the office
08:15 Elmelund - cont' work_schedule

### 2022-10-27

06:05 early rise - Anne went to Foldberg (with limited success)
07:05 Elmelund - cont' work_schedule

### 2022-10-26

06:55 decent sleep - 
07:05 Elmelund - cont' work_schedule

### 2022-10-25

06:50 decent sleep - 
07:05 Elmelund - cont' work_schedule

### 2022-10-24

07:30 slow morning - Ajs, Edith, and Albert stayed the weekend
09:10 cont' work_schedule
17:30 training

### 2022-10-21

07:55 late night - but finished arkivthy
08:20 working on backup on docker4
15:05 adding 3 view_components - menu, button_to, and service
17:10 adding work_schedule

### 2022-10-20

06:30 up and about - my tommy seems to have recovered :)
07:05 working on pos/employees
11:00 started working on arkivthy - strike rest of the day

### 2022-10-19

06:45 up and about - with some bowel problems
07:45 added activerecord-session_store
11:20 made omniauth login work
16:08 started on handling user_menu/services work individually
20:15 make sure pupils are not clickable unless employee is OUT

### 2022-10-18

07:10 started working on employees calendar - sync'ing with Microsoft
16:34 added a MiddlewareTracer to debug the racks middleware stacks

### 2022-10-17

06:30 started working on employees calendar - sync'ing with Microsoft
11:15 pulled all data from printserver in Gandrup (Randers Tegl)
18:15 done for now

### 2022-10-12

08:30 depstaging /pos/employees/:id

### 2022-10-05

07:05 starting well rested
08:00 answering/sending emails
08:30 cont' testing asset_workday_sums
13:15 fixing open form edge case
15:45 depstaging

### 2022-10-04

06:40 woke rather early
08:15 delivered PC 
10:10 got my 3rd jab - COVID19
11:05 arrived at DGB
11:15 testing asset_workday_sums 
19:05 done

### 2022-10-03

08:15 in DGB after a tough weekend in Valby
08:30 testing asset_workday_sums

### 2022-09-29

09:30 in DGB with too little sleep
11:00 start testing asset_work_transaction
13:00 added asset_workday_sum
14:20 added punch_clock

### 2022-09-28

08:05 at my desk in fairly ok condition
12:15 adding system_parameter
17:30 adding asset_work_transaction

### 2022-09-23

07:45 at my desk with a hurting neck
08:15 cont' with prepairing for meet monday
10:30 use toggleFormSleeve
11:20 move 'private'
13:40 set new button right for stock_locations on stock
14:10 catch bad resource_form return



### 2022-09-22

08:00 meet at Vindø Telgværk, Randers Tegl Hobro
10:25 at my desk after a somewhat terrible meet with Klaus at 
14:30 moving on with testing for meet monday with Nordthy

21-22:45 watched Denmark lose 1-2 to Croatia in Zagreb

### 2022-09-20

07:15 at my desk after a good nights sleep

08:30 cont' on buttons and real time update of pupils


### 2022-09-19

07:30 ready in the Office

11:15 started on buttons on the employee POS

### 2022-09-16

05:35 back from holidays in Spain - Madrid and Santa Pola

09:30 meeting with Sindico
15:30 starting to push changes to staging - issues with deployment: RUBYGEMS_ACTIVATION_MONITOR - and just above the ## DONE it says: always run dokku repo:purge-cache... which is what was wrong!

### 2022-09-05

07:10 another beautiful morning! Now we've slept on the porch for almost 1 month!

### 2022-08-30

07:10 slept ok - but my entire body still aches! Been going on for almost 14 days now! On and off - some days with fever, others days just tired as an entire care center!

* 

### 2022-08-09

06:40 started - still having this bad tooth ache

* pos/employee
* pupil

### 2022-08-08

06:45 started - with a bad tooth ache

* regression fix
* allow POS to load all pallets in stock for validation
* refactorings for POS
* run jobs in debug mode
* depstaging POS
* deviate from events controller on new_resource
* allow for create of teams 
  - (add Team - People are grouped into teams, either in a permanent position as fx a Sales rep in the Sales Team, or a temporary/matrix position as Data Analyst in the Finance Team/Department)
* depstage

### 2022-08-03

08:05 slept like a child

* testing goods shipping

16:
### 2022-08-02

08:45 slept like a child - but not long enough (had to finish Goliath season 1)

* testing goods shipping

16:10 done
### 2022-08-01

06:05 almost 100% recovered - and back from a much needed vacation :) 

* fix to stock_item

16:50 done

### 2022-07-18

08:35 much better - slept like a baby - this did me good!

* fixing a few show actions (stocked_location, more)
* 


### 2022-07-15

07:45 better - but still only 4-5 hrs sleep which is tough

* adjust menus to account changes to services
* added missing tabs method from tailwindcss-stimulus

### 2022-07-14

05:15 better - but 4hrs from 1:15 to 5:15 is NOT enough!

7:30 Foldberg
9:30 back in the trenches

* prepared STEN containers
* cont'd refactoring StockItemTransaction.create
* 17:17 depstaging


### 2022-07-13

09:15 not well - slept 5hrs from 3 to 8 w/o coughing

* cont'd refactoring StockItemTransaction.create
* 

17-ish Jonas Vingegaard won the 11th stage of Tour de France 2022 on Col de Granon and the yellow jersey!

### 2022-07-12

07:45 testing the form

* refactoring StockItemTransaction.create
* 

15:30 Foldberg

### 2022-07-11

08:30 no work today - headache and 'snot' :(

* showing location names on the POS



### 2022-07-07

08:30 nope - 4hrs from 10PM 'til 2:30AM and crumbles from 5 to 7:30

* make impersonate render menu
* work on creating a user

17:17 off to Valby, this time for a baptism of my grandson Max

### 2022-07-06

7:25 worse than yesterday

* uninstalled New Relic - guess we'll wait and see what monitor to use
* add employee asset resource
* add svg to menu items
* fix for combos
* fix to broadcast employee

21:30 hope I'll sleep

### 2022-07-05

6:55 fresh if not well

* attached account/logo
* make storage on staging.greybox.speicher.ltd persistent across deployments
* make logs on staging.greybox.speicher.ltd (and other apps for that matter) sit away from Dokku/Docker - inside journalctl
* install New Relic on Docker4

22:10 finalemento

### 2022-07-04

07:05 fresh is perhaps overstating the obvious but doing ok all things considered

* depstaging service_objects, take 1
* 12:18 always type * in search and lookup fields to have SPEICHER start presenting all the available items

22:50 done

### 2022-07-03

resting day - traveling back from Valby

### 2022-07-02

made pretty good progress with service objects - assets, and participants

### 2022-07-01

Didn't move much code today - watch Tour de France Grand Depart first hand from H.C.Andersens Boulevard
near Tivoli, Copenhagen

### 2022-06-30

08:15 - with Ibumetin in the blood I can almost exist

* cont' on time_zone - using https://nilssommer.de/articles/14-per-user-time-zone-configuration-in-rails
* issue with all backgroundjobs not knowing of current_account / current_user
* 16:41 switching to service_objects branch - testing the waters on that subject

### 2022-06-29

scratch this one - shitty as h...

### 2022-06-28

07:30 Nose been drippin' for a week - now it (finally turned into a full fleshed cold)

* change user_time_zone in ApplicationController to use current_user's timezone - once we have added the User Model
* add user profile with some rudimentary settings and ability to fx switch to DarkMode !?



### 2022-06-27

demoday at 11AM at Nordthy - went pretty well, perhaps saving the price model introduction which certainly could have been
handled a lot better!

### 2022-06-25/26

using the better part of the weekend to prepare for demo day

### 2022-06-24

07:15 with Anne back on track I can focus (albeit still on one eye only) again

* search Products
* testing stock_item_transactions POS

### 2022-06-23

07:15 with Anne back on track I can focus again

* first major issue regression - Sidekiq cannot create broadcasts for accounts (only them) `secret = request.key_generator.generate_key`
* turned out to be Sidekiq not knowing who current_user is!!
* 18:28 depstag'ing

22:10 slept on the porch first time this year
### 2022-06-22

08:45 a really slow start - Anne was in a bad shape this morning - luckily recovered during the day <3

* a (lot actually) loose ends on mobile
* 22:15 depstag'ing again

### 2022-06-21

07:15 will try my luck on the roads, I guess

* building for the mobile devices
* 18:57 - mostly done - depstag'ing this far


### 2022-06-20

06:05 stayin' at home - not feeling to safe in the traffic

* testing out some redirect's when token is not there - [should go to login](https://github.com/hotwired/turbo/issues/605) :(
* testing navigation errors on links like /stock_locations/:id - https://github.com/rails/rails/issues/39566 

18:45 Basta

### 2022-06-18

08:30 ouch - gettin' behind - but what to do?

* cleaning up infinite scroll - looks good so far
  

### 2022-06-15

07:10 finally saw that doctor - and it turned out to be necessary to have surgery 

* testing scan on staging

### 2022-06-10

06:39 kickin' and mostly alive - will need to see a doctor regarding my left eye though

* 06:48 role not handled well enogh
* 10:56 job processing outside current account
* 18:30 show active menu item
* 

### 2022-06-09

07:40 ready - kind'a - to attack another day

* 09:16 off to the 'Kirkekontoret'
* 13:07 fixed supplier_id as string on products/new
* 19:46 redo the calendar_id, optional
* 21:05 error in adding users - SystemStackError - stack level too deep

### 2022-06-08

04:30 Sent Anne off on a conference

* 06:45 stock_item_transactions list on stocks
* 11:15 add QRCode to Stock
* 12:45 start deploying to staging - beta 1
* 13:30 testing deploy
* 15:44 remove issue with missing current_account
* 15:50 deploy beta 2
* 19:10 error on logout from staging
* 19:50 transactions do not show up on staging

02:05 - roasted

### 2022-06-07

all day in Thisted - didn't get a single line added :(

### 2022-06-06

back from a holiday well spent in our summer cottage at the sea

* 18:30 started on SHIP stock_item_transactions

21:00 totally waisted - 

### 2022-06-03

a late start - overslept 'til 07:36

* 08:45 cont' debugging POS output
* 15:15 POS RECEIVE is 90% done
* 

### 2022-06-02

a somewhat late start - enjoyed a full 6hrs of sleep

* 08:15 starting to import the POS specific code
* 11:17 POS running - now start debugging the output
* 18:30 stopped - to go home and prepare for TOPGUN Maverick

00:15 good night 

### 2022-06-01

first day of summer - and we are yet to sleep outside this year

* 06:35 off to the races - cont' with products (the Supplier Combo is acting up)
* 10:48 products working - yeah
* 10:57 deploy staging version
* 12:31 combo_values_for_* missing on product
* 13:20 modable missing on product
* 13:34 stocked_products
* 14:43 stock
* 15:05 stock_location
* 17:30 paused to train
* 19:45 voted YES to drop the danish EU defense reservation - and the final say was a YES
* 20:43 on with stock_location
* 20:46 on with stocked_product
* 21:03 and then the stock_item (batch)
* 23:12 and then stock_item_transaction

### 2022-05-31

early rise - feelin' good after yesterdays training session

* 06:05 on with the refactor of menu, it's hotwire giving me a hard time, I'm afraid
* 08:25 refactor role and services
* 10:51 deploy current 
* 12:18 on with user, task, team
* 19:25 deploying events, teams, tasks
* 19:58 adding assets and suppliers - add third **main feature** - assets (products, work in progress, machinery, tools, trucks, SIM cards, and more)
* 22:40 pushing forward with products

23:30 I was clearly done




### 2022-05-30

monday bloody monday

* 06:45 get a hold on all the javascript components/controllers
* 09:10 mobile sidebar
* 11:12 form elements
* 11:55 delete dialog
* 12:47 add service after refactor
* 13:13 role refactor
* 16:18 menu refactor
* 17:10 paused to train
* 18:30 back on the subject

22:45 done

### 2022-05-29

after a relaxing weekend celebrating Mie's mother and father

* 17:10 userprofile dropdown
* 21:24 login/loogut
* 21:28 role & roleable
* 22:25 FormHeaderComponent

### 2022-05-27

a very very late start - almost finished my tax records for 2021

* 10:58 sidebar show/hide

### 2022-05-27

a very late start - drove by Hedemannsgade to pick up Ajs

* 09:30 cont' with components - Navigation::Sidebar
* 09:47 Resource::Form
* 11:04 shared/notifications
* 12:15 Navigation::Menu and Navigation::Search
* 13:10 Navigation::SuperUser
* 15:30 Jytte Berg - email issue
* 16:13 add resource_control, expand abstract_resources_controller, breadcrumb, parent_control, and more
* 16:23 add Current and abstract_resource.rb
* 16:44 add login/signup routes
* 16:45 add SessionsController
* 19:30 add Account
* 19:50 add Calendar
* 19:58 add Participant
* 19:58 add User
* 20:15 add Ancestry gem for tree-like relations between same-objects, like father-son
* 20:46 db:reset
* 21:37 add Authorization
* 22:02 deploy staging 
* 22:10 dokku ps:stop staging.greybox.speicher.ltd - dokku run staging.greybox.speicher.ltd rails db:reset DISABLE_DATABASE_ENVIRONMENT_CHECK=1 - dokku ps:start staging.greybox.speicher.ltd
* 22:18 add Service


### 2022-05-26

late start - it's 'Kr Himmelfartsdag' after all

* 15:05 redo that CHECKS thing
* 15:42 navigation - please - see tailwindui.com
* 15:48 start with components
* 16:46 setting client_control (variant templating) - https://reinteractive.com/posts/191-variants-with-ruby-on-rails 
* 18:23 let 'browser' decide - https://github.com/fnando/browser
* 18:48 add shared/takiro
  
19:05 done for now

### 2022-05-25

TIL - atm we have to run `dokku repo:purge-cache staging.greybox.speicher.ltd` on docker.alco.company to successfully push new deploys!

07:30 here we go again

* 07:42 dashboard
* 09:34 application layout
* 09:51 hotwire reload - https://github.com/kirillplatonov/hotwire-livereload
* 10:15 add Tailwind plugins typography and forms
* 10:35 add view_component
* 12:21 add paper_trail
* 12:52 start adding features to ApplicationController - cache_buster, switch_locale, user_time_zone
* 12:58 add locale
* 13:24 add Redis Key Value Store - run a docker-compose -d in the 'above' folder
* 13:49 add sidekiq - https://www.pedroalonso.net/blog/hosting-rails-in-dokku
* --- got slightly burnt by assets.debug=true in config/assets.rb (but all is good, I believe) -- 
* --- well only so much, now: ...redis_store (cannot load such file -- active_support/cache/redis_store) ---
* 18:03 add the RAILS_MASTER_KEY to the envs - https://dev.to/raaynaldo/the-power-of-rails-master-key-36fh
* 18:07 add storage directory - 
* 19:00 add background/queue worker for handset
* 22:35 add pagy - best pagination out there
* 22:37 add the abstract_resources_controller and the speicher_controller
* 23:42 add CHECKS

this is done

* use PostCSS processing (perhaps) - see speicher/hours/src/postss.config.js 


### 2022-05-24

06:43 rainy morning - after a bad dream - huh, not the ideal start

* 10:30 now (most) forms work as intended
* 10:40 cont' building first docker site
* 18:24 gave up on pushing current build to docker.alco.company - starting all over :(
* 22:41 ok - first deploy to staging.greybox.speicher.ltd HUZZA - https://dokku.com/docs/deployment/application-deployment/
* 22:47 done

### 2022-05-23

07:05 busy weekend - with friends and 'madklub'

* 08:05 just need forms to close
* 21:00 break for watching "Lions for Lambs"
* 22:55 and here we go again!
* 23:17 stopped testing the UI - gimme' 30 minutes tomorrow and I'm done :D

### 2022-05-20

06:45 I can feel it - today is the day

* 10:45 now tests are almost green

this is done
* implement authorization - by means of a RBAC model using roles, roles_users, and users - none (0), index (1), show (2), create (4), update (8), delete (16), print (32), export (64), 


17:45 Søs came from Valby and stayed the night

### 2022-05-19

06:50 pumped to get to the finish line with the select form control today!

* 09:20 search works, lists works, tags works (90%), drop down works - it's really coming through now!
* 10:15 starting on 'add' - when creating new items for a select combo
* 13:55 done! Well, the select combo still has a few kinks but it's like 98% done - and way good enough for now!
* 14:05 work on authorizations/permissions
  
23:55 kept working 'til the blood sprang

all officially done!
* lookup_field - see elements by mgodwin [here](https://discuss.hotwire.dev/t/triggering-turbo-frame-with-js/1622/32)
* multi_select_field
* tags - https://codepen.io/atomgiant/pen/QWjWgKz


### 2022-05-18

07:10 after a good nights sleep I'm ready to deal the final blow to the select form control!

* cont' with form control - set HTML on selected items in the UL list
* 09:23 on the home stretch - now implementing tags on the combo, ie using the combo to set a list of tags
* 15:07 first success with tags on the select form control! Now on to search

22:10 had to work on my kitchen walls - mud and paint
23:35 closed shop  
### 2022-05-17

07:05 just another day in the trenches - with Ajs down with fever

* cont' with the select form element
* 18:05 fixing some issues on the login and confirmation templates
* 18:36 back to last stretch on the select form element -

21:45 closed shop doing pretty good

### 2022-05-16

07:15 Fresh after a good nights sleep

* cont' on select form element - inbetween other tasks ie

23:45 out of juice

### 2022-05-12

Started working on Premier Is - done by 13:30

* cont' on select form element

### 2022-05-11

ALCO meet all day

### 2022-05-10

08:10 not 100% but getting there -

* started working on the infamous select!
* had to break for work on customer site 10-13:30

20:45 out cold!

### 2022-05-09

07:30 getting a head start on a sunny monday morning

* cont' with roles, roleables, teams, etc -- almost done 18:12


### 2022-05-07/8

sneaking away now and then to put in some time

* roles, roleables, teams, etc

### 2022-05-06

08:05 - cloudy morning and back and neck pains; dang!

* show nbr_pallets everywhere - 09:57
* cont' with allow users to be created on account - 99% done (requires confirmed_at to be set atm) - 15:00
* added is_a_god? 
* add roles - wip - 16:33


### 2022-05-05

07:45 - beat but still kickin'

* need to get the quantity on pallets shipped - 11:15 done
* stock_items not being set correctly at all times - pausing this 99% done at 17:43
* allow users to be created on account - 

paused at 20:15
### 2022-05-04

07:15 - fresh start - notes not comin' easy yet :/

* cont' adding sidekiq/active_job 
  * 13:15 backgroundjob ironed out and working
  * 17:25 git commit's
  * 17:35 starting to do small bugs/missing issues like
    * /products translations
    * link_to suppliers on products#show page
    * /suppliers#show
    * show stocks_id on various related pages like stock_locations#show
    * always show nbr_pallets
  * 19:55 - done

### 2022-05-03

10:33 - Starting to take notes, (again) :)

* need to add sidekiq/active_job in order to process events in a background job in an orderly fashion
  * so first vi add redis gem
  * and initializers/sidekiq.rb, et al
  * set config/cable.yml pointing to correct redis
  * add .env.development (and possibly .env.production)
  * 11:57 redis running/connected
  * add background job with `x rails g job stock_item_transaction_processing --queue=transactions
  * 14:00 background job works - and queue gets going - now we need the job to "do it's do"
  * 20:00 quit

### 2022-04-22 - 2022-04-24

Trying to make MySQL and Rails run off of ARM64 - but that is yet to come, sadly!


a huge gap because, for some reason I forgot to take notes! Big mistake!!

---

### VOID ENDS

* get hotwire'd - https://blog.cloud66.com/taking-rails-to-the-next-level-with-hotwire/


### VOID STARTS

### 2021-04-06

13:30 - other business done

* work on accounts as a muster for how to do CRUD

### 2021-03-22

07:30 - get going

* compile todo's - autocomplete et al
* generic button - like cancel_button, save_button, etc
* delete yes/no modal

### 2021-03-21

08:05 - sunday delight

* onwards to viewcomponents - first issue: install the gem as it is still a separate gem even in R6.1
* then add the new folder `/app/components` to the webpacker.yml - and add to `javascript/controllers/index.js`
* build first simpel one: section_header

21:45 - gotta' sleep

### 2021-03-20

08:45 - weapons hot

* by now the index/new/delete all work - but edit still 'hangs'
* finally! nailed the edit - and got the modal back at center positioning
* remember to document this!

18:30 - what a saturday night!

### 2021-03-19

07:15 - rock'n'roll

* work on Hotwire, Turbo & Stimulus
* got side tracked by resizing the index action list div's - most useful feature! see accounts/index for comments!
  
17:45 - done for now

### 2021-03-18

09:15 - so, after a slight detour - let's get going (again)

* add that Redis container
* add the Sidekiq container
* start fiddling with Hotwire

23:30 - quit

* when we have to add sidekiq - [here's how to do it](https://www.aloucaslabs.com/miniposts/how-to-install-sidekiq-to-a-ruby-on-rails-project-deployed-on-dokku-server) with Dokku, and further [read here](https://kukicola.io/posts/deploying-rails-6-application-with-dokku) too!


### 2021-03-12

07:15 - ready to rumble

* continuing with the GraphQL documentation
* 

### 2021-03-11

07:15 - ready to rumble

* cleaning up
* GraphQL documentation

18:00 - chow time

20:45 - another leg

* adding GraphQL queries to account, and appointments

23:45 - way past my bedtime

### 2021-03-10

08:45 - huh, I'm waisted!

* trying to get vue-tailwind to work
* continue with documenting the GraphQL API

18:15 - absolutely fried

### 2021-03-09

07:45 - a beautiful and sunny morning

* scrapped the swagger - in favour of GraphQL
* `hr bundle update` and `hr bundle add graphql --version="~>1.9"` 
* `hr rails g graphql:install`  + add to config/routes.rb
* `hr rails webpacker:install:vue`
* add vue-tailwind component library - `hr yarn add vue-tailwind`
* adding the vue-apollo client to the front-end

18:30 - potato soup w/ fried cauliflower

* start building out the GraphQL description
* add RSpec test environment
  
04:00 - bedtime!

### 2021-03-08

08:15 - ouch! Very productive weekend, helping my daughter and son-in-law 

* trying to use Swagger to documenting the API
* sketching the login views and appointments views

15:30 - wait for devs to answer

### 2021-03-05

07:00 - hit it!

* roles and users

13:00 - early weekend (well technically only context switching but whatever)

### 2021-03-04

11:30 - I got to stay up late last night, so this is an easy morning so far

* did some basic cleanups - nothing much to report
* include Authorize (the module handling the authorization)

17:00 - gotta' shop dinner 

22:00 - just a few more minutes

* roles and roles_users
* 

01:00 and it's a wrap for the day
  
### 2021-03-03

07:30 - another wonderful sunny day - it's easy gettin' used to!

* tables with appointments
* STI AbstractEvent -> [ Event | Appointment | ... ]
* adding 'ancestry' gem affording tree-like hierachies of anything really
* added Appointment model

19:30 - dinner

* adding some graphics for the dashboard
* starting on the documentation for the demo
* updating project plans and compiling a demo w/notes

04:30 - nighty nighty

### 2021-03-02

07:10 - what a wonderful sunny morning for a chance!

* now calendar is starting to come along quite nicely thank you

17:45 - a walk, some dinner, and an episode of 'Behind Her Eyes'

21:00 - second leg of the day

* a few finishing touched to the calendar UI (at least for now)

23:30 - Good Night Irene

### 2021-03-01

07:30 - woke myself coughing my lungs out, might as well start working

* calendar, now, plz!

16:30 - visitors! A first for ages

### 2021-02-28

11:30 - what a blunder on a Sunday

* add favicon
* git'ing changes from yesterday - "sloppy joe"
* make main menu work with 'white theme'
* checking up with https://github.com/jfahrer/dockerizing_rails - got an issue with some images not getting 'webpacked'
* working on the calendar

02:30 - absolutely no more fuel

### 2021-02-27

on a (almost) shiny Saturday it's a joy to find your workbench all set to go!

08:30 - and we're off

* house-keeping, getting stuff straightened out and put in place
* add docker-compose.yml, and .env for environment variables
* add ice_cube for recurring events
* ~~start af PostgreSQL database i container `docker run -d --name scoop-postgres -e POSTGRES_PASSWORD=Pass2020! -v /Users/walther/src/scoop_rover/db/postgres-data/:/var/lib/postgresql/data -p 5432:5432 postgres`~~ it's all a docker-compose.yml thing now
* adding menus and menu_items making menus configurable - this could be really good!
* setting up hermes.speicher.ltd + postgres + redis services
  
```  
       Waiting for container to be ready
       Creating container database
       Securing connection to database
=====> Postgres container created: hermes_staging
=====> hermes_staging postgres service information
       Config dir:          /var/lib/dokku/services/postgres/hermes_staging/data
       Data dir:            /var/lib/dokku/services/postgres/hermes_staging/data
       Dsn:                 postgres://postgres:9f96b01cd2f33c6220814e2f8bd2a272@dokku-postgres-hermes-staging:5432/hermes_staging
       Exposed ports:       -                        
       Id:                  2b8fb58806dfe7b04df6cc558fb7e33b0c9558df21aebfdd814b208c58e3c336
       Internal ip:         172.17.0.5               
       Links:               -                        
       Service root:        /var/lib/dokku/services/postgres/hermes_staging
       Status:              running                  
       Version:             postgres:11.6            
       DATABASE_URL:  postgres://postgres:9f96b01cd2f33c6220814e2f8bd2a272@dokku-postgres-hermes-staging:5432/hermes_staging

root@docker1:~# dokku redis:create hermes_staging
       Waiting for container to be ready
=====> Redis container created: hermes_staging
=====> hermes_staging redis service information
       Config dir:          /var/lib/dokku/services/redis/hermes_staging/config
       Data dir:            /var/lib/dokku/services/redis/hermes_staging/data
       Dsn:                 redis://:f86fa3ff225b3ccf76182908733e3962a96ffd42c3f41c4167d9e9d2dcdc589a@dokku-redis-hermes-staging:6379
       Exposed ports:       -                        
       Id:                  288c5aa444facab7e283a8679a864b9c60e9cd8b6fd0c01145c02b0e49b8b3e4
       Internal ip:         172.17.0.6               
       Links:               -                        
       Service root:        /var/lib/dokku/services/redis/hermes_staging
       Status:              running                  
       Version:             redis:5.0.7                    
       REDIS_URL:  redis://:f86fa3ff225b3ccf76182908733e3962a96ffd42c3f41c4167d9e9d2dcdc589a@dokku-redis-hermes-staging:6379 
```

02:30 - exiting but I have to stop


### 2021-02-26

\- but then just as when everything is about to fall apart, the Sun starts to shine and hands you all you need to keep going!

09:45 - ohh this really does hurt now!
****
* TIL and in [no small part thanks to Ross](https://rossta.net/blog/importing-images-with-webpacker.html) how Webpacker handles images !

02:30 - that'll have to do!


## 2021-02-25

this cold of mine - I mean - it's bad! Didn't I hear myself say this already?

08:10 - better get going

* I'm fighting just about everything today - my cold, and this f"€%&-ing Dokku thing, well and Webpacker, and really!

04:45 - okay I'm officially going to quit! This is just insane!

## 2021-02-24

this cold of mine - I mean - it's bad!

EDIT: This all turned into nothing! Now the database in a container - period!

07:05 - hit it

* whoa - big hole in my knowledge! Containers and brew installed PostgreSQL instances do NOT play well together!!
* have to repair my local postgres installation with `rm -rf db/postgres-data/*`  `initdb --pgdata=db/postgres-data/ --encoding=utf8  --locale=en_US --username=postgres -W`
* which includes `DATABASE_URL="postgres://postgres:postgres@postgres/scoop_rover?encoding=utf8&pool=5&timeout=5000" rails db:reset`
* and - no - not `rails c`; all you have to do is `spring stop` first! Then open the console - tricky :)
* now where are my assets? 
* that will have to come - after the break
* add [web app to a container](https://firehydrant.io/blog/developing-a-ruby-on-rails-app-with-docker-compose/)

18:38 - have to stretch my legs and eat something

## 2021-02-23

got myself another one of those long-toothed infections where my nasal cavaties fill with pus - yuck!

07:30 - woke 6:10 with my head full of - well pus - what a way to start a glorious new day?!

* committing stuff from the last two days work
* ignoring .DS_Store files (a macOS thing with) `find . -name .DS_Store -print0 | xargs -0 git rm -f --ignore-unmatch`
* structuring partials around the generic 'list' (/index) action
* added Sidekiq for background jobs

19:15 - now it's time to go get a burger - from Hugo's burgerbar :)

20:30 - that was a lot of meat, well tasting though!

* building a default Docker-ready Rails environment 
* added TailwindCSS forms, typography, and aspect-ratio
* started building the Docker containers - with help from among others https://semaphoreci.com/community/tutorials/dockerizing-a-ruby-on-rails-application 
* `docker-compose run hermes rake db:reset` and now we have development env up and running - but with no Tailwind or assets
* Setting up production purging of superflous TailwindCSS classes
  
23:45 - done and waisted

## 2021-02-22

damn cold - will have to go easy on my self for a while

07:30 - rise and shine some more

* make the global keyboardhandler work like a charm
* add RTF to the event - https://oozou.com/blog/using-actiontext-in-rails-6-85 

17:15 - need a walk and some chow

22:15 - second leg

* safety upload to doing `git remote add gitlab https://gitserver.alco.dk:walther/hermes/v1.git` and `git push -u gitlab --tags`
  
23:59 - no more battery Asiz!

## 2021-02-21

no, no tagfield to day - I've got a cold and need to do something which I don't have to think too much about; any chance?

08:15 - giddy-up

* do steps on the add appointment modal to make it easy

10:15 - having my grandchildren on visit; that stops the press 

13:15 - saw them off and then back to the workbench

* adding trial routes for events, contacts, orders, leads, reports, and more
* apply current git-version to the dashboard for reference

17:30 - Sunday bloody Sunday 

## 2021-02-20

let's leave that tag-field for a moment and build some momentum

07:45 - rise and shine, on a Saturday OMG

* foundation for keyboard handler in application.html.haml - affording Esc-a (add an appointment), Esc-b through Esc-z, and more
* format a modal right
* make sure we set the time right
* likewise make sure to do proper localization
* call modal from dashboard - check
* clear modal - check
* send modal - check

02:25 - this is crazy, but what can I do?

## 2021-02-19

07:45 - early birdish, after a very good night's sleep

* and then on to the tag_field - we'll need it for adding recipients and assignees too

14:15 - it's Friday and it's been one heck of a week 

## 2021-02-18

08:30 oh boy is my body hurting now!

even though we got busy interviewing developers I like to think I had good traction

* moving on with checkbox
* have to move all Coffeescript into neutral corner :D
* with `rails webpacker:install:coffee` affords loading coffee script resources
* next up is text_field

17:00 that'll have to do for now
 

## 2021-02-17

08:00 Another day to die

This was a gastly day productive-wise - praying for a better tomorrow - but it too will hold its challenges: we're interviewing in the morning!

* add chokidar to have easy reload of views

19:45 breaking for late supper

* got the select_field down - only one heck of a lot of field types left

02:00 finalemento for now

## 2021-02-16

08:00 Rise and shine

* logo and colorize /signin
* colorize notifications
* notifications show/hide
* localise /signin
* add sidebar 
* add first **main feature** - calendars (and their events); we'll expand on the Event and utilize EventModel Patterns (however subtle) further down the road
* add Partner
* add Person
* add button for add event - and build rendering partials 
  
18:45 break for dinner

21:00 and we're live

* add event modal - display modal done

22:15 have to give in for the day

## 2021-02-15

06:45 of to the races

* set default language to danish - `gem 'rails-i18n'` and `bundle install` and setup _config/application.rb_
* set time_zone on current user
* add Hotwire for PubSub
* a great job by Chris Oliver with [simple_calendar](https://gorails.com/episodes/vlog-day-6?autoplay=1)
* [add AlpineJS](https://davidteren.medium.com/tailwindcss-2-0-with-rails-6-1-postcss-8-0-9645e235892d) for sprinkling on the DOM - and throw in **alpine-magic-helpers** and **alpine-turbo-drive-adapter** for kicks


17:45 we break for Corona testing!

20:00 back to the trenches

* get the background right - the Powerpoint is far to dark
* add hero for landing_page
* add Mejerigaarden logo - TODO better quality from marketing - masked positive
* add navbar
* started building a dashboard (example)

01:30 no more juice in the code guns


## 2021-02-12

07:45 auch - body hurts

* tests still not running smoothly - having trouble with the C in CRUD on controller tests

08:30 paused due to meet

10:45 resume

* sometimes testing is stating the obvious `ActiveModel::Error attribute=user_name, type=taken, options={:value=>"mystring1"}` which actually is a good thing - 'cause it makes us write more and better tests!
* add another _small_ **feature** - action_text which will allow for very nice content management - perhaps not on par with Word but close enough - use [this gist](https://gist.github.com/adrienpoly/e318bd9f559d487cffb11eb84ead2655) - yet actiontext is part of Rails 6.1.3 already. Now _just_ add `has_rich_text :content` to any model, update the **_form**, and remember to add **:content** to [class]_params
* add yet another **feature** - ActiveStorage affording attachments onto every record; use [this post](https://pragmaticstudio.com/tutorials/using-active-storage-in-rails) to do the lifting

13:30 weekend came to soon 
### 2021-02-11

08:30 encore

making considerable more progress - what a joy!

* initial `rails new hermes`
* setup `bin/development` to run development workbench
* ~~ignore /db/postgres-data and /dump.rdb~~ [26/2/21 now this is all in containers and volumes/handled by Docker]
* run `rails db:create` to ascertain the connection to the DB
* add PaperTrail gem for versioning of tables
* add CoffeeScript gem for easy javascript
* add Haml for HTML/CSS sugar
* run `bundle install`to pick up gems added
* add a landing_page - `rails g controller landing_page index` - and add `root to: "landing_page#index"` to `config/routes.rb`
* add TailwindCSS - use [this work](https://willschenk.com/articles/2020/tailwind_and_rails/)
* make HTML files all new again with `for f in **/*.html.erb; do html2haml $f ${f/\.html\.erb/.html.haml}; rm $f; done`
* add first datatable - versioning - `rails g paper_trail:install` - and close the stunt with `rails db:migrate`
* add cornerstone table - accounts - allowing this to run as a multi-tenant SaaS; `rails g scaffold account partner_id:bigint name service_plan`
* remember to allow Account to inherit from VersionedRecord, and as usual - `rails db:migrate`
* immediately following the Account, here goes Participant which is _the second most important class_ - `rails g model participant account:references name ancestry`
* add _has_secure_password_ - follow [this excellent work](https://gist.github.com/iscott/4618dc0c85acb3daa5c26641d8be8d0d)
* initially we'll need a user - `rails g scaffold user account:references participant:references user_name password_digest`
* make sure PaperTrail knows who's at the steering wheel -  `before_action :set_paper_trail_whodunnit` in ApplicationController - once `current_user` has been implemented

11:45 closing shop for now - has to attend a funeral

15:30 and again

better give testing some thought - coverage is rather bleak atm :( but than again it's not mission critical business logic we're rolling, not yet!

* make sessions new, create, destroy green
* make CRUD actions on accounts and users pass - presented a small challenge as part of the testing framework has been 'rewired' in recent years and this is really my first TDD journey for quite some time

19:15 hunger sets in

21:15 this will be a brief epilog for the day

* that challenge which dinner so abruptly forced me to part with - turned out to be little more than `<%= BCrypt::Password.create('MyString', cost: 5) %>` inside _fixtures/users.yml_ - the rest had been prepared already
* one of the minor **features** is for records to be taggable - `rails g scaffold tag name taggables_count`
 
22:00 better hit the sack - three very late nights is one too many


### 2021-02-10

13:15 ignition

spent ~14hrs - closing shop at 03:15AM - to no avail due to latest library updates all around the 'table' >:( but such is life, but what a bummer to start off on a project with such a wrong turn :(

03:15 burnt down


## DIDN'T HAPPEN

_things that went sour_:

* trying to run things in ARM64 on my MBA M1
* add heruku deploy'ability - `brew tap heroku/brew && brew install heroku`
* finish the setup by logging in using the browser
* create the heroku app - `heroku create`
```
Creating app... done, ⬢ peaceful-gorge-29043
https://peaceful-gorge-29043.herokuapp.com/ | https://git.heroku.com/peaceful-gorge-29043.git
```
* login - `heroku container:login`
* push the container - `heroku container:push web`
* and release it with - `heroku container:release web`
* now add a postgresql container - `heroku addons:create heroku-postgresql:hobby-dev`
```
Creating heroku-postgresql:hobby-dev on ⬢ peaceful-gorge-29043... free
Database has been created and is available
 ! This database is empty. If upgrading, you can transfer
 ! data from another database with pg:copy
Created postgresql-defined-08958 as DATABASE_URL
Use heroku addons:docs heroku-postgresql to view documentation
```  
* define envs - `heroku config:set RAILS_ENV=production SECRET_KEY_BASE=poi123987jh_nmxvchkktsdf RAILS_LOG_TO_STDOUT=true`
* test basic migration command - `heroku run rails db:migrate`
* add heroku host to config.hosts - 
* add heroku Redis addon `heroku addons:create heroku-redis:hobby-dev`
* woops wrong ruby! `asdf install ruby 3.0.0 && asdf local ruby 3.0.0 && asdf reshim`
* application.js missing!?! 
* trying with adding yarn to Dockerfile - check!
* and let's migrate immediately - `docker-compose run --rm web rails db:migrate`
* documenting VersionedRecord class which most other models will inherit from

