module Spree
  module Calculator::Shipping
    module NinetyNineMinutes
      class ExpressBicycle < Spree::Calculator::Shipping::NinetyNineMinutes::Base
        def self.description
          Spree.t('ninety_nine_minutes.express.bicycle')
        end

        def self.service_code
          'expressBicycle'
        end
      end
    end
  end
end