require "test_helper"

describe ProductsController do

  let(:merchant) {
    Merchant.create!(username: "ida", email: "ida@ida.com",
                     provider: "github", uid: "3050")
  }
  let(:product) {
    Product.create!(name: "furby", description: "dog toy", price: 30.50,
                   photo_url: "gettyimages.com", stock: 10, merchant_id: merchant.id)
  }

  describe "index" do
    it "responds with success when products are saved" do
      get products_path
      must_respond_with :success
    end

    it "responds with success when no products are saved" do

      Product.destroy_all
      expect(Product.all.count).must_equal 0

      get products_path

      must_respond_with :success
    end
  end

  describe "show" do
    it "responds with success when showing an existing product" do
      id = product.id

      get product_path(id)
      must_respond_with :success
    end

    it "responds with redirect with an invalid product id" do
      invalid_id = -1

      get product_path(invalid_id)

      must_respond_with :redirect
      must_redirect_to products_path
    end

  end

  describe "new" do
    it "responds with success for a logged in user" do
      perform_login(merchant)
      get new_product_path
      must_respond_with :success
    end

    it "responds with redirect for a guest user" do
      get new_product_path
      must_respond_with :redirect
    end
  end

  describe "create" do
    before do
      @product_hash = {
          product: {
              name: "furbyyy",
              price: 10.25,
              photo_url: "pexels.com",
              stock: 5,
          }
      }
    end
    it "can create a new product with valid information when logged in" do
      perform_login(merchant)

      expect{
        post products_path, params: @product_hash
      }.must_change "Product.count", 1

      created_product = Product.find_by(name: @product_hash[:product][:name])
      expect(created_product.merchant_id).must_equal merchant.id

      must_respond_with :redirect
      must_redirect_to product_path(created_product)
    end

    it "does not create a product if the form data violates product validations" do
      @product_hash[:product][:price] = "a"

      perform_login(merchant)

      expect{
        post products_path, params: @product_hash
      }.wont_change "Product.count"
    end

    it 'won\'t create a product when not logged in' do
      expect{
        post products_path, params: @product_hash
      }.wont_change "Product.count"
    end
  end

  describe "edit" do
    it "responds with success for a logged in user" do
      perform_login(merchant)
      get edit_product_path(product.id)
      must_respond_with :success
    end

    it "responds with redirect for a guest user" do
      get edit_product_path(product.id)
      must_respond_with :redirect
    end
  end

  describe "update" do
    let(:updated_product_hash) {
      {
          product: {
              name: "updated test",
              description: "testing123",
              price: 800.00,
              photo_url: "xyyx",
              stock: 240,
              merchant_id: merchant.id
          }
      }
    }

    before do
      @id = product.id
    end

    it "can update an existing product with valid information when logged in" do
      perform_login(merchant)

      expect{
        patch product_path(@id), params: updated_product_hash
      }.wont_change "Product.count"

      updated_product = Product.find_by(id: @id)

      expect(updated_product.name).must_equal updated_product_hash[:product][:name]
      expect(updated_product.description).must_equal updated_product_hash[:product][:description]

      must_redirect_to product_path(@id)
    end

    it 'won\'t update if product fails validations' do
      perform_login(merchant)
      updated_product_hash[:product][:name] = nil

      expect{
        patch product_path(@id), params: updated_product_hash
      }.wont_change "product.name"
    end
  end

  describe 'retire' do
    it 'can retire a product with a valid id' do
      perform_login(merchants(:ada))

      prod = products(:product_one)

      expect{
        delete product_path(prod.id)
      }.wont_change "Product.count"

       prod.reload #will refresh all values
      expect(prod.retired).must_equal true
      expect(flash[:success]).must_equal "Retired product"
      must_respond_with :redirect
      must_redirect_to product_path(prod)

    end

    it 'cannot find a product with an invalid id' do
      perform_login(merchants(:ada))
      expect{
        delete product_path(-1)
      }.wont_change "Product.count"

      expect(flash[:error]).must_equal "Cannot find product to retire"
      must_respond_with :redirect
      must_redirect_to products_path
    end

    it 'cannot retire a retired product' do
      perform_login(merchants(:ada))

      prod = products(:product_one)
      delete product_path(prod.id)

      expect{
        delete product_path(prod.id)
      }.wont_change "Product.count"

      prod.reload #will refresh all values
      expect(prod.retired).must_equal false
      expect(flash[:success]).must_equal "Put product back for sale!"
      must_respond_with :redirect
      must_redirect_to product_path(prod)
    end
  end

  describe 'find product' do
    it 'can find a product with a valid id' do
      prod = products(:product_one)
      expect(Product.find_by(id: prod.id)).must_equal prod
    end
    it 'cannot find a product with a valid id' do
      # prod = products(:product_one)
      expect(Product.find_by(id: -1)).must_equal nil
    end
  end
end
