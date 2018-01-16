require 'net/http'
require 'net/https'
require 'active_utils/connection'
require 'active_utils/country'

module Spree
  class NinetyNineMinutesService
    include ActiveUtils::PostsData

    cattr_reader :name
    @@name = '99 Minutos'

    SERVICE_TYPES = {
      expressBicycle: {
        service: '99',
        vehicle: 'bicycle'},
      expressBike: {
        service: '99',
        vehicle: 'bike'},
      sameDayBycicle: {
        service: 'sameDay',
        vehicle: 'bicycle'},
      sameDayBike: {
        service: 'sameDay',
        vehicle: 'bike'},
      sameDayMini: {
        service: 'sameDay',
        vehicle: 'mini'} }

    HOST = {
      test: 'deploy-dot-precise-line-76299minutos.appspot.com',
      live: 'precise-line-76299minutos.appspot.com'
    }

    ENDPOINT = '/2/delivery/request'

    attr_accessor :order, :shipment, :shipping_method, :shipping_provider, :test

    def initialize(order, shipment, options={})
      @order = order
      @shipment = shipment
      @shipping_method = shipment.shipping_method
      @shipping_provider = shipment.shipping_provider
      @test = Spree::ActiveShipping::Config[:test_mode]
    end

    def push
      begin
        response = ssl_post(request_url, request_params, headers)
        update_shipment(response)
      rescue ::ActiveUtils::ResponseError, ::ActiveShipping::ResponseError => e
        data = JSON.parse(e.response.body.downcase)
        error_message = data['error'] && data['error']['message'] ? data['error']['message'] : 'unknown'
      end
    end

    private

    def deliver_type(code)
      SERVICE_TYPES[code.to_sym][:service]
    end

    def vehicule_type(code)
      SERVICE_TYPES[code.to_sym][:vehicle]
    end

    def request_url
      host = test ? HOST[:test] : HOST[:live]
      endpoint = ENDPOINT

      URI::HTTPS.build(host: host, path: endpoint).to_s
    end

    def headers
      { 'Content-type': 'application/json' }
    end

    def request_params
      {
        apiKey:           Spree::Solidus99minutos::Config[:ninety_nine_minutes_api_key],
        userId:           Spree::Solidus99minutos::Config[:ninety_nine_minutes_user_id],
        deliveryType:     deliver_type(shipping_method.carrier),
        vehicleType:      vehicule_type(shipping_method.carrier),
        notes:            order.special_instructions.to_s,
        cashOnDelivery:   false,
        amount:           order.total.to_i,
        receivedOrderId:  order.number,
        origin:           origin,
        destination:      build_address(order.ship_address)
      }.to_json
    end

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
        receiver:       address.full_name,
        email:          order.email,
        phoneNumber:    address.phone,
        route:          address.address1,
        street_number:  address.address1.scan(/\d+/).first,
        internalNumber: address.address2.scan(/\d+/).first,
        neighborhood:   address.address2,
        locality:       address.address3,
        postal_code:    address.zipcode,
        subLocality:    address.city,
        state:          address.state.name,
        country:        address.country.name,
      }
    end

    def origin
      {
        sender:         Spree::Solidus99minutos::Config[:ninety_nine_minutes_sender],
        route:          Spree::Solidus99minutos::Config[:ninety_nine_minutes_route],
        street_number:  Spree::Solidus99minutos::Config[:ninety_nine_minutes_street_number],
        internalNumber: Spree::Solidus99minutos::Config[:ninety_nine_minutes_internal_number],
        neighborhood:   Spree::Solidus99minutos::Config[:ninety_nine_minutes_neighborhood],
        locality:       Spree::Solidus99minutos::Config[:ninety_nine_minutes_locality],
        postal_code:    Spree::Solidus99minutos::Config[:ninety_nine_minutes_postal_code],
        subLocality:    Spree::Solidus99minutos::Config[:ninety_nine_minutes_sub_locality],
        state:          Spree::Solidus99minutos::Config[:ninety_nine_minutes_state],
        country:        Spree::Solidus99minutos::Config[:ninety_nine_minutes_country]
      }
    end

    def update_shipment(response)
      data = JSON.parse(response)

      if data['status'] == 'OK'
        shipment.update_attributes(tracking: data['trackingId'])
        shipment.shipping_provider.update_attributes(reference: data['order'])
        shipping_provider.ship!
      else
        shipment.errors.add(:base, Spree.t('ninety_nine_minutes.cant_ship'))
        shipping_provider.error!
      end
    end
  end
end
