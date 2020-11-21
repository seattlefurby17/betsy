class OrdersController < ApplicationController
  def index
    @orders = Order.all
  end

  def cart
    @order = Order.find_by(id: @shopper)
  end

end
