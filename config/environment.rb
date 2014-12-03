# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

# Here is some code
ActionMailer::Base.delivery_method = :smtp

# Set up mailer settings
ActionMailer::Base.smtp_settings = {
  :user_name => 'thecomparitor@gmail.com',
  :password => 'kemeny.snell',
  :domain => 'gmail.com',
  :address => 'smtp.gmail.com',
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}