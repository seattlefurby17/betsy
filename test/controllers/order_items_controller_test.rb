require "test_helper"

describe OrderItemsController do
  # it "must get index" do
  #   get order_items_index_url
  #   must_respond_with :success
  # end
  #
  it "can save an order" do


  end

  it "can add to an existing order" do

  end

  it "can retire a product and redirect to products path" do



    must_respond_with :redirect
    expect(flash[:error]).must_equal "That product is retired!"
  end

  it "can update a product quantity" do



    expect(flash[:success]).must_equal "Quantity updated!"
  end

  it "returns error for invalid product quantity " do
    # Arrange

    # Act
    # Assert
    expect(flash[:error]).must_equal "Invalid quantity specified"
  end

  it "returns error for item/product not found " do
    # Arrange

    # Act
    # Assert
    expect(flash[:error]).must_equal "Item to edit quantity not found"
    end
end
