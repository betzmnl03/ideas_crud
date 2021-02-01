class IdeasController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]
    before_action :find_idea, only:[:show, :edit, :update, :destroy]


    def new
        @idea = Idea.new
    end

    def create
        @idea = Idea.new idea_params
        @idea.user = current_user
        if @idea.save
            flash[:notice]="Idea created successfully."
            redirect_to idea_path(@idea.id)
        else
            render :new
        end
    end

    def index
        @ideas = Idea.all.order(created_at: :desc)
    end

    def edit
        if can?(:edit, @idea)
            render :edit
        else
            redirect_to idea_path(@idea)
        end
    end

    def show

    end

    def update
        if @idea.update idea_params
            redirect_to idea_path(@idea.id), notice: "Idea edited"
        else
            render :edit
        end
    end

    def destroy
        if can?(:delete, @idea)
            @idea.destroy
            flash[:alert] = "The  idea has been destroyed"
            redirect_to ideas_path
        else
            flash[:alert]="Access Denied" 
            redirect_to idea_path(@idea.id)
        end
    end



    private
    def idea_params
        params.require(:idea).permit(:title, :description)
    end

    def find_idea
        @idea = Idea.find_by_id params[:id]
    end


    def authorize_user!
        redirect_to root_path, alert: 'Not Authorized' unless can?(:crud, @idea)
    end
end
