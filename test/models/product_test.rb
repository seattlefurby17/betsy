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
  end

  describe "relationships" do
    it 'belongs to a merchant' do
      # product = votes(:vote_one)
      Merchant.all.each do |merchant|
        if merchant.id == @product.merchant_id
          expect(@product.merchant_id).must_equal merchant.id
        end
      end
    end

    # it "has many order items" do
    #
    #   expect(@product.order_items)
    #
    # end

  end
end
