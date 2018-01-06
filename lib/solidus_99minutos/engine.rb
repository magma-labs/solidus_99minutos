module Spree::Solidus99minutos
end

module Solidus99minutos
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'solidus_99minutos'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    config.autoload_paths += %W(#{config.root}/lib)

    initializer 'solidus_99minutos.environment', before: 'spree.environment' do
      Spree::Solidus99minutos::Config = Solidus99minutos::Configuration.new
      ActiveShipping::Carriers.register :NinetyNineMinutes,'active_shipping/carriers/ninety_nine_minutes'
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../../app/**/*_decorator*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

      Dir[File.join(File.dirname(__FILE__), "../../app/models/spree/calculator/**/base.rb")].sort.each do |c|
        Rails.env.production? ? require(c) : load(c)
      end

      Dir.glob(File.join(File.dirname(__FILE__), "../app/overrides/*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    initializer 'solidus_99minutos.register.calculators', after: 'spree.register.calculators' do |app|
      if app.config.spree.calculators.shipping_methods
        classes = Dir.chdir File.join(File.dirname(__FILE__), "../../app/models") do
          Dir["spree/calculator/**/*.rb"].reject {|path| path =~ /base.rb$/ }.map do |path|
            path.gsub('.rb', '').camelize.constantize
          end
        end

        app.config.spree.calculators.shipping_methods.concat classes
      end
    end

    config.to_prepare &method(:activate).to_proc
  end
end
