class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

          has_one_attached :profile_image
          has_many :books, dependent: :destroy
          has_many :favorites, dependent: :destroy
          has_many :book_comments, dependent: :destroy
          has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
          has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

          has_many :followings, through: :relationships, source: :followed
          has_many :followers, through: :passive_relationships, source: :follower

          validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
          validates :introduction, length: { maximum: 50 }


         def get_profile_image(width, height)
            unless profile_image.attached?
              file_path = Rails.root.join('app/assets/images/sample-author1.jpg')
              profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
            end
            profile_image.variant(resize_to_limit: [width, height]).processed
         end

         def follow(user_id)
             unless self == user_id
              self.relationships.find_or_create_by(followed_id: user_id.to_i, follower_id: self.id)
             end
         end

         def unfollow(user_id)
           relationships.find_by(followed_id: user_id).destroy
         end

         def following?(user)
           followings.include?(user)
         end

          def self.looks(search, word)
            if search == "perfect_match"
             User.where(name: word)
            elsif search == "forward_match"
              User.where("name LIKE ?", "#{word}%")
            elsif search == "backward_match"
              User.where("name LIKE ?", "%#{word}")
            elsif search == "partial_match"
             User.where("name LIKE ?", "%#{word}%")
            else
              User.all
            end
          end
end