require "test_helper"

describe Order do
  before do # a test case that will pass all validations
    @order = Order.create!(name: 'ada', email: 'banana@123.com', 
      address: 'test address', card_number: 123456789123456789, expiration_month: 01,
      expiration_year: 2022, security_code: 123, zip_code: 11221)
    @merchant = merchants(:grace)
    @product = Product.create!(name: 'test toy', price: 222, merchant_id: @merchant.id)
    @product1 =Product.create!(name: 'test toy1', price: 111, merchant_id: @merchant.id)
    @order_item = OrderItem.create!(product_id: @product.id, order_id: @order.id, quantity: 2)
    @order_item1 = OrderItem.create!(product_id: @product1.id, order_id: @order.id, quantity: 2)
  end
  
  describe 'validations' do

    it 'should be a valid order when all fields are filled' do
      expect(@order.valid?).must_equal true
    end

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
      # expect(@order.errors.messages[:expiration_year].include?("Invalid card number")).must_equal true
    end

    it "fails validations when expiration month is less than current month" do
      @order.expiration_year = Time.now.year
      @order.expiration_month = Time.now.month - 1
      expect(@order.valid?).must_equal false
      @order.expiration_year_cannot_be_in_the_past
      expect(@order.errors.messages[:expiration_month].include?("can't be in the past")).must_equal true
    end

    it "fails validations when expiration year is less than current year" do
      @order.expiration_month = Time.now.month
      @order.expiration_year = Time.now.year - 1
      expect(@order.valid?).must_equal false
      @order.expiration_year_cannot_be_in_the_past
      expect(@order.errors.messages[:expiration_year].include?("can't be in the past")).must_equal true
    end

    it "fails validations when zip code is not integer" do
      @order.zip_code = 'string'
      expect(@order.valid?).must_equal false
    end

  end

  describe "relationships" do

    it 'an order can have many products through order_items' do 
      expect(@order.products.size).must_equal 2
      @order.products.each do |product|
        expect(product).must_be_instance_of Product
      end

    end

    it 'an order can have many order_items' do
      expect(@order.order_items.count).must_equal 2
      @order.order_items.each do |orderitem|
        expect(orderitem).must_be_instance_of OrderItem
      end

    end

    it 'an invalid order_item will not be add to an order' do

      expect{ OrderItem.create(product_id: nil, order_id: @order.id, quantity: 2) }.wont_change "@order.order_items.count"

    end
  end

  describe 'total' do

    it 'will return the total of an order' do
      expect(@order.total).must_equal 666
    end

  end

end
