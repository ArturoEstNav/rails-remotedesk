require 'open-uri'
require 'nokogiri'
require 'json'


class ScraperIndeed
  attr_reader :indeed_offers

  def initialize
    @indeed_offers = Array.new
  end

  def indeed_offers_scrape
    tags = Tag.all.map { |t| t.name }
    # This list eliminates all search results that might lead to non-programmer jobs
    non_technology_tags = ["security", "okta", "online payments", "infrastructure", "database", "marketing", "QA", "data science",
                            "cybersecurity", "testing", "product analysis", "games", "customer support", "databases", "video", "zendesk",
                            "autonomous driving", "motion control algorithms", "catalyst", "data visualization", "web tech", "B2B", "consul",
                            "adobe suite", "hardware", "education", "gaming", "support", "Secret clearance", "consulting", "Site Reliability",
                            "Support Engineering", "information security", "CISSP", "machine learning",  "AWS", "product development", "management",
                            "B2B/SaaS", "engineering management", "test automation", "Selenium WebDriver", "software development", "leadership",
                            "WebRTC", "SRE", "android", "AWS Inspector", "microservices", "saas", "startup", "fintech", "cloud", "amazon",
                            "development", "software", "business intelligence", "design", "salesforce", "go", "remote", "ecommerce", "apollo",
                            "Engineering", "seo", "web applications", "data", "operations", "open source", "webinars"]

    non_technology_tags.each do |tag|
      tags.delete(tag)
    end

    tags.each do |tag|
      tag.gsub!(/\W/, '+') if tag.match?(/\W/)
    end

    tags.each do |tag|
      pull_offers(tag, @indeed_offers)
    end
  end

  # Pulls all the offers given a keyword
  def pull_offers(keyword, indeed_offers)
    puts "Pulling result cards from the \"#{keyword}\" search"
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
    puts "Pulling information from each card offer per page"
    doc.search('.jobsearch-SerpJobCard').each do |job_card|
      # If offer already exists none will be created
      unless Offer.where(external_id: job_card['data-jk']).present?

        puts "Getting information from offer #{job_card['data-jk']}"
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
          listing_url: "https://www.indeed.com.mx/ver-empleo?jk=#{job_card['data-jk']}",
          candidate_required_location: "Mexico",
          source: 'indeed'
        }
        collect_salary(job_card, new_offer_hash)
        scrape_individual_offer(new_offer_hash, "ver-empleo?jk=#{job_card['data-jk']}")
        # Save each job with complete information into a list of all the offers from indeed

        puts 'create a new offer test'

        new_offer = Offer.where(external_id: new_offer_hash['id'].to_s, source: 'indeed').first_or_initialize
        copy_offer_variables(new_offer, new_offer_hash)
        new_offer.source = 'indeed'
        new_offer_hash[:tags].each do |tag_name|
          new_offer.tags << Tag.find_by(name: tag_name)
        end
        new_offer.save!
      end
    end
  end

  # Get posting details from individual pages
  def scrape_individual_offer(offer_object, url)
    puts "Pulling details from posting #{url}"
    domain = 'https://www.indeed.com.mx/'
    html_content = open(domain + url).read
    doc = Nokogiri::HTML(html_content)
    description = doc.search('.jobsearch-jobDescriptionText')
    offer_object[:description] = description # unrefined but workable
    collect_posting_date(doc, offer_object)
    collect_job_type(description.text.downcase, offer_object)
    collect_tags_indeed(description.text.downcase, offer_object)
    sleep 0.7
  end

  # Gets the tags from each offer description
  def collect_tags_indeed(text_to_scan, offer_object)
    puts "Mining tags from description"
    tags = Tag.all.map(&:name)
    tags.each do |tag|
      offer_object[:tags] << tag if text_to_scan.include?(tag)
    end
  end

  # Gets the job type from each offer description
  def collect_job_type(text_to_scan, offer_object)
    text_to_scan = text_to_scan.gsub('-', ' ')
    puts "Mining tags from description"
    if text_to_scan.include? 'full time'
      offer_object[:job_type] = 'Full-time'
    elsif text_to_scan.include? 'tiempo completo'
      offer_object[:job_type] = 'Full-time'
    elsif text_to_scan.include? 'part time'
      offer_object[:job_type] = 'Part-time'
    elsif text_to_scan.include? 'medio tiempo'
      offer_object[:job_type] = 'Part-time'
    else
      offer_object[:job_type] = ''
    end
  end

  # Gets the posting date from each offer description
  def collect_posting_date(doc, offer_object)
    puts "Mining posting date"
    meta = doc.at('script:contains("localeData")')
    # extract CDATA
    meta = meta.children[0].content
    date = meta.match(/\\nPOT-Creation-Date:([^\\]+)/)[1]
    date[0] = ''
    offer_object[:posting_date] = date.to_datetime
  end

  # Gets the salary from each offer
  def collect_salary(text_to_scan, offer_object)
    puts "Mining salary from each card"
    raw_salary = text_to_scan.search('.salaryText').text
    if raw_salary.empty?
      offer_object[:salary] = ''
    else
      offer_object[:salary] = raw_salary
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
