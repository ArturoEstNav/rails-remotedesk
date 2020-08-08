class OffersController < ApplicationController
  def index
    @offers = Offer.all
    # search algorithm
    # @selected_offers = where
  end

  def show
    @offer = Offer.find(params[:id])
  end

  private

  # def new
  # end

  def create
    # @offers = Lista de parseo de API + scrapping
    # @offers.each do |offer|
    #   @new_offer = Offer.new()
    #   @new_offer.title = something
    #   @new_offer.company = something
    #   @new_offer.description = something
    #   @new_offer.job_type = something
    #   @new_offer.posting_date = something
    #   @new_offer.listing_url = something
    #   # scrapping/API info goes here
    #   @new_offer.save
    # end
  end

  # def edit
  # end

  def update
    # @offer = Offer.find(params[:id])
    # scrapping/API info goes here
    # @offer.active = ____
  end
end
