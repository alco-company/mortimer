# Knowledgebase

## Particular sets of commands

### deploying to staging

! always run `dokku repo:purge-cache staging.greybox.speicher.ltd` before deploying - or better - just run 'bin/depstage'

### upgrading just dokku

```bash
apt-get update
apt-get install --no-install-recommends dokku
```

### how to work with rake

[This post defines most of what is to say about rake tasks](https://www.rubyguides.com/2019/02/ruby-rake/)
[How to access Rails ActiveRecord models from inside rake tasks](https://dev.to/software_writer/how-to-access-rails-activerecord-models-inside-a-rake-task-5c76)


## cannot delete instance using the delete modal

And if you look in the log you see something like

```
Started GET "/punch_clocks/modal?ids=2&action_content=delete" for ::1 at 2022-12-16 16:12:21 +0100
Processing by PunchClocksController#show as HTML
  Parameters: {"ids"=>"2", "action_content"=>"delete", "id"=>"modal"}
  User Load (0.2ms)  SELECT "users".* FROM "users" WHERE "users"."session_token" = $1 LIMIT $2  [["session_token", "[FILTERED]"], ["LIMIT", 1]]
  ↳ app/controllers/concerns/authentication.rb:81:in `set_current_user'
  Profile Load (0.3ms)  SELECT "profiles".* FROM "profiles" WHERE "profiles"."deleted_at" IS NULL AND "profiles"."user_id" = $1 LIMIT $2  [["user_id", 1], ["LIMIT", 1]]
  ↳ app/models/user.rb:24:in `time_zone'
--------------------------------------------------------
Current.account 1
--------------------------------------------------------
  Account Load (0.5ms)  SELECT "accounts".* FROM "accounts" WHERE "accounts"."deleted_at" IS NULL AND "accounts"."id" = $1 LIMIT $2  [["id", 1], ["LIMIT", 1]]
  ↳ app/controllers/concerns/authentication.rb:94:in `set_current_account'
  PunchClock Load (0.7ms)  SELECT "punch_clocks".* FROM "punch_clocks" INNER JOIN "assets" ON "assets"."deleted_at" IS NULL AND "assets"."account_id" = $1 AND "assets"."assetable_type" = $2 AND "assets"."assetable_id" = "punch_clocks"."id" WHERE "punch_clocks"."id" = $3 LIMIT $4  [["account_id", 1], ["assetable_type", "PunchClock"], ["id", nil], ["LIMIT", 1]]
  ↳ app/controllers/concerns/resource_control.rb:54:in `resource'
Redirected to http://localhost:3000/punch_clocks
Completed 302 Found in 13ms (ActiveRecord: 2.0ms | Allocations: 4569)

```

### Solution for delete instance problem

remember to add `, concerns: [:cloneable, :modalable, :selectable]` to the resource - this is what adds the necessary routes to the resource!

## cannot scan more than one StockItem using the POS

Using a scanner and the [link for the POS](https://greybox.speicher.ltd/pos/stocks/3?api_key=xxxx) it's impossible to add more than one stock_item - typing in barcodes, however, works flawlessly

### Solution for pos problem

Test the barcodes - make sure no extra chars are added when generated!
