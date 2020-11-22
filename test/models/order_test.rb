require "test_helper"

describe Order do

  describe 'validations' do
    it 'should be a valid order' do
      @order = Order.create!(name: 'ada', email: 'banana@123.com', 
        address: 'test address', card_number: 123456789123456789, expiration_month: 01,
        expiration_year: 2022, security_code: 123, zip_code: 11221)
      expect(@order.valid?).must_equal true
    end

    it "fails validations when address is not present" do
      missing_address = Order.create!(name: 'ada', email: 'banana@123.com', 
        address: '', card_number: 123456789123456789, expiration_month: 01,
        expiration_year: 2022, security_code: 123, zip_code: 11221)
      expect(missing_address.valid?).must_equal false
    end

    it "fails validations when email is not propertly formatted" do
      invalid_email = Order.create!(name: 'ada', email: 'banana!@123.com', 
        address: 'test address', card_number: 123456789123456789, expiration_month: 01,
        expiration_year: 2022, security_code: 123, zip_code: 11221)
      expect(invalid_email.valid?).must_equal false
    end

    it "fails validations when credit card number is not present" do
      invalid_card_number = Order.create!(name: 'ada', email: 'banana@123.com', 
        address: 'test address', card_number:'', expiration_month: 01,
        expiration_year: 2022, security_code: 123, zip_code: 11221)
      expect(invalid_card_number.valid?).must_equal false
      expect(invalid_card_number.errors.messages).must_include :card_number
      expect(invalid_card_number.errors.messages[:card_num]).must_equal ["can't be blank"]
    end

    it "fails validations when expiration year is less than current year" do
      year_in_the_past = Order.create!(name: 'testuser', email: 'banana@123.com', 
        address: 'test address', card_number: 123456789123456789, expiration_month: 01,
        expiration_year: 2019, security_code: 123, zip_code: 11221)
      expect(year_in_the_past.valid?).must_equal false
    end

    it "fails validations when zip code is not integer" do
      wrong_zip_code = Order.create!(name: 'ada', email: 'banana@123.com', 
        address: 'test address', card_number: 123456789123456789, expiration_month: 01,
        expiration_year: 2019, security_code: 123, zip_code: '112216')
      expect(wrong_zip_code.valid?).must_equal false
    end

  end

  describe "relationships" do
    it 'belongs to a merchant' do # who has order?
      skip
    end
  end
  
end
