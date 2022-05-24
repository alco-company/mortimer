# Creating the greybox

## Installation

 1000  exit
 1001  which asdf
 1002  asdf -v
 1003  asdf
 1004  brew install gpg gawk
 1005  asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
 1006  asdf list all nodejs 16
 1007  asdf install nodejs latest
 1008  asdf global nodejs latest
 1009  asdf list all ruby 3
 1010  asdf plugin list
 1011  asdf plugin update --all
 1012  asdf list all ruby 3
 1013  asdf install ruby 3.1.2
 1014  pwd
 1015  clear
 1020  git status
 1021  git push gitserver development:development
 1022  clear
 1023  rails
 1024  ruby -v
 1025  gem
 1026  gem -v
 1027  which gem
 1028  clear
 1029  gem install rails
 1030  clear
 1031  rails -h
 1032  git status
 1033  rails new . -d postgres -c tailwind -j esbuild
 1034  rails new . -d postgresql -c tailwind -j esbuild
 1035  clear
√ src % 
1001  brew install libpq
 997  ssh docker4
  998  ssh docker4 -lroot
  999  ssh docker4 -lroot
 1000  exit
 1001  brew install libpq
 1002  vi README.md
 1003  clear
 1004  history
 1005  vi README.md
 1006  locate pg_config
 1007  more /opt/homebrew/Cellar/libpq/14.2/bin/pg_config
 1008  ls /opt/homebrew/Cellar/libpq/14.2/bin/pg_config
 1009  ls /opt/homebrew/Cellar/libpq/14.2/bin
 1010  brew install libpq
 1011  brew info libpq
 1012  vi ~/.zshrc (to have libpq in PATH etc)
1048  gem update bundler
1012  brew upgrade node
 1013  node -v
 1014  asdf list nodejs
 1015  asdf local nodejs 18.2.0


### Install Rails 

√ greybox % rails new . -d postgresql -c tailwind -j esbuild                                       
       exist  
      create  README.md
      create  Rakefile
   identical  .ruby-version
      create  config.ru
      create  .gitignore
   identical  .gitattributes
      create  Gemfile
         run  git init from "."
Reinitialized existing Git repository in /Users/walther/Deling/Walther/src/speicher/greybox/greybox/.git/
      create  app
      create  app/assets/config/manifest.js
      create  app/assets/stylesheets/application.css
      create  app/channels/application_cable/channel.rb
      create  app/channels/application_cable/connection.rb
      create  app/controllers/application_controller.rb
      create  app/helpers/application_helper.rb
      create  app/jobs/application_job.rb
      create  app/mailers/application_mailer.rb
      create  app/models/application_record.rb
      create  app/views/layouts/application.html.erb
      create  app/views/layouts/mailer.html.erb
      create  app/views/layouts/mailer.text.erb
      create  app/assets/images
      create  app/assets/images/.keep
      create  app/controllers/concerns/.keep
      create  app/models/concerns/.keep
      create  bin
      create  bin/rails
      create  bin/rake
      create  bin/setup
      create  config
      create  config/routes.rb
      create  config/application.rb
      create  config/environment.rb
      create  config/cable.yml
      create  config/puma.rb
      create  config/storage.yml
      create  config/environments
      create  config/environments/development.rb
      create  config/environments/production.rb
      create  config/environments/test.rb
      create  config/initializers
      create  config/initializers/assets.rb
      create  config/initializers/content_security_policy.rb
      create  config/initializers/cors.rb
      create  config/initializers/filter_parameter_logging.rb
      create  config/initializers/inflections.rb
      create  config/initializers/new_framework_defaults_7_0.rb
      create  config/initializers/permissions_policy.rb
      create  config/locales
      create  config/locales/en.yml
      create  config/master.key
      append  .gitignore
      create  config/boot.rb
      create  config/database.yml
      create  db
      create  db/seeds.rb
      create  lib
      create  lib/tasks
      create  lib/tasks/.keep
      create  lib/assets
      create  lib/assets/.keep
      create  log
      create  log/.keep
      create  public
      create  public/404.html
      create  public/422.html
      create  public/500.html
      create  public/apple-touch-icon-precomposed.png
      create  public/apple-touch-icon.png
      create  public/favicon.ico
      create  public/robots.txt
      create  tmp
      create  tmp/.keep
      create  tmp/pids
      create  tmp/pids/.keep
      create  tmp/cache
      create  tmp/cache/assets
      create  vendor
      create  vendor/.keep
      create  test/fixtures/files
      create  test/fixtures/files/.keep
      create  test/controllers
      create  test/controllers/.keep
      create  test/mailers
      create  test/mailers/.keep
      create  test/models
      create  test/models/.keep
      create  test/helpers
      create  test/helpers/.keep
      create  test/integration
      create  test/integration/.keep
      create  test/channels/application_cable/connection_test.rb
      create  test/test_helper.rb
      create  test/system
      create  test/system/.keep
      create  test/application_system_test_case.rb
      create  storage
      create  storage/.keep
      create  tmp/storage
      create  tmp/storage/.keep
      remove  config/initializers/cors.rb
      remove  config/initializers/new_framework_defaults_7_0.rb
         run  bundle install
Fetching gem metadata from https://rubygems.org/...........
Resolving dependencies...
Using rake 13.0.6
Using minitest 5.15.0
Using racc 1.6.0
Using crass 1.0.6
Using builder 3.2.4
Using digest 3.1.0
Using timeout 0.2.0
Using nio4r 2.5.8
Using rack 2.2.3
Using strscan 3.0.3
Using public_suffix 4.0.7
Using bundler 2.3.14
Using concurrent-ruby 1.1.10
Using websocket-extensions 0.1.5
Using matrix 0.4.2
Using bindex 0.8.1
Using marcel 1.0.2
Using msgpack 1.5.1
Using io-console 0.5.11
Using erubi 1.10.0
Using regexp_parser 2.4.0
Using childprocess 4.1.0
Using rexml 3.2.5
Using rubyzip 2.3.2
Using zeitwerk 2.5.4
Using mini_mime 1.1.2
Using method_source 1.0.0
Using net-protocol 0.1.3
Using thor 1.2.1
Using sprockets 4.0.3
Using i18n 1.10.0
Using bootsnap 1.11.1
Using reline 0.3.1
Using puma 5.6.4
Using rack-test 1.1.0
Using addressable 2.8.0
Using tzinfo 2.0.4
Using mail 2.7.1
Using net-imap 0.2.3
Using irb 1.4.1
Using activesupport 7.0.3
Using pg 1.3.5
Using net-pop 0.1.1
Using nokogiri 1.13.6 (arm64-darwin)
Using websocket-driver 0.7.5
Using net-smtp 0.3.1
Using selenium-webdriver 4.1.0
Using rails-dom-testing 2.0.3
Using activemodel 7.0.3
Using xpath 3.2.0
Using debug 1.5.0
Using webdrivers 5.0.0
Using loofah 2.18.0
Using globalid 1.0.0
Using activejob 7.0.3
Using capybara 3.37.1
Using rails-html-sanitizer 1.4.2
Using activerecord 7.0.3
Using actionview 7.0.3
Using jbuilder 2.11.5
Using actionpack 7.0.3
Using actioncable 7.0.3
Using activestorage 7.0.3
Using actionmailer 7.0.3
Using railties 7.0.3
Using sprockets-rails 3.4.2
Using actionmailbox 7.0.3
Using cssbundling-rails 1.1.0
Using jsbundling-rails 1.0.2
Using stimulus-rails 1.0.4
Using turbo-rails 1.1.1
Using web-console 4.2.0
Using actiontext 7.0.3
Using rails 7.0.3
Bundle complete! 16 Gemfile dependencies, 74 gems now installed.
Use `bundle info [gemname]` to see where a bundled gem is installed.
         run  bundle binstubs bundler
       rails  javascript:install:esbuild
Compile into app/assets/builds
      create  app/assets/builds
      create  app/assets/builds/.keep
      append  app/assets/config/manifest.js
      append  .gitignore
      append  .gitignore
Add JavaScript include tag in application layout
      insert  app/views/layouts/application.html.erb
Create default entrypoint in app/javascript/application.js
      create  app/javascript
      create  app/javascript/application.js
Add default package.json
      create  package.json
Add default Procfile.dev
      create  Procfile.dev
Ensure foreman is installed
         run  gem install foreman from "."
Successfully installed foreman-0.87.2
Parsing documentation for foreman-0.87.2
Done installing documentation for foreman after 0 seconds
1 gem installed
Add bin/dev to start foreman
      create  bin/dev
Install esbuild
         run  yarn add esbuild from "."
yarn add v1.22.18
info No lockfile found.
[1/4] 🔍  Resolving packages...
[2/4] 🚚  Fetching packages...
[3/4] 🔗  Linking dependencies...
[4/4] 🔨  Building fresh packages...
success Saved lockfile.
success Saved 2 new dependencies.
info Direct dependencies
└─ esbuild@0.14.39
info All dependencies
├─ esbuild-darwin-arm64@0.14.39
└─ esbuild@0.14.39
✨  Done in 1.39s.
Add build script
         run  npm set-script build "esbuild app/javascript/*.* --bundle --sourcemap --outdir=app/assets/builds" from "."
         run  yarn build from "."
yarn run v1.22.18
$ esbuild app/javascript/*.* --bundle --sourcemap --outdir=app/assets/builds

  app/assets/builds/application.js      55b 
  app/assets/builds/application.js.map  93b 

✨  Done in 0.12s.
       rails  turbo:install stimulus:install
Import Turbo
      append  app/javascript/application.js
Install Turbo
         run  yarn add @hotwired/turbo-rails from "."
yarn add v1.22.18
[1/4] 🔍  Resolving packages...
[2/4] 🚚  Fetching packages...
[3/4] 🔗  Linking dependencies...
[4/4] 🔨  Building fresh packages...
success Saved lockfile.
success Saved 3 new dependencies.
info Direct dependencies
└─ @hotwired/turbo-rails@7.1.3
info All dependencies
├─ @hotwired/turbo-rails@7.1.3
├─ @hotwired/turbo@7.1.0
└─ @rails/actioncable@7.0.3
✨  Done in 3.89s.
Run turbo:install:redis to switch on Redis and use it in development for turbo streams
Create controllers directory
      create  app/javascript/controllers
      create  app/javascript/controllers/index.js
      create  app/javascript/controllers/application.js
      create  app/javascript/controllers/hello_controller.js
Import Stimulus controllers
      append  app/javascript/application.js
Install Stimulus
         run  yarn add @hotwired/stimulus from "."
yarn add v1.22.18
[1/4] 🔍  Resolving packages...
[2/4] 🚚  Fetching packages...
[3/4] 🔗  Linking dependencies...
[4/4] 🔨  Building fresh packages...
success Saved lockfile.
success Saved 1 new dependency.
info Direct dependencies
└─ @hotwired/stimulus@3.0.1
info All dependencies
└─ @hotwired/stimulus@3.0.1
✨  Done in 1.71s.
       rails  css:install:tailwind
Build into app/assets/builds
       exist  app/assets/builds
   identical  app/assets/builds/.keep
File unchanged! The supplied flag value not found!  app/assets/config/manifest.js
Stop linking stylesheets automatically
        gsub  app/assets/config/manifest.js
File unchanged! The supplied flag value not found!  .gitignore
File unchanged! The supplied flag value not found!  .gitignore
Remove app/assets/stylesheets/application.css so build output can take over
      remove  app/assets/stylesheets/application.css
Add stylesheet link tag in application layout
File unchanged! The supplied flag value not found!  app/views/layouts/application.html.erb
      append  Procfile.dev
Add bin/dev to start foreman
   identical  bin/dev
Install Tailwind (+PostCSS w/ autoprefixer)
      create  tailwind.config.js
      create  app/assets/stylesheets/application.tailwind.css
         run  yarn add tailwindcss@latest postcss@latest autoprefixer@latest from "."
yarn add v1.22.18
[1/4] 🔍  Resolving packages...
[2/4] 🚚  Fetching packages...
[3/4] 🔗  Linking dependencies...
[4/4] 🔨  Building fresh packages...
success Saved lockfile.
success Saved 61 new dependencies.
info Direct dependencies
├─ autoprefixer@10.4.7
├─ postcss@8.4.14
└─ tailwindcss@3.0.24
info All dependencies
├─ @nodelib/fs.scandir@2.1.5
├─ @nodelib/fs.stat@2.0.5
├─ @nodelib/fs.walk@1.2.8
├─ acorn-node@1.8.2
├─ acorn-walk@7.2.0
├─ acorn@7.4.1
├─ anymatch@3.1.2
├─ arg@5.0.1
├─ autoprefixer@10.4.7
├─ binary-extensions@2.2.0
├─ braces@3.0.2
├─ browserslist@4.20.3
├─ camelcase-css@2.0.1
├─ caniuse-lite@1.0.30001342
├─ chokidar@3.5.3
├─ color-name@1.1.4
├─ cssesc@3.0.0
├─ defined@1.0.0
├─ detective@5.2.0
├─ didyoumean@1.2.2
├─ dlv@1.1.3
├─ electron-to-chromium@1.4.137
├─ escalade@3.1.1
├─ fast-glob@3.2.11
├─ fastq@1.13.0
├─ fill-range@7.0.1
├─ fraction.js@4.2.0
├─ fsevents@2.3.2
├─ function-bind@1.1.1
├─ glob-parent@5.1.2
├─ has@1.0.3
├─ is-binary-path@2.1.0
├─ is-core-module@2.9.0
├─ is-extglob@2.1.1
├─ is-glob@4.0.3
├─ is-number@7.0.0
├─ merge2@1.4.1
├─ micromatch@4.0.5
├─ minimist@1.2.6
├─ node-releases@2.0.5
├─ normalize-range@0.1.2
├─ object-hash@3.0.0
├─ path-parse@1.0.7
├─ picomatch@2.3.1
├─ postcss-js@4.0.0
├─ postcss-load-config@3.1.4
├─ postcss-nested@5.0.6
├─ postcss-selector-parser@6.0.10
├─ postcss@8.4.14
├─ queue-microtask@1.2.3
├─ quick-lru@5.1.1
├─ readdirp@3.6.0
├─ resolve@1.22.0
├─ reusify@1.0.4
├─ run-parallel@1.2.0
├─ supports-preserve-symlinks-flag@1.0.0
├─ tailwindcss@3.0.24
├─ to-regex-range@5.0.1
├─ util-deprecate@1.0.2
├─ xtend@4.0.2
└─ yaml@1.10.2
✨  Done in 2.07s.
Add build:css script
         run  npm set-script build:css "tailwindcss -i ./app/assets/stylesheets/application.tailwind.css -o ./app/assets/builds/application.css --minify" from "."
         run  yarn build:css from "."
yarn run v1.22.18
$ tailwindcss -i ./app/assets/stylesheets/application.tailwind.css -o ./app/assets/builds/application.css --minify

Done in 89ms.
✨  Done in 0.52s.
√ greybox % 
