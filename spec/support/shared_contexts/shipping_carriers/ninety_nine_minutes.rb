shared_context '99 Minutes setup' do
  before do
    module Spree::ActiveShipping
    end

    WebMock.allow_net_connect!
    Spree::Solidus99minutos::Config[:ninety_nine_minutes_api_key] = 'rkc5hn4WLC'
    Spree::Solidus99minutos::Config[:ninety_nine_minutes_user_id] = '5083903941410816'
    Spree::Solidus99minutos::Config[:ninety_nine_minutes_route] = 'Av. Tejocotes s/n'
    Spree::Solidus99minutos::Config[:ninety_nine_minutes_neighborhood] = 'San Martín Obispo'
    Spree::Solidus99minutos::Config[:ninety_nine_minutes_postal_code] = '54769'
    Spree::Solidus99minutos::Config[:ninety_nine_minutes_locality] = 'Cuatitlán Izcalli'
    Spree::Solidus99minutos::Config[:ninety_nine_minutes_sub_locality] = 'Ciudad de Mexico'
    Spree::Solidus99minutos::Config[:ninety_nine_minutes_state] = 'Ciudad de Mexico'
    Spree::Solidus99minutos::Config[:ninety_nine_minutes_country] = 'Mexico'
    Spree::ActiveShipping::Config[:test_mode] = true
  end

  after do
    WebMock.disable_net_connect!
  end
end
