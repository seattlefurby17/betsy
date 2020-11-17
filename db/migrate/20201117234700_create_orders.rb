class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.references :order_item, null: false
      t.string :status

      t.timestamps
    end
  end
end
