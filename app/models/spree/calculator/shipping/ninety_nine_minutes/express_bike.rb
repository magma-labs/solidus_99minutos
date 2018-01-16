module Spree
  module Calculator::Shipping
    module NinetyNineMinutes
      class ExpressBike < Spree::Calculator::Shipping::NinetyNineMinutes::Base
        def self.description
          Spree.t('ninety_nine_minutes.express.bike')
        end

        def self.service_code
          'expressBike'
        end
      end
    end
  end
end