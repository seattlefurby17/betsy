require "test_helper"

describe OrdersController do
  before do
    # @ada = perform_login(merchants(:ada))
    get root_path # To set cart
    @shopper = session[:shopper_id]
    @order = Order.find_by(id: @shopper)
    @order.name = 'ada'
    @order.email = 'fjfj@jddj.com'
  end


  describe 'index' do
    it "must get index" do
      add_products_to_cart
      checkout_products
      get orders_path
      must_respond_with :success
    end

    it 'reads orders from session' do
      get orders_path
      add_products_to_cart
      checkout_products
      expect(session[:orders]).must_equal [@order.id]
      must_respond_with :redirect
    end
  end

  describe 'cart' do
    it 'must get cart path' do
      get cart_path
      must_respond_with :success
    end

    it 'gets check out page if cart has items' do
      add_products_to_cart
      get checkout_path
      must_respond_with :success
    end

    it 'redirects to cart if cart is empty' do
      get checkout_path
      must_respond_with :redirect
    end
  end

  describe 'show' do
    it 'can view own paid order' do
      add_products_to_cart
      checkout_products
      get order_path(@order)
      must_respond_with :success
    end

    it 'in progress order redirects to cart' do
      add_products_to_cart
      get order_path(@order)
      must_respond_with :redirect
    end

    it 'user can view a past order' do
      old_order = @order.id
      add_products_to_cart
      checkout_products
      add_products_to_cart
      checkout_products
      get order_path(old_order)
      must_respond_with :success
    end

    it 'user can\'t view someone else\'s order' do
      add_products_to_cart
      checkout_products
      get order_path(orders(:paid_order))
      must_respond_with :redirect
      expect(flash[:error]).must_include "tried to view"
    end

    it 'user can\'t view an order that doesn\'t exist' do
      get order_path(1337)
      must_respond_with :redirect
      expect(flash[:error]).must_include "exist"
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
