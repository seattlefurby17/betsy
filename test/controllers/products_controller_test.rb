require "test_helper"

describe ProductsController do
  it "must get index" do
    get products_index_url
    must_respond_with :success
  end

end
