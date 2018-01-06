require 'net/http'
require 'net/https'

module ActiveShipping

  # 99minutos carrier implementation.
  #
  # 99minutos module by Jonathan Tapia (http://github.com/jtapia)
  class NinetyNineMinutes < Carrier
    self.retry_safe = true

    cattr_reader :name
    @@name = '99 Minutos'

    HOST = {
      test: 'deploy-dot-precise-line-76299minutos.appspot.com',
      live: 'precise-line-76299minutos.appspot.com'
    }

    ENDPOINT = '/2/delivery/shipping_rates'

    def requirements
      [:api_key, :user_id]
    end

    def find_rates(origin, destination, packages, options = {})
      packages = Array(packages)
      options = @options.merge(options)

      service_requests = packages.map do |package|
        service_request = ServiceRequest.new(origin, destination, package, options)

        service_request.parse(commit(service_request.url, service_request.params))
        service_request
      end

      combined_response = CombinedResponse.new(origin, destination, packages, service_requests)
      RateResponse.new(true, 'success', combined_response.params, combined_response.options)
    end

    private

    def commit(request_url, request_body)
      begin
        ssl_post(request_url, request_body, headers)
      rescue ActiveUtils::ResponseError, ActiveShipping::ResponseError => e
        data          = JSON.parse(e.response.body)
        error_message = data['error'] && data['error']['errorMessage'] ? data['error']['errorMessage'] : 'unknown'

        RateResponse.new(false, error_message, data)
      end
    end

    def headers
      { 'Content-type': 'application/json' }
    end

    class CombinedResponse
      def initialize(origin, destination, packages, requests)
        @requests    = requests
        @origin      = origin
        @destination = destination
        @packages    = packages
      end

      def options
        {
          rates:         rates,
          raw_responses: @requests.map(&:raw_response),
          request:       @requests.map(&:url)
        }
      end

      def params
        { responses: @requests.map(&:response) }
      end

      private

      def rate_options(rates)
        {
          service_name:       rates.first[:service_name],
          service_code:       rates.first[:service_code],
          total_price:        rates.first[:total_price],
          currency:           'MXN'
        }
      end

      def rates
        begin
          rates = @requests.map(&:rates).flatten

          rates.group_by { |rate| rate[:service_name] }.map do |service_name, service_rates|
            RateEstimate.new(@origin, @destination, NinetyNineMinutes.name, service_name, rate_options(service_rates))
          end.compact
        rescue NoMethodError
          nil
        end
      end
    end

    class ServiceRequest
      attr_reader :raw_response
      attr_reader :response
      attr_reader :rates

      def initialize(origin, destination, package, options)
        @origin      = Location.from(origin)
        @destination = Location.from(destination)
        @options     = options
        @package     = NinetyNineMinutesPackage.new(package)
        @rates       = []
        @test        = true #@options[:test]
      end

      def url
        host     = @test ? HOST[:test] : HOST[:live]
        endpoint = ENDPOINT

        URI::HTTPS.build(host: host, path: endpoint).to_s
      end

      def parse(data)
        @raw_response = data
        @response     = JSON.parse(data)

        raise ActiveShipping::ResponseError, 'No Shipping' if @response['status'] == "Error"

        @rates        = @response['rates'].map do |service|
                          {
                            service_name: service['title'],
                            service_code: service['type'],
                            total_price:  service['cost'].to_f,
                            currency:     'MXN'
                          }
                        end
      end

      def params
        {
          apiKey:      @options[:api_key],
          userId:      @options[:user_id],
          weight:      @package.weight,
          width:       @package.width,
          depth:       @package.depth,
          height:      @package.height,
          origin:      origin,
          destination: build_address(@destination)
        }.to_json
      end

      private

      ###
      # route:        Street line 1
      # neighborhood: Street line 2
      # postalCode:   Postal code
      # locality:     Municipality
      # sublocality:  City
      # state:        State
      # country:      Country
      ###
      def build_address(address)
        {
          route:        address.address1,
          neighborhood: address.address2,
          locality:     address.address3,
          postalCode:   address.postal_code,
          subLocality:  address.city,
          state:        address.city,
          country:      address.country.name
        }.
        # INFO: equivalent of .compact
        select { |_, value| !value.nil? }
      end

      def origin
        {
          route:        Spree::Solidus99minutos::Config[:ninety_nine_minutes_route],
          neighborhood: Spree::Solidus99minutos::Config[:ninety_nine_minutes_neighborhood],
          locality:     Spree::Solidus99minutos::Config[:ninety_nine_minutes_locality],
          postalCode:   Spree::Solidus99minutos::Config[:ninety_nine_minutes_postal_code],
          subLocality:  Spree::Solidus99minutos::Config[:ninety_nine_minutes_sub_locality],
          state:        Spree::Solidus99minutos::Config[:ninety_nine_minutes_state],
          country:      Spree::Solidus99minutos::Config[:ninety_nine_minutes_country]
        }.
        # INFO: equivalent of .compact
        select { |_, value| !value.nil? }
      end
    end

    class NinetyNineMinutesRateEstimate < RateEstimate
      def initialize(origin, destination, carrier, service_name, options = {})
        super
      end
    end

    class NinetyNineMinutesPackage
      def initialize(package)
        @package = package
      end

      def weight
        @package.grams.to_i
      end

      def length
        mm(:length).to_i
      end

      def depth
        mm(:depth).to_i
      end

      def height
        mm(:height).to_i
      end

      def width
        mm(:width).to_i
      end

      def mm(measurement)
        @package.cm(measurement) * 10
      end

      def currency
        @package.currency || 'MXN'
      end
    end
  end
end