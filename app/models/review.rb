class Review < ApplicationRecord
  belongs_to :idea
  belongs_to :user, optional: true
  validates :body, presence: true
end
