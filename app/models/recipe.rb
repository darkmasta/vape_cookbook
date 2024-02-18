class Recipe < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes
  has_many :likers, through: :likes, source: :user

  after_initialize :set_defaults

  private

  def set_defaults
    self.likes ||= 0
    self.views ||= 0
  end
end
