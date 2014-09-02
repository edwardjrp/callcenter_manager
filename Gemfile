source 'https://rubygems.org'

#gem 'rails', '3.2.11' #pg gem is behaving weird and app is crashing completely
#gem 'rails', '3.2.19'
gem 'rails', '4.0.9'


#On Rail 4, Model based mass assignment security has been extracted out of Rails into a gem
#This will use the old way
gem 'protected_attributes'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'

# Gems used only for assets and not required
# in production environments by default.

gem 'jquery-rails'

group :assets do
  gem 'sass-rails'  #, '~> 3.2.3'
  gem 'coffee-rails' #, '~> 3.2.1'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby
  gem 'uglifier' #, '>= 1.0.3'
end

#On Rail 4 this gems cannot be inside assets group
gem 'jquery-ui-rails'
gem 'jquery-datatables-rails'
#gem 'bootstrap-sass' #, '~> 2.0.2'
gem 'bootstrap-sass' , '~> 2.3.2.0' #Latest version removes support for bootstrap-responsive since it was removed on bootstrap version 3

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn', :group => :production
gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
gem "rails-settings-cached"
gem 'ransack'
gem 'backbone-on-rails', '0.9.2.1' #Downgraded to this version because latest version of this gem remove several js methods and crashes the app
gem 'savon'
gem "zip"
gem "simple-navigation"
gem 'simple-navigation-bootstrap'
gem 'acts_as_list'
gem 'simple_form'
gem 'nokogiri'
gem "haml-rails"
gem 'will_paginate'
gem 'bootstrap-will_paginate'
gem 'carrierwave'
gem 'sidekiq' #, '~> 2.6.5'
gem 'best_in_place', :git => 'https://github.com/aaronchi/best_in_place.git'
gem 'sinatra', require: false
gem 'slim'
gem 'prawn'
gem 'redis-rails'
gem 'soundmanager-rails'
gem 'htmlentities'
gem 'redcarpet'


# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'

group :development, :production do
  gem 'hirb', :require => false
  gem 'factory_girl', :require => false
  gem 'faker', :require => false
end
# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
group :development do
  gem "thin" #, '~> 1.5.0'
  gem 'yard' #, '~> 0.8.3'
  gem 'capistrano'
  gem 'awesome_print'
  gem 'annotate'
end


group :development, :test do
  gem 'jasminerice'
  gem 'pry-rails'
  gem 'capybara'
  # gem "poltergeist"
  gem 'pdf-reader'
  gem "shoulda-matchers"
	gem "chromedriver-helper"
	gem 'database_cleaner'
	gem 'launchy'
	gem 'selenium-webdriver' #, '>=2.5.0'
	gem "simplecov", :require => false
  gem 'rspec-rails'
  gem 'factory_girl_rails'
end