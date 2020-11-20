class ApplicationController < ActionController::Base
  # before_action :require_login
  before_action :get_current_merchant

  def get_current_merchant
    @current_merchant = Merchant.find(session[:merchant_id]) if session[:merchant_id]
  end

  def require_login
    if current_merchant.nil?
      flash[:error] = "You must be logged in to view this section"
      redirect_to login_path
    end
  end
end
