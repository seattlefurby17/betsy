class MerchantsController < ApplicationController
  before_action :require_login, only: [ :dashboard, :manage_orders, :manage_products, :logout]
  
  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find_by(id: params[:id])

    if @merchant.nil?
      redirect_to merchants_path
      return
    end

  end

  def create # same as login
    auth_hash = request.env['omniauth.auth']
    merchant = Merchant.find_by(uid: auth_hash[:uid], provider: "github")
    if merchant
      # merchant was found in the database
      flash[:success] = "Logged in as returning merchant #{merchant.username}"
    else
      # merchant doesn't match anything in the DB
      # Attempt to create a new merchant
      merchant = Merchant.build_from_github(auth_hash)

      if merchant.save
        flash[:success] = "Logged in as new merchant #{merchant.username}"
      else
        # Couldn't save the merchant for some reason. If we
        # hit this it probably means there's a bug with the
        # way we've configured GitHub. Our strategy will
        # be to display error messages to make future
        # debugging easier.
        flash[:error] = "Could not create new merchant account: #{merchant.errors.messages}"
        redirect_to root_path
        return
      end
    end

    # If we get here, we have a valid merchant instance
    session[:merchant_id] = merchant.id
    redirect_to root_path
    return
  end

  def dashboard; end

  def manage_orders; end

  def manage_products; end

  def destroy # same as logout
    session[:merchant_id] = nil
    flash[:success] = "Successfully logged out!"

    redirect_to root_path
  end


end

