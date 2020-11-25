require "test_helper"


describe MerchantsController do

  describe 'index' do
    it 'must get index' do
      get merchants_path
      must_respond_with :success
    end
  end

  describe 'show' do
    it 'can show a merchants page' do
      get merchant_path(merchants(:grace).id)
      must_respond_with :success
    end

    it 'won\'t show an invalid merchant' do
      get merchant_path(-1)
      must_respond_with :redirect
    end
  end

  describe "auth_callback" do
    it "logs in an existing merchant" do
      merchant = merchants(:grace)
    
      expect { perform_login(merchant) }.wont_change "Merchant.count"
      must_redirect_to root_path
      expect(session[:merchant_id]).must_equal merchant.id
      expect(flash[:success]).must_include "returning merchant"
    end

    it "creates an account for a new merchant and redirects to the root route" do
      merchant = Merchant.new(provider: "github", uid: 99999, username: "test_merchant", email: "test@merchant.com")
      
      # Should have created a new merchant
      expect { perform_login(merchant) }.must_change "Merchant.count", 1
      expect(flash[:success]).must_include "new merchant"

      must_redirect_to root_path
    
      # The new merchant's ID should be set in the session
      expect(session[:merchant_id]).must_equal Merchant.last.id

    end

    it "doesn't create a merchant if given invalid merchant data" do
      merchant = Merchant.new(provider: "github", uid: 99999, username: "test_merchant", email: nil)

      expect { perform_login(merchant) }.wont_change "Merchant.count"

      expect(session[:merchant_id]).must_be_nil
      expect(flash[:error]).must_include "Could not create"

    end

    it "fails if given duplicate merchant data" do
      merchant = Merchant.new(provider: "github", uid: 99999, username: "test_merchant",
                              email: "grace@hooper.net")

      expect { perform_login(merchant) }.wont_change "Merchant.count"
      expect(flash[:error]).must_include "Could not create"

      expect(session[:merchant_id]).must_be_nil
    end


  end

  describe 'destroy' do
    it 'can destroy a merchant' do
      perform_login(merchants(:grace))
      delete logout_path
      expect(session[:merchant_id]).must_be_nil
      expect(flash[:success]).must_include "Successfully logged out!"
      must_redirect_to root_path


    end
  end
end
