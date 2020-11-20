class ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def show
    @product = Product.find_by(id: params[:id])

    if @product.nil?
      redirect_to products_path
      return
    end
  end

  def new
    @product = Product.new
  end

  def create
    # @product = Product.new(product_parms)
    @product = Product.new(product_params)

    if @product.save
      redirect_to product_path(@product.id)
      return
    else
      @product.errors.each do |type, err|
      flash[type] = err
      end
      render :new
    end
  end

  def product_params
    return params.require(:product).permit(:name, :description, :price, :photo_url, :stock)
  end

end
