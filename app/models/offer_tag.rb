class OfferTag < ApplicationRecord
  belongs_to :offer
  belongs_to :tag
end
