class IdeasController < ApplicationController

    before_action :find_idea, only:[:show, :edit, :update, :destroy]

    def new
        @idea = Idea.new
    end

    def create
        @idea = Idea.new idea_params
        if @idea.save
            redirect_to root_path
        else
            render :new
        end
    end

    def index
        @ideas = Idea.all.order(created_at: :desc) 
    end

    def edit

    end

    def show
        redirect_to idea_path(@idea.id)
    end

    def update
        if @idea.update idea_params
            redirect_to idea_path(@idea.id), notice: "Idea edited"
        else
            render :edit
        end
    end

    def destroy
        if @idea.destroy
            flash[:notice] = "The  idea has been destroyed"
            redirect_to ideas_path
        else
            render :show
        end
    end



    private
    def idea_params
        params.require(:idea).permit(:title, :description)
    end

    def find_idea
        @idea = Idea.find_by_id params[:id]
    end
end
