#ENV['RAILS_ENV'] ||= 'development'
ENV['RAILS_ENV'] ||= 'production'

# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Kapiqua25::Application.initialize!
