class User < ApplicationRecord


    has_many :ideas, dependent: :nullify
    has_many :reviews, dependent: :nullify


    # many to many association
    has_many :likes
    has_many :liked_ideas, through: :likes, source: :idea

    has_many :joins
    has_many :joined_ideas, through: :joins, source: :idea

    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :email, presence: true, uniqueness: true
    validates :password, presence: true

    has_secure_password
    def full_name
        "#{first_name} #{last_name}"
    end
end
