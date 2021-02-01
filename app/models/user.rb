class User < ApplicationRecord


    has_many :ideas, dependent: :nullify

    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :email, presence: true, uniqueness: true
    validates :password, presence: true

    has_secure_password
    def full_name
        "#{first_name} #{last_name}"
    end
end
