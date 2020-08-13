require 'open-uri'

class OffersController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @offers = Offer.all
    @match = Match.new
  end

  def show
    @offer = Offer.find(params[:id])
  end

  def create
    create_remotive_offers
    # create_indeed_offers
  end

  def update
    update_remotive_offer_active_status
  end

  private

  # method to collect job offers from Remotive API, returns an array of job offer hashes
  def remotive_api_scrape
    remotive_api_url = 'https://remotive.io/api/remote-jobs'
    offers_text = open(remotive_api_url).read
    offers_json = JSON.parse(offers_text)
    offers_json['jobs']
  end

  # feeds information found in Remotive API to Offer Model
  def copy_offer_variables(new_offer, remotive_offer)
    new_offer.external_id = remotive_offer['id'].to_s
    new_offer.company = remotive_offer['company_name']
    new_offer.title = remotive_offer['title']
    new_offer.description = remotive_offer['description']
    new_offer.salary = remotive_offer['salary']
    new_offer.category = remotive_offer['category']
    new_offer.job_type = remotive_offer['job_type']
    new_offer.location = remotive_offer['candidate_required_location']
    new_offer.posting_date = remotive_offer['publication_date']
    new_offer.listing_url = remotive_offer['url']
    new_offer.source = 'remotive'
  end

  # creates tags from API job offers and relates them to the corresponging Offer
  def create_remotive_offers
    remotive_offers = remotive_api_scrape
    remotive_offers.each do |offer|
      new_offer = Offer.where(external_id: offer['id'].to_s, source: 'remotive').first_or_initialize
      copy_offer_variables(new_offer, offer)
      offer['tags'].each do |tag|
        new_offer.tags << Tag.where(name: tag).first_or_create
      end
      new_offer.save!
    end
  end

  def update_remotive_offer_active_status
    remotive_offers = remotive_api_scrape
    db_remotive_offers = Offer.where(source: 'remotive')
    db_remotive_offers.each do |db_offer|
      if remotive_offers.detect { |rm_offer| rm_offer['id'].to_s == db_offer.external_id }.nil?
        db_offer.active = false
      end
      db_offer.save!
    end
  end
end
