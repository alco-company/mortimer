# we might need Redis' Sessions store down the road - [here's the low down](https://github.com/redis-store/redis-rails)
# or we might add sessions to the database - search TODO's for 'session'


# added this to Gemfile
# Session storage in database
# gem 'activerecord-session_store', '~> 2.0.0'

# added this migration for storing sessions in the DATABASE
#
# class AddSessionsTable < ActiveRecord::Migration[7.0]
#   def change
#     create_table :sessions do |t|
#       t.string :session_id, :null => false
#       t.text :data
#       t.timestamps
#     end

#     add_index :sessions, :session_id, :unique => true
#     add_index :sessions, :updated_at
#   end
# end

Rails.application.config.session_store :active_record_store, :key => '_takiro_session'