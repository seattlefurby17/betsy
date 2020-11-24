require "test_helper"

describe Merchant do
  before do
    @merchant = Merchant.create(username: "test merchant", email: "coolperson@cool.com", provider:
        "github", uid: "832943")
    @product = Product.create(name: "test name", description: "test description", price: 4.55,
                              photo_url: "gettyimages.com", stock: 10, merchant_id: @merchant.id)
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
      invalid_email = Merchant.create(username: "test merchant", email: "coolperson@cool.com", provider:
          "github", uid: "832943")
      expect(invalid_email.valid?).must_equal false
    end

  end

  describe 'relations' do

    it 'has many products' do
      expect(@merchant.respond_to?(:products)).must_equal true
    end

    # it 'can retire a product' do
    #   expect (@merchant.destroy(@product)).must_change  
    # end 

  end

end
