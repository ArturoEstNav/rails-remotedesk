require 'open-uri'
require 'nokogiri'
require 'json'

class OffersController < ApplicationController
  skip_before_action :authenticate_user!

  def index
  end

  def show
    @offer = Offer.find(params[:id])
  end

  def create
    new_api_offer = ApiOffer.new
    new_api_offer.create_remotive_offers
  end

  def update
    new_api_offer = ApiOffer.new
    new_api_offer.update_offers_active_status(remotive_api_scrape, 'remotive')
  end
end
