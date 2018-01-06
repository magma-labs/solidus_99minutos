module Spree
  module Calculator::Shipping
    module NinetyNineMinutes
      class Express < Spree::Calculator::Shipping::NinetyNineMinutes::Base
        def self.description
          Spree.t('ninety_nine_minutes.express')
        end

        def self.service_code
          '99'
        end
      end
    end
  end
end