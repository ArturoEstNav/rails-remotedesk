class OfferJob < ApplicationJob
  queue_as :default

  def perform
    ApiOffer.create_remotive_offers
    array_of_offers = ApiOffer.remotive_api_scrape
    ApiOffer.update_offers_active_status(array_of_offers, 'remotive')
  end
end
