require 'rails_helper'

RSpec.describe IdeasController, type: :controller do
    describe '#new' do # 👈🏻 describe 'new' starts here 
        context "with signed in user" do
            before do
                session[:user_id]=FactoryBot.create(:user)
            end

            
            it 'render the new template' do
                get(:new)

                expect(response).to(render_template(:new))
            end
            it 'sets an instance variable with new idea' do
   
                get(:new)
               
                expect(assigns(:idea)).to(be_a_new(Idea))
    
            end 
        end
    end# 👈🏻 describe 'new' ends  here 
    describe '#create' do# 👈🏻 describe 'create' starts here 
        def valid_request
            post(:create, params:{idea: FactoryBot.attributes_for(:idea)})
        end
        context 'with user signed in' do
            before do
                session[:user_id]=FactoryBot.create(:user)
            end
            context " with valid parameter " do # 👈🏻 Context Valid Parameters - Start
                it 'creates an idea in the database' do
             
                    count_before = Idea.count
              
                    valid_request

                    count_after=Idea.count
                    expect(count_after).to(eq(count_before + 1))
                end
                it 'redirects us to a show page of that idea' do
                    # Given
                    # When
                    valid_request
                    
                    # Then 
                    idea=Idea.last
                    expect(response).to(redirect_to(idea_url(idea.id)))
                end
            end# 👈🏻 Context Valid Parameters - End
            context 'with invalid parameters' do
                def invalid_request
                    post(:create, params:{idea: FactoryBot.attributes_for(:idea, title: nil)})
                end
                it 'doesnot save a record in the database'do
                    count_before = Idea.count
                    invalid_request
                    count_after = Idea.count
                    expect(count_after).to(eq(count_before))
                end
                it 'renders the new template' do
                    # Given
                    # when
                    invalid_request
                    #then
                    expect(response).to render_template(:new)
                end
            end
        end# 👈🏻 context 'with user signed in' ends here
        context 'with user not signed in'do
            it 'should redirect to sign in page' do
                #given
                # User is not signed 
                #when
                valid_request
                #then
                expect(response).to redirect_to(new_session_path)
            end
        end
    end# 👈🏻 describe 'create' ends here 
    describe '#show' do# 👈🏻 describe 'show' start here 
        it 'render show template' do
            # Given
            idea=FactoryBot.create(:idea)
            # When
            get(:show, params:{id: idea.id})
            # Then
            expect(response).to render_template(:show)
        end
        it 'set an instance variable @idea for the shown object' do
            # Given
            idea=FactoryBot.create(:idea)
            # When
            get(:show, params:{id: idea.id})
            # Then
            expect(assigns(:idea)).to(eq(idea))
            
        end
    end# 👈🏻 describe 'show' ends here 
    describe '#index' do # 👈🏻 describe 'index' starts here 
        it 'render the index template' do
            #given
            #when
            get(:index)
            #then
            expect(response).to render_template(:index)
        end
        it 'assign an instance variable @idea which contains all created job posts' do
            # Given
            idea_1=FactoryBot.create(:idea)
            idea_2=FactoryBot.create(:idea)
            idea_3=FactoryBot.create(:idea)
            # When
            get(:index)
            # Then
            expect(assigns(:ideas)).to eq([idea_3, idea_2, idea_1])
        end
    end# 👈🏻 describe 'index' ends here 
    describe "# edit" do# 👈🏻 describe 'edit' starts here 
        context "with signed in user" do
            context " as owner" do
                before do
                    # session[:user_id]=FactoryBot.create(:user)
                    current_user=FactoryBot.create(:user)
                    session[:user_id]= current_user.id
                    @idea=FactoryBot.create(:idea, user: current_user)
                end
                it "render the edit template" do
                    # Given
                    
                    #When
                    get(:edit, params:{id: @idea.id})
                    # then
                    expect(response).to render_template :edit
                end
            end
            context 'as non owner' do
                before do
                    current_user=FactoryBot.create(:user)
                    session[:user_id]=current_user.id
                    @idea=FactoryBot.create(:idea)
                end
                it 'should redirect to the show page' do
                    get(:edit, params:{id:@idea.id})
                    expect(response).to redirect_to idea_path(@idea)
                end
            end
        end
    end# 👈🏻 describe 'edit' ends here 
    describe '#update' do# 👈🏻 describe 'update' starts here 
        before do
            #given
            @idea= FactoryBot.create(:idea)
        end
        context "with signed in user"do
            before do
                session[:user_id]=FactoryBot.create(:user)
            end
            context "with valid parameters" do
                it "update the job post record with new attributes" do

                    #when
                    new_title = "#{@idea.title} plus some changes!!!"
                    patch(:update, params:{id: @idea.id, idea:{title: new_title}})
                    #then
                    expect(@idea.reload.title).to(eq(new_title))
                end
                it 'redirect to the show page' do
                    new_title = "#{@idea.title} plus some changes!!!"
                    patch(:update, params:{id: @idea.id, idea:{title: new_title}})
                    expect(response).to redirect_to(@idea)

                end
            end
            context 'with invalid parameters' do 
                it 'should not update the idea record' do
                    patch(:update, params:{id: @idea.id, idea: {title: nil}})
                    idea_after_update = Idea.find(@idea.id)
                    expect(idea_after_update.title).to(eq(@idea.title))
                end
            end
        end 
    end# 👈🏻 describe 'update' ends here 
    describe '#destroy' do
        context "with signed in user" do
            context 'as owner' do
                before do

                    current_user=FactoryBot.create(:user)
                    session[:user_id]=current_user.id
                    @idea=FactoryBot.create(:idea, user: current_user)
                    #when
                    delete(:destroy, params:{id: @idea.id})
                end
                it 'remove idea from the db' do
                    #then 
                    expect(Idea.find_by(id: @idea.id)).to(be(nil))
                end
                it 'redirect to the idea index' do
                    expect(response).to redirect_to(ideas_path)
                end
                it 'set a flash message' do
                    expect(flash[:alert]).to be
                end 
            end
            context "as non owner" do
                before do
                    current_user = FactoryBot.create(:user)
                    session[:user_id]=current_user.id
                    @idea=FactoryBot.create(:idea)
                end
                it 'does not remove the idea' do
                    delete(:destroy,params:{id: @idea.id})
                    expect(Idea.find(@idea.id)).to eq(@idea)
                end
            end
        end
    end
end
