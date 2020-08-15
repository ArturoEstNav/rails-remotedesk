class ApiOffer
  def remotive_api_scrape
    remotive_api_url = 'https://remotive.io/api/remote-jobs?category=software-dev'
    offers_text = open(remotive_api_url).read
    offers_json = JSON.parse(offers_text)
    offers_json['jobs']
  end

  # feeds information found in Remotive API to Offer Model
  def copy_offer_variables(new_offer, external_offer)
    new_offer.external_id = external_offer['id'].to_s
    new_offer.company = external_offer['company_name']
    new_offer.title = external_offer['title']
    new_offer.description = external_offer['description']
    new_offer.salary = external_offer['salary']
    new_offer.category = external_offer['category']
    new_offer.job_type = external_offer['job_type']
    new_offer.location = external_offer['candidate_required_location']
    new_offer.posting_date = external_offer['publication_date']
    new_offer.listing_url = external_offer['url']
    # This assignment will get set to the creator method so this one can be used for multiple APIS
    # new_offer.source = 'remotive'
  end

  def create_remotive_offers
    remotive_offers = remotive_api_scrape
    remotive_offers.each do |offer|
      new_offer = Offer.where(external_id: offer['id'].to_s, source: 'remotive').first_or_initialize
      copy_offer_variables(new_offer, offer)
      # This property assignation was placed here to make the copy_offer_variables method more versatile
      new_offer.source = 'remotive'
      offer['tags'].each do |tag|
        new_offer.tags << Tag.where(name: tag).first_or_create
      end
      new_offer.save!
    end
  end

  def update_offers_active_status(array_offer_hashes, source)
    source_offers = array_offer_hashes
    db_source_offers = Offer.where(source: source)
    db_source_offers.each do |db_offer|
      if source_offers.detect { |src_offer| src_offer['id'].to_s == db_offer.external_id }.nil?
        db_offer.active = false
      end
      db_offer.save!
    end
  end
end