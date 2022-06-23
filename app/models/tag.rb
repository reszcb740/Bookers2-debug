class Tag < ApplicationRecord
  has_many :book_tags, dependent: :destroy
  has_many :books, through: :book_tags, dependent: :destroy
  scope :search_by_name, -> (search){where(['nameLIKE?', "%#{search}%"])}
end
