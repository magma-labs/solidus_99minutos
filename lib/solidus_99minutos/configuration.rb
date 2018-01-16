module Solidus99minutos
  class Configuration < Spree::Preferences::Configuration
    # 99 Minutos
    preference :ninety_nine_minutes_api_key, :string, default: '23894thfpoiq10fapo93fmapo'
    preference :ninety_nine_minutes_user_id, :string, default: '5083903941410816'
    preference :ninety_nine_minutes_sender, :string, default: 'Tamex'
    preference :ninety_nine_minutes_route, :string, default: 'Av. Tejocotes s/n'
    preference :ninety_nine_minutes_street_number, :string, default: ''
    preference :ninety_nine_minutes_internal_number, :string, default: ''
    preference :ninety_nine_minutes_neighborhood, :string, default: 'San Martín Obispo'
    preference :ninety_nine_minutes_postal_code, :string, default: '54769'
    preference :ninety_nine_minutes_locality, :string, default: 'Cuatitlán Izcalli'
    preference :ninety_nine_minutes_sub_locality, :string, default: 'Distrito Federal'
    preference :ninety_nine_minutes_state, :string, default: 'Mexico'
    preference :ninety_nine_minutes_country, :string, default: 'Mexico'
  end
end
