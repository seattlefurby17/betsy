require "test_helper"


describe MerchantsController do
  describe "auth_callback" do
    it "logs in an existing merchant" do
      start_count = Merchant.count
      merchant = merchants(:grace)
    
      perform_login(merchant)
      must_redirect_to root_path
      session[:merchant_id].must_equal  merchant.id
    
      # Should *not* have created a new merchant
      merchant.count.must_equal start_count
    end

    it "creates an account for a new merchant and redirects to the root route" do
      start_count = Merchant.count
      merchant = Merchant.new(provider: "github", uid: 99999, username: "test_merchant", email: "test@merchant.com")
    
      perform_login(merchant)
    
      must_redirect_to root_path
    
      # Should have created a new merchant
      merchant.count.must_equal start_count + 1
    
      # The new merchant's ID should be set in the session
      session[:merchant_id].must_equal merchant.last.id

    end

    it "redirects to the login route if given invalid merchant data" do
    skip # need validations in model
    end
  end
end
