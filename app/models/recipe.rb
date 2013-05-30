class Recipe < ActiveRecord::Base
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  validates :user_id, presence: true

  acts_as_taggable


  scope :view_count, -> { Recipe.order("views DESC") }
  scope :like_count, -> { Recipe.order("likes DESC") }
end
