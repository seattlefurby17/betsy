class Order < ApplicationRecord
  has_many :order_items
  has_many :products, through: :order_items

  validates_associated :order_items # one way street, infinite loop otherwise
  validates :name, format: { :with => /\A[a-zA-Z]+\z/, :message => "Only letters allowed" } # do we want to be this strict?
  validates :email, uniqueness: { case_sensitive: false }, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  validates :address, presence: true
  validates :card_number, presence: true, numericality: { only_integer: true}
  validates :expiration_month, presence: true, numericality: { only_integer: true}
  validate  :expiration_year, :if => :expiration_year_cannot_be_in_the_past 
  validates :security_code, presence: true, numericality: { only_integer: true}
  validates :zip_code, presence: true, numericality: { only_integer: true}

  def expiration_year_cannot_be_in_the_past
    if !expiration_year.blank? and expiration_year < Date.new.year
      errors.add(:expiration_year, "can't be in the past")
    end
  end

end
