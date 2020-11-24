class Product < ApplicationRecord
  belongs_to :merchant
  # belongs_to :category
  has_many :order_items
  has_many :orders, through: :order_items

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than: 0 }

  def self.spotlight
    spotlight_for_all_products = Product.all.sample
    return spotlight_for_all_products
  end
end