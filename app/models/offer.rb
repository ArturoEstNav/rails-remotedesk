class Offer < ApplicationRecord
  has_many :matches
  has_many :users, through: :matches
  has_many :offer_tags
  has_many :tags, through: :offer_tags

  validates :title, :company, :description, :job_type, :posting_date, :listing_url, presence: true
end
