require "test_helper"

describe ProductsController do

  let(:product) {
    Product.create(name: "furby", description: "dog toy", price: 30.50,
                   photo_url: "gettyimages.com", stock: 10)
  }
  let(:merchant) {
    Merchant.create(username: "ida", email: "ida@ida.com",
                    provider: "github", uid: "3050")
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

    it "must get index" do
      get products_path
      must_respond_with :success
    end
  end

  describe "new" do
    it "responds with success" do
      get new_product_path
      must_respond_with :success
    end
  end

  describe "create" do
    it "can create a new product with valid information" do
      product_hash = {
          product: {
              name: "furbyyy",
              price: 10.25,
              photo_url: "pexels.com",
              stock: 5,
              merchand_id: 1
          }
      }

      expect{
        post products_path, params: product_hash
      }.must_change "Product.count", 1

      created_product = Product.find_by(name: product_hash[:product][:name])
      expect(created_product.id).must_equal product_hash[:product][:id]

      must_respond_with :redirect
      must_redirect_to product_path(created_product)
    end

    it "does not create a passenger if the form data violates Product validations" do
      invalid_product_hash = {
          product: {
              name: nil,
              price: nil,
              photo_url: nil,
              stock: nil,
              merchand_id: nil
          }
      }

      expect{
        post products_path, params: invalid_product_hash
      }.wont_change "Product.count"
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

    it "can update an existing product with valid information" do
      id = product.id

      expect{
        patch product_path(id), params: updated_product_hash
      }.wont_change "Product.count"

      updated_product = Product.find_by(id: id)

      expect(updated_product.name).must_equal updated_product_hash[:product][:name]
      expect(updated_product.description).must_equal updated_product_hash[:product][:description]

      must_redirect_to product_path(id)
    end
  end
end
