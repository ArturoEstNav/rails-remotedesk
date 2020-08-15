require 'open-uri'
require 'nokogiri'
require 'json'
require 'pry-byebug'

class ScraperIndeed
  attr_reader :indeed_offers

  def initialize
    @indeed_offers = Array.new
  end

  def indeed_offers_scrape
    tags = Tag.all
    # This list eliminates all search results that might lead to non-programmer jobs
    non_technology_tags = ['leadership', 'remote', 'mexico', 'USA']
    non_technology_tags.each do |tag|
      tags.delete(tag)
    end
    tags.each do |tag|
      tag.name.gsub!(/\W/, '+') if tag.name.match?(/\W/)
    end
    # Scrape all relevant tags in Indeed

    tags.each do |tag|
      pull_offers(tag.name, indeed_offers)
    end
  end

  # Pulls all the offers given a keyword
  def pull_offers(keyword, indeed_offers)
    puts "pulling offers from site"
    domain = 'https://www.indeed.com.mx/'
    url = "trabajo?q=#{keyword}&remotejob=032b3046-06a3-4876-8dfd-474eb5e7ed11"
    html_content = open(domain + url).read
    doc = Nokogiri::HTML(html_content)
    # This var verifies if there are multiple pages of results
    next_page_button = doc.search('path')
    next_page_button = next_page_button.search('*[d="M10 6L8.59 7.41 13.17 12l-4.58 4.59L10 18l6-6-6-6z"]').text
    unless next_page_button.empty?
      # If there are multiple pages it will iterate though all of the result pages
      gather_offers_per_page(doc, indeed_offers)
      current_page = 1
      while next_page_button.empty? == true
        next_page = "&start=#{current_page}0"
        html_content = open(domain + url + next_page).read
        doc = Nokogiri::HTML(html_content)
        # This var verifies if there are multiple pages of results
        gather_offers_per_page(doc, indeed_offers)
        current_page += 1
        next_page_button = doc.search('path')
        next_page_button = next_page_button.search('*[d="M10 6L8.59 7.41 13.17 12l-4.58 4.59L10 18l6-6-6-6z"]')
      end
    else
      gather_offers_per_page(doc, indeed_offers)
    end
  end

  # Retrieves an array of the offer results per page
  def gather_offers_per_page(doc, indeed_offers)
    # Gathers all the cards on the page and collects info from each owne of them
    puts "pulling offers per page"
    doc.search('.jobsearch-SerpJobCard').each do |job_card|
      new_offer_hash = {
        external_id: job_card['data-jk'],
        company: job_card.search('.company').text,
        title: job_card.search('h2').text,
        salary: "", # unrefined text, not suited for ranges yet
        category: "Software Development",
        position: '',
        job_type: "",
        tags: [],
        location: job_card.search('.location').text,
        listing_url: "ver-empleo?jk=#{job_card['data-jk']}",
        candidate_required_location: "Mexico",
        source: 'indeed'
      }
      collect_salary(job_card, new_offer_hash)
      scrape_individual_offer(new_offer_hash, new_offer_hash[:listing_url])
      # Save each job with complete information into a list of all the offers from indeed
      @indeed_offers << new_offer_hash
      puts "new offer #{job_card.search('h2').text} added to indeed offers"
    end
  end

  # Get posting details from individual pages
  def scrape_individual_offer(offer_object, url)
    puts "pulling details from posting"
    domain = 'https://www.indeed.com.mx/'
    html_content = open(domain + url).read
    doc = Nokogiri::HTML(html_content)
    description = doc.search('.jobsearch-jobDescriptionText')
    offer_object[:description] = description # unrefined but workable
    collect_posting_date(doc, offer_object)
    collect_job_type(description.text.downcase, offer_object)
    collect_tags_indeed(description.text.downcase, offer_object)
    sleep 0.5
  end

  # Gets the tags from each offer description
  def collect_tags_indeed(text_to_scan, offer_object)
    puts " Mining tags from description "
    tags = Tag.all.map(&:name)
    tags.each do |tag|
      offer_object[:tags] << tag if text_to_scan.include?(tag)
    end
  end

  # Gets the job type from each offer description
  def collect_job_type(text_to_scan, offer_object)
    puts "Mining tags from description "

    if text_to_scan.include?('full time' || 'full-time' || 'tiempo completo')
      offer_object[:job_type] = 'full-time'
    elsif text_to_scan.include?(' time' || 'part-time' || 'medio tiempo')
      offer_object[:job_type] = 'part-time'
    else
      offer_object[:job_type] = ''
    end
  end

  # Gets the posting date from each offer description
  def collect_posting_date(doc, offer_object)
    puts "Mining posting date"
    head = doc.search("head")
    js = head.at('script[type="application/ld+json"]').text
    # TODO captured data is returning nil -> not capturing the right script file
    meta = JSON[js]['datePosted']
    offer_object[:posting_date] = meta.to_datetime
  end

  # Gets the salary from each offer
  def collect_salary(text_to_scan, offer_object)
    puts "Mining salary from each card"
    raw_salary = text_to_scan.search('.salaryText').text
    # salary = raw_salary.match(/(\d+)/).captures[0].to_i
    if raw_salary.empty?
      offer_object[:salary] = raw_salary
    else
      offer_object[:salary] = ''
    end
  end

  def create_indeed_offers
    indeed_offers = @indeed_offers
    indeed_offers.each do |offer|
      new_offer = Offer.where(external_id: offer['id'].to_s, source: 'indeed').first_or_initialize
      copy_offer_variables(new_offer, offer)
      new_offer.source = 'indeed'
      # binding.pry
      offer[:tags].each do |tag_name|
        new_offer.tags << Tag.find_by(name: tag_name)
      end
      new_offer.save!
    end
  end

  def copy_offer_variables(new_offer, external_offer)
    new_offer.external_id = external_offer[:external_id].to_s
    new_offer.company = external_offer[:company]
    new_offer.title = external_offer[:title]
    new_offer.description = external_offer[:description]
    new_offer.salary = external_offer[:salary]
    new_offer.category = external_offer[:category]
    new_offer.job_type = external_offer[:job_type]
    new_offer.location = external_offer[:location]
    new_offer.posting_date = external_offer[:posting_date]
    new_offer.listing_url = external_offer[:listing_url]
  end

  def update_indeed_offer_active_status
    indeed_offers = @indeed_offers
    db_indeed_offers = Offer.where(source: 'indeed')
    db_indeed_offers.each do |db_offer|
      if indeed_offers.detect { |rm_offer| rm_offer['id'].to_s == db_offer.external_id }.nil?
        db_offer.active = false
      end
      db_offer.save!
    end
  end
end