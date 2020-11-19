require "test_helper"

describe ProductsController do
  let(:product) {
    Product.create(name: "furby", description: "dog toy", price: 30.50,
                   photo_url: "gettyimages.com", stock: 10)
  }
  describe "index" do
    it "responds with success when products are saved" do
      # get products_index_url
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


end
