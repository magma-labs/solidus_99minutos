Spree::Shipment.class_eval do
  has_one :shipping_provider, dependent: :destroy, inverse_of: :shipment

  private

  def after_ship
    send_order_to_provider
    order.shipping.ship_shipment(self, suppress_mailer: suppress_mailer)
  end

  def send_order_to_provider
    shipping_method = shipping_methods.detect { |sp| sp.name.include?('99 Minutos') }

    return 'Not applicable' unless shipping_method

    ninety_nine_minutes_service = Spree::NinetyNineMinutesService.new(order, self)
    ninety_nine_minutes_service.push
  end
end