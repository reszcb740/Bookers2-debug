class Book < ApplicationRecord

  has_one_attached :profile_image
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }
  validates :user_id, presence: true

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
end
