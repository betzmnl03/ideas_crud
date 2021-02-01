class Idea < ApplicationRecord

    validates :title, presence: true, uniqueness: true
    validates :description, presence: true

    has_many :reviews, dependent: :destroy
    belongs_to :user, optional: true



    # many to many association
    has_many :likes
    has_many :likers, through: :likes  , source: :user


    def self.all_with_review_counts
        self.left_outer_joins(:reviews)
            .select("ideas.*","Count(reviews.*) AS reviews_count")
            .group('ideas.id')
    end

end
