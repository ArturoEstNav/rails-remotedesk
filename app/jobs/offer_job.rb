class OfferJob < ApplicationJob
  queue_as :default

  def perform
    api_offer = ApiOffer.new
    api_offer.create_remotive_offers
    array_of_offers = api_offer.remotive_api_scrape
    api_offer.update_offers_active_status(array_of_offers, 'remotive')

    #scrapping
  end
end
