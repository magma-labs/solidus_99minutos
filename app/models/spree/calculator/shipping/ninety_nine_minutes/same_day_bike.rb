module Spree
  module Calculator::Shipping
    module NinetyNineMinutes
      class SameDayBike < Spree::Calculator::Shipping::NinetyNineMinutes::Base
        def self.description
          Spree.t('ninety_nine_minutes.same_day.bike')
        end

        def self.service_code
          'sameDayBike'
        end
      end
    end
  end
end