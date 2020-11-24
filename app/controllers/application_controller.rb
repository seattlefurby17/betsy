class ApplicationController < ActionController::Base
  # before_action :require_login
  before_action :get_current_merchant, :shopper

  def get_current_merchant
    @current_merchant = Merchant.find(session[:merchant_id]) if session[:merchant_id]
  end

  def require_login
    if @current_merchant.nil?
      flash[:error] = "You must be logged in to view this section"
      redirect_to root_path
    end
  end

  def shopper
    if Order.find_by(id: session[:shopper_id]).nil?
        session[:shopper_id] = Order.create!(status: "shopping").id
        session[:orders] = [] # Keep track of orders made by user
    end
    @shopper = session[:shopper_id]
    @orders = session[:orders]

    return @shopper

  end

end
