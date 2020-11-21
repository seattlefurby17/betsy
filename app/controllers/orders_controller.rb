class OrdersController < ApplicationController
  def index
    @orders = Order.all
  end

  def cart
    @order = Order.find_by(id: @shopper)
  end

  def add_to_cart
    @product = Product.find_by(id: params[:id])
    @order_item = OrderItem.create!(product_id: @product.id, order_id: @shopper, quantity: 1)

    redirect_to cart_path
    return @order_item

  end

  def check_out # new
    @order = Order.find_by(id: @shopper)
  end

  def process_order # 
    @order = Order.find_by(id: @shopper)
    @order = order_params
    @order.status = 'processing'
    raise

  end

  private

  # def find_order
  #   @order = Order.find_by(id: params[:id])
  # end


  def order_params
    return params.require(:order).permit(:name, :email, :address, :card_number, 
      :expiration_month, :expiration_year, :security_code, :zip_code)
  end




end
