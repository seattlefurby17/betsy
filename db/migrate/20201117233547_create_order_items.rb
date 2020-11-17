class CreateOrderItems < ActiveRecord::Migration[6.0]
  def change
    create_table :order_items do |t|
      t.references :product, null: false
      t.references :order, null: false
      t.integer :quantity

      t.timestamps
    end
  end
end
