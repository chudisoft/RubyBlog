class Post < ApplicationRecord
  before_validation :set_default_comments_counter, on: :create
  validates :title, presence: true, length: { maximum: 250 }
  validates :comments_counter, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :likes_counter, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  has_many :comments
  has_many :likes

  after_create :increment_user_posts_counter
  after_destroy :decrement_user_posts_counter

  def recent_comments
    comments.order(created_at: :desc).limit(5)
  end

  private

  def decrement_user_posts_counter
    author.decrement!(:posts_counter)
  end

  def increment_user_posts_counter
    author.increment!(:posts_counter)
  end

  def set_default_comments_counter
    self.comments_counter ||= 0
    self.likes_counter ||= 0
  end
end
