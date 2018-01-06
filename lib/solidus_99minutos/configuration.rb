module Solidus99minutos
  class Configuration < Spree::Preferences::Configuration
    # 99 Minutos
    preference :ninety_nine_minutes_api_key, :string, default: 'rkc5hn4WLC'
    preference :ninety_nine_minutes_user_id, :string, default: '5083903941410816'
    preference :ninety_nine_minutes_route, :string, default: 'Av. Tejocotes s/n'
    preference :ninety_nine_minutes_neighborhood, :string, default: 'San Martín Obispo'
    preference :ninety_nine_minutes_postal_code, :string, default: '54769'
    preference :ninety_nine_minutes_locality, :string, default: 'Cuatitlán Izcalli'
    preference :ninety_nine_minutes_sub_locality, :string, default: 'Ciudad de Mexico'
    preference :ninety_nine_minutes_state, :string, default: 'Ciudad de Mexico'
    preference :ninety_nine_minutes_country, :string, default: 'Mexico'
  end
end
