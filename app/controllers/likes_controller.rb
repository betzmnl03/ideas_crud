class LikesController < ApplicationController

    def create
        idea= Idea.find params[:idea_id] 
        like= Like.new idea: idea, user: current_user
        if !can?(:like, idea)
            flash[:alert]='You can not like your own idea'
        elsif like.save
            flash[:notice]='Idea liked'
        else
            flash[:alert]=like.errors.full_messages.join(', ')
        end
        redirect_to root_path
    end
    def destroy
        like = current_user.likes.find params[:id]
        if !can?(:destroy, like)
            flash[:alert]= 'You can\'t destroy a liek you don\'t own'
        elsif like.destroy
            flash[:notice]='Idea unliked' 
        else
            flash[:alert]='Couldn\'t unlike the idea'
        end
        redirect_to root_path
    end

    def show
        idea =Idea.find params[:id] 
        @likes = idea.likers.order("likes.created_at DESC")  
    end
end
