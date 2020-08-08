class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :matches
  has_many :offers, through: :matches
  # validates :first_name, :last_name, :gender, :residence_country, :postal_code, presence: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
