class HomepagesController < ApplicationController
  def index
    @spotlight = Product.spotlight()
    churro_images = ["churro-1.jpg", "churro-2.jpg", "churro-3.jpg", "churro-4.jpg", "churro-5.jpg", "churro-6.jpg"]
    @churro = churro_images.sample
  end
end

