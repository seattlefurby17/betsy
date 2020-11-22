class Order < ApplicationRecord
  has_many :order_items
  has_many :products, through: :order_items

  validates_associated :order_items # one way street, infinite loop otherwise
  validates :name, format: { :with => /\A[a-zA-Z]+\z/, :message => "Only letters allowed" } 
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i } 
  # validates :address
  validates :card_number, numericality: { only_integer: true, :message => "Invalid card number" }
  validates :expiration_month, presence: true, numericality: { only_integer: true}
  validate  :expiration_year_cannot_be_in_the_past 
  validates :security_code, numericality: { only_integer: true}
  validates :zip_code,  numericality: { only_integer: true}

  def expiration_year_cannot_be_in_the_past
    if !expiration_year.blank? && expiration_year < Time.now.year
      errors.add(:expiration_year, "can't be in the past")
    end
  end

end
