require "test_helper"

describe Order do
  before do # a test case that will pass all validations
    @order = Order.create!(name: 'ada', email: 'banana@123.com', 
      address: 'test address', card_number: 123456789123456789, expiration_month: 01,
      expiration_year: 2022, security_code: 123, zip_code: 11221)
    @merchant = merchants(:grace)
    @product = Product.create!(name: 'test toy', price: 222, merchant_id: @merchant.id)
    @product1 =Product.create!(name: 'test toy1', price: 111, merchant_id: @merchant.id)
  end
  describe 'validations' do

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
 
    it "fails validations when expiration month is greater than 12" do
      @order.expiration_month = 13
      expect(@order.valid?).must_equal false
    end

    it "fails validations when expiration year is less than current year" do
      @order.expiration_year = Time.now.year
      @order.expiration_month = Time.now.month - 1
      puts @order.expiration_year
      expect(@order.valid?).must_equal false
    end

    it "fails validations when zip code is not integer" do
      @order.zip_code = ""
      expect(@order.valid?).must_equal false
    end

  end

  describe "relationships" do
    before do 
      @order_item = OrderItem.create!(product_id: @product.id, order_id: @order.id, quantity: 2)
      @order_item1 = OrderItem.create!(product_id: @product1.id, order_id: @order.id, quantity: 2)
    end

    it 'an order can have many products through order_items' do 
      expect(@order.products.count).must_equal 2 
      @order.products.each do |product|
        expect(product).must_be_instance_of Product
      end
      
    end
    
    it 'an order can have many order_items' do
    end

    it 'an invalid order_item will not be add to an order' do

    end
  end

  
end
