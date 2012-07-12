source 'https://rubygems.org'

gem 'rails', '3.2.5'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'bootstrap-sass', '~> 2.0.2'
  gem 'jquery-ui-rails'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
gem 'jbuilder'

# Use unicorn as the app server
gem 'unicorn', :group=> :production

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
gem 'backbone-on-rails'
gem 'savon'
gem "cancan"
gem "simple-navigation"
gem 'simple-navigation-bootstrap'
gem "transitions", :require => ["transitions", "active_record/transitions"]
gem 'exception_notification'
gem 'settler'
gem 'delayed_job_active_record'
gem 'acts_as_list'
gem 'simple_form'
gem "formtastic"
gem 'nokogiri'
gem 'yard' 
gem "haml-rails"
gem 'will_paginate'
gem 'bootstrap-will_paginate'
gem 'carrierwave'
# gem 'best_in_place'

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
group :development do
  gem "thin"
  gem 'capistrano'
  gem 'letter_opener'
  gem 'hirb'
  gem 'awesome_print'
  gem 'annotate', :git => 'git://github.com/ctran/annotate_models.git',:group => :development
end


group :development, :test do
  # gem 'ruby-debug19', :require => 'ruby-debug'
  gem 'jasminerice'
  gem 'guard-jasmine'
  gem 'growl'
  gem 'vcr', '~> 2.0.0'
	gem 'webmock', '~> 1.8.3'
  gem 'guard-rspec'
  gem 'faker'
  gem 'capybara'
  gem "poltergeist"
  gem "shoulda-matchers"
  gem 'guard-livereload'
  gem "guard-spork"
	gem "chromedriver-helper"
	gem 'database_cleaner'
	gem 'launchy'
	gem 'selenium-webdriver', '>=2.5.0'
	gem "simplecov", :require => false
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'spork'
end