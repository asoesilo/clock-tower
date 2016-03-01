require 'spec_helper'

describe Admin::ProjectsController do

  logged_in_user_admin

  describe "GET #index" do
    it "populates an array of projects" do
      project = build(:project)
      expect(Project).to receive(:all).and_return([project])
      get :index
      expect(assigns(:projects)).to eq [project]
    end

    it "renders the :index template" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "GET #new" do
    it "assigns a new Project to @project" do
      get :new
      expect(assigns(:project)).to be_a_new(Project)
    end

    it "renders the :new template" do
      get :new
      expect(response).to render_template :new
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
        expect(response).to redirect_to(admin_projects_url)
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
          expect(response).to render_template :new
        end
      end
    end
  end

  describe "GET #edit" do
    it "assigns the requested project to @project" do
      project = create(:project)
      get :edit, id: project
      expect(assigns(:project)).to eq project
    end

    it "renders the :edit template" do
      project = create(:project)
      get :edit, id: project.id
      expect(response).to render_template :edit
    end
  end

  describe "PUT #update" do
    before :each do
      @project_name = "Testing PUT #update"
      @project = create(:project, name: @project_name)
    end

    it "locates the requested project" do
      put :update, id: @project, project: attributes_for(:project)
      expect(assigns(:project)).to eq @project
    end

    context "with valid attributes" do
      it "changes @project attributes" do
        new_name = "It works!"
        put :update, id: @project, project: attributes_for(:project,
          name: new_name)
        @project.reload
        expect(@project.name).to eq(new_name)
      end

      it "redirects to projects#index" do
        put :update, id: @project, project: attributes_for(:project)
        expect(response).to redirect_to(admin_projects_url)
      end
    end

    context "with invalid attributes" do
      it "does not change @project attributes" do
        put :update, id: @project, project: attributes_for(:project,
          name: nil)
        @project.reload
        expect(@project.name).to eq(@project_name)
      end

      it "re-renders the edit template" do
        put :update, id: @project, project: attributes_for(:project,
          name: nil)
        expect(response).to render_template :edit
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
      expect(response).to redirect_to(admin_projects_url)
    end
  end
end
