require "test_helper"

describe OrderItemsController do
  before do
    # @ada = perform_login(merchants(:ada))
    get root_path # To set cart
    @shopper = session[:shopper_id]
    @order = Order.find_by(id: @shopper)
    @order.name = 'ada'
    @order.email = 'fjfj@jddj.com'
  end

  describe 'add_to_cart' do
    it "returns error and redirect when adding a retired product" do
      # create a valid order
      # create a product
      @product = products(:product_one)
      # set the product to retire
      @product.retired = true
      # try to add the retire product to cart
      @product.save
      patch add_cart_path(id: @product.id, quantity: 1)
      # expect redirect and flash error
      expect(flash[:error]).must_equal "That product is retired!"
      must_respond_with :redirect
    end
  end


  it "can add to an existing order" do
    # create an order
    # try to add another order to cart
    @product = products(:product_one)

    patch add_cart_path(id: @product.id, quantity: 1)
    expect {
      patch add_cart_path(id: @product.id, quantity: 1)
    }.wont_change "@order.order_items.count"
  end


  it "returns error for invalid product quantity " do
    # Arrange
    @product = products(:product_one)
    patch add_cart_path(id: @product.id, quantity: -1)
    # Assert
    expect(flash[:error]).must_equal "Invalid quantity to add to cart given"
  end

  it "returns error for item/product not found " do

    patch add_cart_path(id: 200, quantity: 1)
    expect(flash[:error]).must_equal "Product to add to cart not found"
  end

  describe 'destroy' do

    it "returns error when unable to delete product" do

      delete order_item_path(3)
      expect(flash[:error]).must_equal "Could not delete product"
    end
  end


  private

  def add_products_to_cart
    patch add_cart_path(id: products(:product_one).id, quantity: 1)
    patch add_cart_path(id: products(:product_two).id, quantity: 1)
  end

  def checkout_products
    post process_order_path({
                                order: {
                                    name: @order.name,
                                    email: @order.email,
                                    address: @order.address,
                                    card_number: @order.card_number,
                                    expiration_month: @order.expiration_month,
                                    expiration_year: @order.expiration_year,
                                    security_code: @order.security_code,
                                    zip_code: @order.zip_code
                                }
                            })
  end
end
