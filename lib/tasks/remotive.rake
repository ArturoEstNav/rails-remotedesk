namespace :remotive do
  desc "Fetches job offers from Remotive API"
  task create_api_offers: :environment do
    OfferJob.perform_now
  end
end
