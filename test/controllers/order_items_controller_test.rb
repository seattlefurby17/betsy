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

  describe 'edit quantity' do
    it 'can alter quantity of an order item' do
      @product = products(:product_one)
      patch add_cart_path(id: @product.id, quantity: 1)
      patch edit_quantity_path(id: @product.id, quantity: 2)
      @order_item = OrderItem.find_by(product_id: @product.id, order_id: @shopper)
      expect(@order_item.quantity).must_equal 2
    end

    it 'fails to alter an invalid quantity' do
      @product = products(:product_one)
      patch add_cart_path(id: @product.id, quantity: 1)
      patch edit_quantity_path(id: @product.id, quantity: -1)
      expect(flash[:error]).must_include "Invalid"
      @order_item = OrderItem.find_by(product_id: @product.id, order_id: @shopper)
      expect(@order_item.quantity).must_equal 1

    end

    it 'can\'t edit quantity of invalid object' do
      patch edit_quantity_path(id: 3939, quantity: 1)
      expect(flash[:error]).must_include "not found"
    end
  end

  describe 'destroy' do

    it "returns error when unable to delete product" do

      expect { delete order_item_path(3) }.wont_change "@order.order_items.count"
      expect(flash[:error]).must_equal "Could not delete product"
      must_respond_with :redirect
    end

    it 'successfully deletes a product' do
      @product = products(:product_one)
      patch add_cart_path(id: @product.id, quantity: 1)
      expect { delete order_item_path(@product.id) }.must_change "@order.order_items.count", -1
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
