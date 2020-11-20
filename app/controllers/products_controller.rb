class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :retire]

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
    if @product.save
      redirect_to product_path(@product.id)
      return
    else
      @product.errors.each do |type, err|
        flash[type] = err
      flash[type] = err
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
      render :edit
      return
    end

  def retire

    if @product.nil?
      flash[:error] = "Cannot find product to retire"
      redirect_to products_path
    end
    @product.
    end
  end

  private

  def find_product
    @product = Product.find_by(id: params[:id])
  end

  def product_params
    return params.require(:product).permit(:id, :name, :vin, :available)
  end

end
