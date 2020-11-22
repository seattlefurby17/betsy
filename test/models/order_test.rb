require "test_helper"

describe Order do

  describe 'validations' do
    before do # a test case that will pass all validations
      @order = Order.create!(name: 'ada', email: 'banana@123.com', 
        address: 'test address', card_number: 123456789123456789, expiration_month: 01,
        expiration_year: 2022, security_code: 123, zip_code: 11221)
    end

    it 'should be a valid order when all fields are filled' do
      expect(@order.valid?).must_equal true
    end

    # it "fails validations when address is not present" do
    #   @order.address = nil
    #   expect(@order.valid?).must_equal false
    # end

    it "fails validations when email is not propertly formatted" do
      @order.email = 12121212
      expect(@order.valid?).must_equal false
    end

    it "fails validations when credit card number is not integer" do
      @order.card_number = 1.2
      expect(@order.valid?).must_equal false
      expect(@order.errors.messages.include?(:card_number)).must_equal true
      expect(@order.errors.messages[:card_number].include?("Invalid card number")).must_equal true
    end
 
    it "fails validations when expiration month is not integer" do
      @order.expiration_month = 1.2
      expect(@order.valid?).must_equal false
    end

    it "fails validations when expiration year is less than current year" do
      @order.expiration_year = 2000
      expect(@order.valid?).must_equal false
    end

    it "fails validations when zip code is not integer" do
      @order.zip_code = ""
      expect(@order.valid?).must_equal false
    end

  end

  describe "relationships" do
    it 'belongs to a merchant' do # who has order?
      skip
    end
  end
  
end
