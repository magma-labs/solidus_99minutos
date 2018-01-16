module Spree
  module Calculator::Shipping
    module NinetyNineMinutes
      class SameDayMini < Spree::Calculator::Shipping::NinetyNineMinutes::Base
        def self.description
          Spree.t('ninety_nine_minutes.same_day.mini')
        end

        def self.service_code
          'sameDayMini'
        end
      end
    end
  end
end