class MerchantsController < ApplicationController

  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find_by(username: params[:username])

    if @merchant.nil?
      redirect_to merchants_path
      return
    end
  end
end
