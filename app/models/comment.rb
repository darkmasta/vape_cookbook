class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :content, presence: { message: 'Content cannot be empty' }

  # Custom callback to update counter_cache on the commentable object
  after_create :increment_commentable_counter
  after_destroy :decrement_commentable_counter

  private

  def increment_commentable_counter
    commentable_type.constantize.find(commentable_id).increment!(:comments_count)
  end

  def decrement_commentable_counter
    commentable_type.constantize.find(commentable_id).decrement!(:comments_count)
  end
end
