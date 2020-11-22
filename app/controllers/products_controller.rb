class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :retire]
  before_action :require_login, except: [:index, :show]

  def index
    @products = Product.all
  end

  def show
    if @product.nil?
      redirect_to products_path
      return
    end
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    @product.merchant = @current_merchant

    if @product.save
      redirect_to product_path(@product.id)
      return
    else
      @product.errors.each do |type, err|
        flash.now[type] = "Something went wrong: #{type}: #{err}"
      end
      render :new
    end
  end

  def edit
    if @product.nil?
      redirect_to products_path
      return
    end
  end

  def update
    if @product.nil?
      flash[:error] = "Cannot find product to update"
      redirect_to products_path
      return
    elsif @product.update(product_params)
      redirect_to product_path(@product.id)
      return
    else
      @product.errors.each do |type, err|
        flash.now[type] = "Something went wrong: #{type}: #{err}"
      end
      render :edit
      return
    end
  end


  def retire

    if @product.nil?
      flash[:error] = "Cannot find product to retire"
      redirect_to products_path
    end
    @product.retired = true
  end

  private

  def find_product
    @product = Product.find_by(id: params[:id])
  end


  def product_params
    return params.require(:product).permit(:name, :description, :price, :photo_url, :stock)
  end

end
