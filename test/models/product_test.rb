require "test_helper"

describe Product do
  before do
    @merchant = Merchant.create(username: "coolperson", email: "coolperson@cool.com", provider:
        "github", uid: "832943")
    @product = Product.create(name: "test name", description: "test description", price: 4.55,
                              photo_url: "gettyimages.com", stock: 10, merchant_id: @merchant.id)
  end

  describe "validations" do
    it "can be instantiated" do
      expect(@product.valid?).must_equal true
    end

    it "fails validations when name is not present" do
      invalid_product = Product.create(description: "test description", price: 2.55,
                                photo_url: "gettyimages.com", stock: 10, merchant_id: @merchant.id)
      expect(invalid_product.valid?).must_equal false
    end

    it "fails validations when name is not unique" do
      invalid_name = Product.create(name: "test name", description: "new description", price: 1.55,
                                    photo_url: "gettyimages.com", stock: 10, merchant_id: @merchant.id)
      expect(invalid_name.valid?).must_equal false
    end

    it "fails validations when price is not a number" do
      invalid_number = Product.create(name: "test name", description: "test description", price: "letters",
                                photo_url: "gettyimages.com", stock: 10, merchant_id: @merchant.id)
      expect(invalid_number.valid?).must_equal false
    end

    it "fails validations when price is less than 0" do
      negative_number = Product.create(name: "test name", description: "test description", price: -200,
                                                   photo_url: "gettyimages.com", stock: 10, merchant_id: @merchant.id)
      expect(negative_number.valid?).must_equal false
    end

    it "fails validations when price is not present" do
      missing_price = Product.create(name: "test name", description: "test description",
                                                 photo_url: "gettyimages.com", stock: 10, merchant_id: @merchant.id)
      expect(missing_price.valid?).must_equal false
    end

  end

  describe "relationships" do
    it 'belongs to a merchant' do
     expect(@product).must_respond_to :merchant
     expect(@product.merchant).must_be_instance_of Merchant
     
    end

    it "has many order items" do
      expect(@product.respond_to?(:order_items)).must_equal true
    end

  end
end
