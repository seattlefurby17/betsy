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

end
