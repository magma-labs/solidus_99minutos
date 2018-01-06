require_dependency 'spree/calculator'

module Spree
  module Calculator::Shipping
    module NinetyNineMinutes
      class Base < Spree::Calculator::Shipping::ActiveShipping::Base
        def compute_package(package)
          order = package.order
          stock_location = package.stock_location
          max_weight = get_max_weight(package)

          origin = build_location(stock_location)
          destination = build_location(order.ship_address)

          rates_result = retrieve_rates_from_cache(package, origin, destination, max_weight)

          return nil if rates_result.kind_of?(Spree::ShippingError)
          return nil if rates_result.empty?
          rate = rates_result[self.class.service_code]

          return nil unless rate
          rate = rate.to_f + (Spree::ActiveShipping::Config[:handling_fee].to_f || 0.0)

          # divide by 100 since active_shipping rates are expressed as cents
          return rate/100.0
        end

        def carrier
          carrier_details = {
            api_key:  Spree::Solidus99minutos::Config[:ninety_nine_minutes_api_key],
            user_id:  Spree::Solidus99minutos::Config[:ninety_nine_minutes_user_id],
            test:     Spree::ActiveShipping::Config[:test_mode]
          }

          ::ActiveShipping::NinetyNineMinutes.new(carrier_details)
        end

        private

        def retrieve_rates(origin, destination, shipment_packages)
          begin
            response = carrier.find_rates(origin, destination, shipment_packages)

            rates = response.rates.collect do |rate|
              service_name = rate.service_code.encode('UTF-8')
              [CGI.unescapeHTML(service_name), rate.price]
            end
            rate_hash = Hash[*rates.flatten]
            return rate_hash
          rescue ::ActiveShipping::Error => e
            if [::ActiveShipping::ResponseError].include?(e.class) && e.response.is_a?(::ActiveShipping::Response)
              params = e.response.params
              if params.has_key?("Response") && params["Response"].has_key?("Error") && params["Response"]["Error"].has_key?("ErrorDescription")
                message = params["Response"]["Error"]["ErrorDescription"]
              # Canada Post specific error message
              elsif params.has_key?("eparcel") && params["eparcel"].has_key?("error") && params["eparcel"]["error"].has_key?("statusMessage")
                message = e.response.params["eparcel"]["error"]["statusMessage"]
              else
                message = e.message
              end
            else
              message = e.message
            end

            error = Spree::ShippingError.new("#{I18n.t(:shipping_error)}: #{message}")
            Rails.cache.write @cache_key, error #write error to cache to prevent constant re-lookups
            raise error
          end
        end
      end
    end
  end
end
