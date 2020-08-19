# Users
puts 'Cleaning database'
Tag.destroy_all
OfferTag.destroy_all
Match.destroy_all
Offer.destroy_all
User.destroy_all
puts 'Create new users'
5.times do
  new_user = User.new(
    email: Faker::Internet.email,
    password: '123456'
  )
  new_user.first_name = Faker::Name.first_name
  new_user.last_name = Faker::Name.last_name
  new_user.gender = Faker::Gender.type
  new_user.residence_country = Faker::Address.country
  new_user.postal_code = Faker::Address.zip_code
  new_user.save
  puts "Created user #{new_user.id}"
end

puts 'Create new offers'
20.times do
  new_offer = Offer.new()
  new_offer.title = Faker::Job.title
  new_offer.company = Faker::Company.name
  new_offer.description = (Faker::Job.field + ' ' +
  Faker::Job.seniority + ' ' +
  Faker::Job.position + ' ' +
  Faker::Job.key_skill)
  new_offer.job_type = Faker::Job.employment_type
  new_offer.posting_date = Faker::Time.between(from: DateTime.now - 90, to: DateTime.now)
  new_offer.listing_url = Faker::Internet.url
  new_offer.source = ['remotive','indeed','linkedin'].sample
  new_offer.save

  puts "Created offer #{new_offer.id}"
end

puts 'Create API offers'

new_api_offer = ApiOffer.new
new_api_offer.create_remotive_offers

# puts 'Create offers scraped from Indeed'

# indeed_offers = ScraperIndeed.new
# indeed_offers.create_indeed_offers

puts 'Create new matches'
User.all.each do |user|
  5.times do
    match = Match.new
    match.user = user
    match.offer = Offer.all.sample
    match.save
    puts "Created match #{match.offer.title} for #{match.user.first_name}"
  end
end

puts 'Create new tags'
tags = [
  'ruby',
  'ruby-on-rails',
  'vue',
  'react',
  'mongodb',
  'python',
  'javascript',
  'java',
  'c++',
  'mexico',
  'USA',
  'full-time',
  'contractor',
  'part-time',
  'UK'
]

tags.each do |tag|
  new_tag = Tag.new(name: tag)
  new_tag.save
  puts "Created tag #{tag}"
end

puts 'Create new offer tags'
Offer.all.each do |offer|
  offer.tags << Tag.all.sample(3)
end
