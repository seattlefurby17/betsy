class OrdersController < ApplicationController
  before_action :find_order, except: [:index, :show]

  def index
    # @orders = @current_merchant.orders
    @orders = session[:orders]
    # To not break existing carts
    if @orders.nil?
      session[:orders] = []
      @orders = session[:orders]
    end

  end

  def show
    @order = Order.find_by(id: params[:id].to_i)
    if @order.nil?
      # Not found
      flash[:error] = "The order doesn't exist!"
      redirect_to root_path
    elsif @current_merchant&.order_belongs_to_merchant?(@order) #check for nil before calling the method
      # Merchant can view this order page
      return
    elsif @orders.include?(@order.id)
      # User can view one of their past orders
      return
    elsif @order.id == @shopper
      # User is viewing order in progress
        redirect_to cart_path
        return
    else
      # Unauthorized
      flash[:error] = "You tried to view an order that doesn't belong to you"
      redirect_to root_path
    end
  end

  def cart
  end

  def check_out # Loads the checkout form
    if @order.order_items.empty?
      flash[:error] = "Your cart is empty!"
      redirect_to cart_path
    end
  end

  def process_order # Customer clicked purchase button, process order
    @order.update(order_params)
    @order.status = 'paid'
    
    if @order.save!
      session[:orders] << @order.id # Add order ID to list of orders
      session[:shopper_id] = Order.create!(status: "shopping").id # Start a new cart/order for user
      flash[:success] = "Order placed successfully, please wait two decades for processing"
      redirect_to order_path(@shopper)
    else
      @order.errors.each do |type, err|
        flash.now[type] = "Something went wrong: #{type}: #{err}"
      end
      render :check_out
    end
  end

  private

  def find_order
    @order = Order.find_by(id: @shopper)
  end
  
  def order_params
    return params.require(:order).permit(:name, :email, :address, :card_number, 
      :expiration_month, :expiration_year, :security_code, :zip_code, :city, :state)
  end

end
