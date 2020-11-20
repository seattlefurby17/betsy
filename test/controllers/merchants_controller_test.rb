require "test_helper"


describe MerchantsController do
  describe "auth_callback" do
    it "logs in an existing merchant" do
      merchant = merchants(:grace)
    
      expect { perform_login(merchant) }.wont_change "Merchant.count"
      must_redirect_to root_path
      expect(session[:merchant_id]).must_equal merchant.id
    
    end

    it "creates an account for a new merchant and redirects to the root route" do
      merchant = Merchant.new(provider: "github", uid: 99999, username: "test_merchant", email: "test@merchant.com")
      
      # Should have created a new merchant
      expect { perform_login(merchant) }.must_change "Merchant.count", 1
      must_redirect_to root_path
    
      # The new merchant's ID should be set in the session
      expect(session[:merchant_id]).must_equal Merchant.last.id

    end

    it "redirects to the login route if given invalid merchant data" do
    skip # need validations in model
    end
  end
end
