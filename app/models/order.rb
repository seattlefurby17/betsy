class Order < ApplicationRecord
  has_many :order_items
  has_many :products

  # validates_associated :order_items # one way street, infinite loop otherwise
  validates :name, format: { :with => /\A[a-zA-Z]+\z/, :message => "Only letters allowed" }, :allow_nil => true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }, :allow_nil => true
  validates :card_number, numericality: { only_integer: true, :message => "Invalid card number" }, :allow_nil => true
  validates :expiration_month, numericality: { only_integer: true, greater_than: 0, less_than: 13 }, :allow_nil => true
  validate  :expiration_year_cannot_be_in_the_past
  validates :security_code, numericality: { only_integer: true}, :allow_nil => true
  validates :zip_code,  numericality: { only_integer: true}, :allow_nil => true

  def expiration_year_cannot_be_in_the_past
    if !expiration_year.blank? && expiration_year < Time.now.year
      errors.add(:expiration_year, "can't be in the past")
    elsif !expiration_year.blank? && expiration_year == Time.now.year && expiration_month < Time.now.month
      errors.add(:expiration_month, "can't be in the past")
    end
  end

  # def total
  #   sum = 0
  #   order_items.each do |order_item|
  #     sum += (order_item.product.price * order_item.quantity)
  #   end
  #   return sum
  # end


end
