class AddAddress3ToSpreeAddress < ActiveRecord::Migration[4.2]
  def change
    if table_exists?('spree_addresses')
      add_column :spree_addresses, :address3, :string
    end
  end
end
