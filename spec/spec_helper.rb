# Configure Rails Environment
ENV["RAILS_ENV"] = "test"
require 'simplecov' if ENV['COVERAGE']
require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require 'solidus_frontend'
require 'rspec/rails'
require 'factory_bot'
require 'webmock/rspec'
require 'ffaker'
require 'database_cleaner'
require 'rails-controller-testing'

# Run any available migration
ActiveRecord::Migrator.migrate File.expand_path("../dummy/db/migrate/", __FILE__)

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |file| require file }

require 'spree/testing_support/url_helpers'
require 'spree/testing_support/controller_requests'
require 'spree/testing_support/authorization_helpers'
require 'spree/testing_support/factories/zone_factory'
require 'spree/testing_support/preferences'
require 'spree/testing_support/factories'
require 'spree/api/testing_support/helpers'
require 'spree/api/testing_support/setup'
# require 'solidus_active_shipping/factories'

Dir[File.join(File.dirname(__FILE__), "factories/*.rb")].each {|f| require f }

require 'rspec/active_model/mocks'

VCR.configure do |config|
  config.ignore_localhost = true
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
end

RSpec.configure do |config|
  config.infer_base_class_for_anonymous_controllers = false
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!

  config.include FactoryBot::Syntax::Methods
  config.include Spree::Api::TestingSupport::Helpers, type: :controller
  config.extend  Spree::Api::TestingSupport::Setup, type: :controller
  config.include Spree::TestingSupport::ControllerRequests, type: :controller
  config.include Spree::TestingSupport::UrlHelpers
  config.include Spree::TestingSupport::Preferences, type: :controller
  config.include Spree::TestingSupport::Preferences, type: :model
  # config.include WebFixtures

  config.before :suite do
    DatabaseCleaner.clean_with :truncation
  end

  config.before do
    DatabaseCleaner.strategy = RSpec.current_example.metadata[:js] ? :truncation : :transaction
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end
end
