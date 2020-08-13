require 'open-uri'
require 'nokogiri'
# Tags from search bars go on the var below ()
# Use var below to either pull the job list or individual postings
search_keywords = ""
domain = 'https://www.indeed.com.mx/'
url = "trabajo?q=#{search_keywords}&remotejob=032b3046-06a3-4876-8dfd-474eb5e7ed11"

#pulls all the offers from the website
#keywords will potentially be an array
def pull_offers(keywords)

  search_keywords = keywords
  html_content = open(domain + url).read
          doc = Nokogiri::HTML(html_content)

          doc.search('.model').each_with_index do |element, index|

# verify if there are more results
  end
end

# verifies against our database
def create_update()




end

# verifies if an offer is active
def active?()

end
#
#
#
#


# private
#
# add method here if

