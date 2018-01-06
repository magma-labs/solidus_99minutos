module Spree
  module Calculator::Shipping
    module NinetyNineMinutes
      class SameDay < Spree::Calculator::Shipping::NinetyNineMinutes::Base
        def self.description
          Spree.t('ninety_nine_minutes.same_day')
        end

        def self.service_code
          'sameDay'
        end
      end
    end
  end
end