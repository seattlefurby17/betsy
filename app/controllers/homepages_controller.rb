class HomepagesController < ApplicationController
  def index
    @spotlight = Product.spotlight()
  end
end

