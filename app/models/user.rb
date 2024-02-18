class User < ApplicationRecord
  has_secure_password

  has_many :recipes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes
  has_many :liked_recipes, through: :likes, source: :recipe
end
