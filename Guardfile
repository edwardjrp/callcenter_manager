# A sample Guardfile
# More info at https://github.com/guard/guard#readme
notification :growl

guard 'livereload' do
  watch(%r{app/views/.+\.(erb|haml|slim)})
  watch(%r{app/helpers/.+\.rb})
  watch(%r{public/.+\.(css|js|html)})
  watch(%r{config/locales/.+\.yml})
  # Rails Assets Pipeline
  watch(%r{(app|vendor)/assets/\w+/(.+\.(css|js|html)).*})  { |m| "/assets/#{m[2]}" }
end


guard 'rspec', :version => 2, :cli => "--drb --format documentation",:all_after_pass => false, :run_all => { :cli => "--format progress" }do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^app/controllers/admin/(.+)_(controller)\.rb$})  { |m| "spec/requests/admin/#{m[1]}" }
  watch(%r{^app/views/admin/(.+)/.*\.(erb|haml)$})          { |m| "spec/requests/admin/#{m[1]}" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| "spec/requests/#{m[1]}" }
  watch(%r{^app/views/layout/(.+)/.*\.(erb|haml)$})          {"spec/requests" }
  watch(%r{^app/views/(.+)/.*\.(erb|haml)$})          { |m| "spec/requests/#{m[1]}" }
  watch(%r{^spec/support/factories/(.+)\.rb$})                  { "spec/models" }
  watch(%r{^spec/(application|layouts)/(.+)\.rb$})                  { "spec/request" }
  watch(%r{^app/models/(.+)\.rb$})                  { |m| "spec/models/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')                        { ["spec/requests","spec/models"] }
  watch('app/controllers/application_controller.rb')  { ["spec/requests","spec/models"] }
end

guard 'spork', :cucumber => false, :test_unit => false, :rspec_env => { 'RAILS_ENV' => 'test' } do
  watch('config/application.rb')
  watch('config/environment.rb')
  watch(%r{^config/environments/.+\.rb$})
  watch(%r{^config/initializers/.+\.rb$})
  watch('Gemfile')
  watch('Gemfile.lock')
  watch('spec/spec_helper.rb') { :rspec }
end

guard 'jasmine' do
  watch(%r{spec/javascripts/spec\.(js\.coffee|js|coffee)$})         { "spec/javascripts" }
  watch(%r{spec/javascripts/.+_spec\.(js\.coffee|js|coffee)$})
  watch(%r{app/assets/javascripts/(.+?)\.(js\.coffee|js|coffee)$})  { |m| "spec/javascripts/#{m[1]}_spec.#{m[2]}" }
end
