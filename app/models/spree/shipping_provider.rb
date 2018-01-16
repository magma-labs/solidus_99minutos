module Spree
  class ShippingProvider < Spree::Base
    belongs_to :shipment, class_name: 'Spree::Shipment', touch: true

    validates :shipment, presence: true

    state_machine initial: :ready, use_transactions: false do
      event :ship do
        transition from: [:ready, :error], to: :shipped, if: :has_shipment?
      end

      event :error do
        transition to: :error, from: [:ready]
      end

      event :ready do
        transition to: :ready, from: [:error]
      end
    end

    private

    def has_shipment?
      shipment
    end
  end
end