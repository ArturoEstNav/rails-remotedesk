class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :matches, dependent: :destroy
  has_many :offers, through: :matches
  has_many :user_tags
  has_many :tags, through: :user_tags
  has_one_attached :photo

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
