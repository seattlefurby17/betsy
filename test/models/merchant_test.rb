require "test_helper"

describe Merchant do
  before do
    @merchant = merchants(:ada)
    @product = Product.create(name: "test name", description: "test description", price: 4.55,
                              photo_url: "gettyimages.com", stock: 10, merchant_id: @merchant.id)

    @product1 = products(:product_one)
    @order = orders(:first_order)

    @order_item = OrderItem.create!(product_id: @product.id, order_id: @order.id, quantity: 2)
    @order_item1 = OrderItem.create!(product_id: @product1.id, order_id: @order.id, quantity: 2)
    
  end

  describe "validations" do
    it "can be instantiated" do
      expect(@merchant.valid?).must_equal true
    end

    it "fails validations when username is not present" do
      invalid_merchant = Merchant.create(email: "coolperson@cool.com",
                                         provider: "github", uid: "832943")
      expect(invalid_merchant.valid?).must_equal false
    end

    it "fails validations when username is not unique" do
      invalid_name = Product.create(name: "test name", description: "new description", price: 1.55,
                                    photo_url: "gettyimages.com", stock: 10, merchant_id: @merchant.id)
      expect(invalid_name.valid?).must_equal false
    end

    it "fails validations when email is not present" do
      missing_email = Merchant.create(username: "test merchant", provider:
          "github", uid: "832943")
      expect(missing_email.valid?).must_equal false
    end

    it "fails validation when email is not unique" do
      invalid_email = Merchant.create(username: "test merchant", email: "ada@adadevelopersacademy.org", provider:
          "github", uid: "832943")
      expect(invalid_email.valid?).must_equal false
    end

  end

  describe 'relations' do

    it 'has many products' do
      expect(@merchant.respond_to?(:products)).must_equal true
    end

  end

  describe 'total_revenue' do
    it 'must properly calculate the total revenue for the order' do

      expect(@merchant.total_revenue()).must_equal (4.55 * 2) + (9.99 * 2)
    end

    it "must calculate total revenue for a given status" do
      orders.first.update(status: 'processing')
      expect(@merchant.total_revenue('processing')).must_equal 29.08
    end

    it 'returns 0 when there are no orders for a given status' do
      expect(@merchant.total_revenue('shipped')).must_equal 0
    end
  end

  describe 'total_num' do
    it 'returns the number of orders a merchant has' do
      expect(@merchant.total_num).must_equal 1
    end

    it "must calculate total number of orders for a given status" do
      orders.first.update(status: 'processing')
      expect(@merchant.total_num('processing')).must_equal 1
    end

    it 'returns 0 when there are no orders for a given status' do
      expect(@merchant.total_num('shipped')).must_equal 0
    end

  end

  describe 'total_order' do
    it 'return the collection of orders a merchant has' do
      @added_order = orders(:second_order)
      @order_item = OrderItem.create!(product_id: @product1.id, order_id: @added_order.id, quantity: 2)
      @merchant.total_orders.each do |order|
        expect(order).must_be_instance_of Order
      end
      expect(@merchant.total_num).must_equal 2
    end
    it "must calculate total number of orders for a given status" do
      orders.first.update(status: 'processing')
      expect(@merchant.total_num('processing')).must_equal 1
    end

  end

  describe 'order_belongs_to_merchant?' do
    it 'checks if an order belongs to a merchant' do
      expect(@merchant.order_belongs_to_merchant?(@order)).must_equal true
    end
  end

end
