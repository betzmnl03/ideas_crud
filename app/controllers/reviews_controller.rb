class ReviewsController < ApplicationController


    before_action :find_idea
    before_action :authenticate_user!

    def create
        @review =Review.new review_params
        @review.idea=@idea
        @review.user = current_user
        if @review.save
            redirect_to idea_path(@idea), notice: "Review created"   
        else
            @reviews = @idea.reviews.order(created_at: :DESC)
            render "/ideas/show" 
        end      
    end

    def destroy
        @review = Review.find params[:id]
        if (can? :crud, @review) || (can? :crud, @idea)
            @review.destroy
            redirect_to idea_path(@idea), notice: "Review deleted"  
        else
            redirect_to idea_path(@idea), alert: "Not authorized to delete review"
        end
    end


    private
    def find_idea
        @idea = @idea = Idea.find_by_id params[:idea_id]
    end

    def review_params
        params.require(:review).permit(:body)
    end
end
