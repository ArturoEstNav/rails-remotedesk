namespace :remotive do
  desc "Fetches job offers from Indeed and remotive"
  task create_indeed_offers: :environment do
    OfferJob.perform_now
  end
end
