class Merchant < ApplicationRecord
  has_many :products
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  def self.build_from_github(auth_hash)
    merchant = Merchant.new
    merchant.uid = auth_hash[:uid]
    merchant.provider = "github"
    merchant.username = auth_hash["info"]["nickname"]
    merchant.email = auth_hash["info"]["email"]

    # Note that the merchant has not been saved.
    # We'll choose to do the saving outside of this method
    return merchant
  end

  def total_revenue(status = nil)
    #    total = 0
    order_items = products.map { |product| product.order_items }.flatten
    order_items.each do |item|
      next if status && item.order.status != status

      total += item.product.price * item.quantity
    end
    total
  end

  def total_num(status = nil)
    #collecting the order items of each product and using flatten to modify into a one dimensional array instead of 2 dimensional
    order_items = products.map { |product| product.order_items }.flatten
    #collecting the orders, returning the order if the status of the order is equal to the status passed in
    orders = order_items.map do |item|
      item.order if !status || item.order.status == status
    end
    #uniq will get rid of any duplicate orders, compact will remove any items that are nil (depends on the status)
    orders.uniq.compact.count
  end

  def total_orders
    order_items = products.map { |product| product.order_items }.flatten
    #collecting the orders, returning the order if the status of the order is equal to the status passed in
    orders = order_items.map do |item|
      item.order
    end
    return orders
  end

  def order_belongs_to_merchant?(order)
    return false if order.nil?

    order.products.each do |product|
      return true if self.products.include?(product)
    end

    return false
  end

end
