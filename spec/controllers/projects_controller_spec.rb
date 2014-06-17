require 'spec_helper'

describe ProjectsController do

  logged_in_user

  describe "GET #index" do
    it "populates an array of projects" do
      project = create(:project)
      get :index
      assigns(:projects).should eq [project]
    end

    it "renders the :index template" do
      get :index
      response.should render_template :index
    end
  end

  describe "GET #new" do
    it "assigns a new Project to @project" do
      get :new
      assigns(:project).should be_a_new(Project)
    end

    it "renders the :new template" do
      get :new
      response.should render_template :new
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves the new project in the database" do
        expect do
          post :create, project: attributes_for(:project)
        end.to change(Project, :count).by(1)
      end

      it "redirects to projects page" do
        post :create, project: attributes_for(:project)
        response.should redirect_to projects_url
      end
    end

    context "with invalid attributes" do
      context "with no name" do
        it "does not save the new project in the database" do
          expect do
            post :create, project: attributes_for(:project_without_name)
          end.to_not change(Project, :count)
        end

        it "re-renders the :new template" do
          post :create, project: attributes_for(:project_without_name)
          response.should render_template :new
        end
      end
    end
  end

  describe "GET #edit" do
    it "assigns the requested project to @project" do
      project = create(:project)
      get :edit, id: project
      assigns(:project).should eq project
    end

    it "renders the :edit template" do
      project = create(:project)
      get :edit, id: project.id
      response.should render_template :edit
    end
  end

  describe "PUT #update" do
    before :each do
      @project_name = "Testing PUT #update"
      @project = create(:project, name: @project_name)
    end

    it "locates the requested project" do
      put :update, id: @project, project: attributes_for(:project)
      assigns(:project).should eq @project
    end

    context "with valid attributes" do
      it "changes @project attributes" do
        new_name = "It works!"
        put :update, id: @project, project: attributes_for(:project,
          name: new_name)
        @project.reload
        @project.name.should eq(new_name)
      end

      it "redirects to projects#index" do
        put :update, id: @project, project: attributes_for(:project)
        response.should redirect_to projects_url
      end
    end

    context "with invalid attributes" do
      it "does not change @project attributes" do
        put :update, id: @project, project: attributes_for(:project,
          name: nil)
        @project.reload
        @project.name.should eq(@project_name)
      end

      it "re-renders the edit template" do
        put :update, id: @project, project: attributes_for(:project,
          name: nil)
        response.should render_template :edit
      end
    end
  end

  describe "DELETE #destroy" do
    before :each do
      @project = create(:project)
    end

    it "deletes the message" do
      expect do
        delete :destroy, id: @project
      end.to change(Project, :count).by(-1)
    end

    it "redirects to projects#index" do
      delete :destroy, id: @project
      response.should redirect_to projects_url
    end
  end
end
