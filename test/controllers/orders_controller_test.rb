require "test_helper"

describe OrdersController do
  before do
    # @ada = perform_login(merchants(:ada))
    get root_path # To set cart
    @shopper = session[:shopper_id]
    @order = Order.find_by(id: @shopper)
    @order.name = orders(:first_order).name
    @order.email = orders(:first_order).email
    @order.address = orders(:first_order).address
    @order.card_number = orders(:first_order).card_number
    @order.expiration_month = orders(:first_order).expiration_month
    @order.expiration_year = orders(:first_order).expiration_year
    @order.security_code = orders(:first_order).security_code
    @order.zip_code = orders(:first_order).zip_code
    @order.save
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

    it 'handles nil orders appropriately' do
      get orders_path
      expect(session[:orders]).must_equal []
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

  describe 'check_out' do
    it 'redirects for an empty cart' do
      get checkout_path
      expect(flash[:error]).must_include "empty"
      must_respond_with :redirect
    end

    it 'succeeds for a cart with items' do
      add_products_to_cart
      get checkout_path
      must_respond_with :success
    end
  end

  describe 'process order' do
    it 'Processes an order' do
      add_products_to_cart
      checkout_products
      expect(session[:orders]).must_equal [@order.id]
      expect(flash[:success]).must_include "Order placed"
      expect(session[:shopper_id]).wont_equal @order.id
      # expect(@order.status).must_equal 'paid' # TODO fix this - not working
      must_respond_with :redirect
    end

    it 'doesn\'t process an invalid order' do
      add_products_to_cart
      @order.name = '33'
      @order.email = '33'
      @order.save
      checkout_products
      expect(@order.errors).wont_be_nil
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
                                    zip_code: @order.zip_code,
                                }
                            })
  end
end
