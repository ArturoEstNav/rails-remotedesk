namespace :user do
  desc "TODO"
  task create_api_offers: :environment do
    OfferJob.set(wait_until: Date.tomorrow.noon).perform_later
  end
end
