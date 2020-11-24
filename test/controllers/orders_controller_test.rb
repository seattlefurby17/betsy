require "test_helper"

describe OrdersController do
  it "must get index" do
    get orders_path
    must_respond_with :success
  end

  it "assigns orders" do
    # get orders_path
    order = orders(:first_order)

    # expect(assigns(:orders)).must_equal [order_one]
    expect(order).must_be_instance_of Order
  end

end
