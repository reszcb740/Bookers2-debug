class Book < ApplicationRecord

  has_one_attached :profile_image
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :book_tags, dependent: :destroy
  has_many :tags, through: :book_tags, dependent: :destroy
  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }
  validates :user_id, presence: true
  validates :star, numericality: {
    less_than_or_equal_to: 5,
    greater_than_or_equal_to: 1
  }, presence: true
  scope :search_by_name, ->(search){where(['name LIKE?', "#%{search}%"])}
  scope :latest, -> {order(create_at: :desc)}
  scope :star_count, -> {order(star: :desc)}
  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/sample-author1.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
      profile_image.variant(resize_to_limit: [width, height]).processed
  end

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def self.looks(search, word)
    if search == "perfect_match"
      Book.where(title: word)
    elsif search == "forward_match"
     Book.where("title LIKE?", "#{word}%")
    elsif search == "backward_match"
     Book.where("title LIKE?", "%#{word}")
    elsif search == "pertial_match"
      Book.where("title LIKE?", "%#{word}%")
    else
     Book.all
    end
  end

  def save_tags(sent_tags)
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    old_tags = current_tags - sent_tags
    new_tags = sent_tags - current_tags

    old_tags.each do |old|
      self.book_tags.delete BookTag.find_by(name: old)
    end
    new_tags.each do |new|
      new_book_tag = BookTag.find_or_create_by(name: new)
      self.book_tags << new_book_tag
    end
  end

end
