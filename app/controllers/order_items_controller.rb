class OrderItemsController < ApplicationController

  def add_to_cart
    @product = Product.find_by(id: params[:id])
    # Check if the item exists
    if @order_item = OrderItem.find_by(product_id: @product.id, order_id: @shopper)
      # Add to the existing quantity instead of creating a new item
      @order_item.quantity += params["quantity"].to_i
      @order_item.save
    else
      # Create a new order item with appropriate quantity
    @order_item = OrderItem.create!(product_id: @product.id, order_id: @shopper, quantity:
        params["quantity"].to_i)
    end

    redirect_to cart_path
    return @order_item

  end

  def edit_quantity
    @product = Product.find_by(id: params[:id])
    # If the item exists
    if @order_item = OrderItem.find_by(product_id: @product.id, order_id: @shopper)
      # Alter the order quantity
      @order_item.quantity = params["quantity"].to_i
      if @order_item.save.nil?
        # Save failed
        flash["error"] = "Invalid quantity specified"
      else
        flash["success"] = "Quantity updated!"
      end
    else
      # Item not found
      flash["error"] = "Item to edit quantity not found"
    end

    redirect_to cart_path

  end


end
