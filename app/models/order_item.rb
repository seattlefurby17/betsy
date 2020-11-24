class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order
  
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :product_id, presence: true
  validates :order_id, presence: true

  def change_quantity(quantity)
    self.quantity = quantity
    return self
  end

  def add_quantity(quantity)
    self.quantity += quantity
    return self
  end

end
