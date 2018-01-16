Spree::Order.class_eval do
  has_many :shipping_providers, through: :shipments

  state_machine.after_transition to: :complete, do: :create_shipping_provider

  private

  def create_shipping_provider
    provider_shipments = shipments.select { |shipment| shipment.shipping_method.name.include?(Spree::NinetyNineMinutesService.name) }

    provider_shipments.each do |shipment|
      shipping_provider = Spree::ShippingProvider.new
      shipping_provider.shipment = shipment
      shipping_provider.name = Spree::NinetyNineMinutesService.name
      shipping_provider.save
    end
  end
end