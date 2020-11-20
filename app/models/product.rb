class Product < ApplicationRecord
  belongs_to :merchant
  belongs_to :category
  has_many :order_items



end
