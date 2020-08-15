require 'open-uri'
require 'nokogiri'
require 'json'


def indeed_offers_scrape
  # tags = Tag.all
  # Tis list eliminates all search results that might lead to non-programmer jobs
  # non_technology_tags = ['leadership', 'remote']
  # non_technology_tags.each do |tag|
  #   tags.delete(tag)
  # end
  # tags.each do |tag|
  #   tag.gsub!(/\W/, ' ') if tag.include?(/\W/)
  # end
  # Scrape all relevant tags in Indeed
  indeed_offers = Array.new
  pull_offers("ruby", indeed_offers)

  # tags.each do |tag|
  #   pull_offers(tag, indeed_offers)
  # end

  indeed_offers
end

# Pulls all the offers given a keyword
def pull_offers(keyword, indeed_offers)
  domain = 'https://www.indeed.com.mx/'
  url = "trabajo?q=#{keyword}&remotejob=032b3046-06a3-4876-8dfd-474eb5e7ed11"
  html_content = open(domain + url).read
  doc = Nokogiri::HTML(html_content)
  # This var verifies if there are multiple pages of results
  next_page_button = doc.search('path')
  next_page_button = next_page_button.search('*[d="M10 6L8.59 7.41 13.17 12l-4.58 4.59L10 18l6-6-6-6z"]').text
  if next_page_button.presence?
    # If there are multiple pages it will iterate though all of the result pages
    gather_offers_per_page(doc, indeed_offers)
    current_page = 1
    while next_page_button.presence? == true
      next_page = "&start=#{current_page}0"
      html_content = open(domain + url + next_page).read
      doc = Nokogiri::HTML(html_content)
      # This var verifies if there are multiple pages of results
      gather_offers_per_page(doc, indeed_offers)
      counter += 1
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
  doc.search('.jobsearch-SerpJobCard').each do |job_card|
    new_offer_hash = {
      external_id: job_card['data-jk'],
      company: job_card.search('.company').text,
      title: job_card.search('h2').text,
      salary: "", # unrefined text, not suited for ranges yet
      category: "Software Development",
      job_type: "",
      tags: [],
      location: job_card.search('.location').text,
      listing_url: job_card.search('a').attribute('href')[0] = '',
      candidate_required_location: "Mexico",
      source: 'indeed'
    }
    collect_salary(job_card, new_offer_hash)
    scrape_individual_offer(new_offer_hash, new_offer_hash[:listing_url])
    # Save each job with complete information into a list of all the offers from indeed
    indeed_offers << new_offer_hash
  end
end

# Get posting details from individual pages
def scrape_individual_offer(offer_object, url)
  domain = 'https://www.indeed.com.mx/'
  html_content = open(domain + url).read
  doc = Nokogiri::HTML(html_content)
  description = doc.search('.jobsearch-jobDescriptionText p')
  offer_object[:description] = description # unrefined but workable
  collect_posting_date(doc, offer_object)
  collect_job_type(description.text, offer_object)
  collect_tags_indeed(description.text, offer_object)
  sleep 0.5
end

# Gets the tags from each offer description
def collect_tags_indeed(text_to_scan, offer_object)
  tags = Tag.all.map(&:name)
  tags.each do |tag|
    offer_object[:tags] << tag if text_to_scan.include?(tag)
  end
end

# Gets the job type from each offer description
def collect_job_type(text_to_scan, offer_object)
  if text_to_scan.include?('full time' || 'tiempo completo')
    offer_object[:job_type] = 'full-time'
  elsif text_to_scan.include?('part time' || 'medio tiempo')
    offer_object[:job_type] = 'part-time'
  else
    offer_object[:job_type] = ''
  end
end

# Gets the posting date from each offer description
def collect_posting_date(doc, offer_object)
  head = doc.search("head")
  js = head.at('script[type="application/ld+json"]').text
  # TODO captured data is returning nil -> not capturing the right script file
  meta = JSON[js]['datePosted']
  offer_object[:posting_date] = meta.to_datetime
end

# Gets the salary from each offer
def collect_salary(text_to_scan, offer_object)
  raw_salary = text_to_scan.search('.salaryText').text
  # salary = raw_salary.match(/(\d+)/).captures[0].to_i
  if raw_salary.empty?
    offer_object[:salary] = raw_salary
  else
    offer_object[:salary] = ''
  end
end

def create_indeed_offers
  indeed_offers = indeed_offers_scrape
  indeed_offers.each do |offer|
    new_offer = Offer.where(external_id: offer['id'].to_s, source: 'indeed').first_or_initialize
    copy_offer_variables(new_offer, offer)
    new_offer.source = 'indeed'
    new_offer.tags = offer.tags
    new_offer.save!
  end
end

def update_indeed_offer_active_status
  indeed_offers = indeed_offers_scrape
  db_indeed_offers = Offer.where(source: 'indeed')
  db_indeed_offers.each do |db_offer|
    if indeed_offers.detect { |rm_offer| rm_offer['id'].to_s == db_offer.external_id }.nil?
      db_offer.active = false
    end
    db_offer.save!
  end
end

indeed_offers_scrape

p indeed_offers
