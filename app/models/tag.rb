class Tag < ApplicationRecord
  has_many :offer_tags, dependent: :destroy
  has_many :offers, through: :offer_tags
  validates :name, presence: true
end
