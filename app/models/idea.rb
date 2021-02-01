class Idea < ApplicationRecord

    validates :title, presence: true, uniqueness: true
    validates :description, presence: true

    has_many :reviews, dependent: :destroy
    belongs_to :user, optional: true



    # many to many association
    has_many :likes, dependent: :destroy
    has_many :likers, through: :likes  , source: :user

    has_many :joins, dependent: :destroy
    has_many :joiners, through: :joins  , source: :user


    def self.all_with_review_counts
        self.left_outer_joins(:reviews)
            .select("ideas.*","Count(reviews.*) AS reviews_count")
            .group('ideas.id')
    end

end
