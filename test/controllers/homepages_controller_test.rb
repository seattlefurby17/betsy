require "test_helper"

describe HomepagesController do
  
  it "must get index" do
    get homepages_path
    must_respond_with :success
  end

end
