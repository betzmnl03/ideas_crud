class JoinsController < ApplicationController
    def create
        idea= Idea.find params[:idea_id] 
        join= Join.new idea: idea, user: current_user
        if !can?(:join, idea)
            flash[:alert]='You can not join your own idea'
        elsif join.save
            flash[:notice]='Joined Idea'
        else
            flash[:alert]=join.errors.full_messages.join(', ')
        end
        redirect_to root_path
    end
    def destroy
        join = current_user.joins.find params[:id]
        if !can?(:destroy, join)
            flash[:alert]= 'You can\'t destroy a join you don\'t own'
        elsif join.destroy
            flash[:notice]='Left Idea' 
        else
            flash[:alert]='Couldn\'t leave the idea'
        end
        redirect_to root_path
    end
end
