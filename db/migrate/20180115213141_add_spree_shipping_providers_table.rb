class AddSpreeShippingProvidersTable < ActiveRecord::Migration[4.2]
  def change
    create_table :spree_shipping_providers do |t|
      t.string  :name
      t.string  :state
      t.string  :reference
      t.integer :shipment_id

      t.timestamp
    end
  end
end
