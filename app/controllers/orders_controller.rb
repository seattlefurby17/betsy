class OrdersController < ApplicationController
  def show
    @order = Order.find_by(id: @shopper)
    # raise
    if @order.status == "shopping"  #need to get help on this
      redirect_to cart_path
      return
    end

    # if @shopper != params[:id]
    #   flash[:error] = "Something happened"
    #   redirect_to root_path
      # elsif merchant.orders #add more logic to this after show page is done
    # end
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
    # raise
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
