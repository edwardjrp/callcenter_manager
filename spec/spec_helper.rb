require 'rubygems'
  
  
ENV["RAILS_ENV"] ||= 'test'
require 'simplecov'
SimpleCov.start 'rails'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'shoulda/matchers/integrations/rspec'
require 'faker'
require 'capybara/rspec'
require 'factory_girl_rails'
  
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  
  
  
  
  Capybara.javascript_driver = :selenium
  Capybara.default_wait_time = 5
  
  config.use_transactional_fixtures = false
  # config.use_transactional_fixtures = true
  config.include(FactoryGirl::Syntax::Methods)
  config.include(AuthenticationMacros)
  config.include(MassAssignmentMacros)
  # config.fail_fast = true
  config.order = 'random'
  config.before(:all) do
    DeferredGarbageCollection.start
  end

  config.after(:all) do
    DeferredGarbageCollection.reconsider
  end

  config.before(:suite) do 
    DatabaseCleaner.strategy = :transaction 
    DatabaseCleaner.clean_with(:truncation) 
  end
  
  config.before(:each) do 
    if example.metadata[:js] 
      DatabaseCleaner.strategy = :truncation 
    else 
      DatabaseCleaner.start 
    end 
  end
  
  config.after(:each) do 
    DatabaseCleaner.clean 
    if example.metadata[:js] 
      DatabaseCleaner.strategy = :transaction 
    end 
  end

  config.infer_base_class_for_anonymous_controllers = false
end