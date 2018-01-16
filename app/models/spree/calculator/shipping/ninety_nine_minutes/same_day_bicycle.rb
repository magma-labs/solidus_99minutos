module Spree
  module Calculator::Shipping
    module NinetyNineMinutes
      class SameDayBicycle < Spree::Calculator::Shipping::NinetyNineMinutes::Base
        def self.description
          Spree.t('ninety_nine_minutes.same_day.bicycle')
        end

        def self.service_code
          'sameDayBycicle'
        end
      end
    end
  end
end