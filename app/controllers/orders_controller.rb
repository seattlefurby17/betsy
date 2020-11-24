class OrdersController < ApplicationController
  before_action :require_login, only: :index

  def index
    # @orders = @current_merchant.orders

  end

  def show
    @order = Order.find_by(id: params[:id].to_i)
    if @current_merchant.order_belongs_to_merchant?(@order)
      # Merchant can view this order page
      return
    end

    @order = Order.find_by(id: @shopper)

    if @order.status == "shopping"
      redirect_to cart_path
      return
    end

    if @shopper == params[:id].to_i
      # This is shopper's paid order
      return
    else
      # Unauthorized
      flash[:error] = "You tried to view an order that doesn't belong to you"
      redirect_to root_path
    end
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
    @order.status = 'paid'
    
    if @order.save
      flash[:success] = "Success"
      redirect_to order_path(@shopper)
    else
      @order.errors.each do |type, err|
        flash.now[type] = "Something went wrong: #{type}: #{err}"
      end
      render :check_out
    end
  end



  private
  
  def order_params
    return params.require(:order).permit(:name, :email, :address, :card_number, 
      :expiration_month, :expiration_year, :security_code, :zip_code, :city, :state)
  end

end
