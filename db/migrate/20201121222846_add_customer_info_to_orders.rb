class AddCustomerInfoToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :name, :string
    add_column :orders, :email, :string
    add_column :orders, :address, :string
    add_column :orders, :card_number, :bigint
    add_column :orders, :expiration_month, :integer
    add_column :orders, :expiration_year, :integer
    add_column :orders, :security_code, :integer
    add_column :orders, :zip_code, :integer
  end
end
