class Product < ApplicationRecord
  belongs_to :merchant
  has_many :order_items
end
