class OrdersController < ApplicationController
  def show
    @order = Order.find_by(id: @shopper)
  end

  def cart
    @order = Order.find_by(id: @shopper)
  end

  def check_out # Loads the checkout form
    @order = Order.find_by(id: @shopper)
  end

  def process_order # Customer clicked purchase button, process order
    @order = Order.find_by(id: @shopper)
    @order.update(order_params)
    @order.status = 'processing'
    @order.save
    redirect_to order_path
    # raise
  end

  private

  def order_params
    return params.require(:order).permit(:name, :email, :address, :card_number, 
      :expiration_month, :expiration_year, :security_code, :zip_code)
  end

end
