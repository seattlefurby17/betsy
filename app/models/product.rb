class Product < ApplicationRecord
  belongs_to :merchant
  has_many :order_items
  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than: 0 }

end
