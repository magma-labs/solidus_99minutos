shared_context '99 Minutes setup' do
  before do
    module Spree::ActiveShipping
    end

    WebMock.allow_net_connect!
    Spree::Solidus99minutos::Config[:ninety_nine_minutes_api_key] = '23894thfpoiq10fapo93fmapo'
    Spree::Solidus99minutos::Config[:ninety_nine_minutes_user_id] = '5083903941410816'
    Spree::Solidus99minutos::Config[:ninety_nine_minutes_sender] = 'Tamex'
    Spree::Solidus99minutos::Config[:ninety_nine_minutes_route] = 'Av. Tejocotes s/n'
    Spree::Solidus99minutos::Config[:ninety_nine_minutes_street_number] = ''
    Spree::Solidus99minutos::Config[:ninety_nine_minutes_internal_number] = ''
    Spree::Solidus99minutos::Config[:ninety_nine_minutes_neighborhood] = 'San Martín Obispo'
    Spree::Solidus99minutos::Config[:ninety_nine_minutes_postal_code] = '54769'
    Spree::Solidus99minutos::Config[:ninety_nine_minutes_locality] = 'Cuatitlán Izcalli'
    Spree::Solidus99minutos::Config[:ninety_nine_minutes_sub_locality] = 'Distrito Federal'
    Spree::Solidus99minutos::Config[:ninety_nine_minutes_state] = 'Mexico'
    Spree::Solidus99minutos::Config[:ninety_nine_minutes_country] = 'Mexico'
    Spree::ActiveShipping::Config[:test_mode] = true
  end

  after do
    WebMock.disable_net_connect!
  end
end
