class Tag < ApplicationRecord
  has_many :offer_tags, dependent: :destroy
  has_many :offers, through: :offer_tags
  has_many :user_tags, dependent: :destroy
  has_many :users, through: :user_tags

  validates :name, presence: true
end
