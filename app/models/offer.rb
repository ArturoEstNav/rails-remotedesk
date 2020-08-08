class Offer < ApplicationRecord
  has_many :matches
  has_many :users, through: :matches

  validates :title, :company, :description, :job_type, :posting_date, :listing_url, presence: true
end
