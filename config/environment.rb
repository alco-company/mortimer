# Load the Rails application.
require_relative "application"

# Load OAuth settings
oauth_environment_variables = File.join(Rails.root, 'config', 'oauth_environment_variables.rb')
load(oauth_environment_variables) if File.exist?(oauth_environment_variables)

ActionMailer::Base.smtp_settings = {
  :user_name => 'apikey', # This is the string literal 'apikey', NOT the ID of your API key
  :password => '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', # This is the secret sendgrid API key which was issued during API key creation
  :domain => 'alco.dk',
  :address => 'smtp.sendgrid.net',
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}

# Initialize the Rails application.
Rails.application.initialize!
