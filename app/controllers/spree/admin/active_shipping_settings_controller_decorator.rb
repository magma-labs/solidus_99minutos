Spree::Admin::ActiveShippingSettingsController.class_eval do
  before_action :load_99minutes_preferences, only: :edit

  private

  def load_99minutes_preferences
    @ninety_nine_minutes_config = Spree::Solidus99minutos::Config
    @preferences_99Minutes = [:ninety_nine_minutes_api_key,
                              :ninety_nine_minutes_user_id,
                              :ninety_nine_minutes_route,
                              :ninety_nine_minutes_neighborhood,
                              :ninety_nine_minutes_postal_code,
                              :ninety_nine_minutes_locality,
                              :ninety_nine_minutes_sub_locality,
                              :ninety_nine_minutes_state,
                              :ninety_nine_minutes_country]
  end
end
