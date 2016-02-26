require 'spec_helper'

describe Admin::TasksController do

  logged_in_user_admin

  describe "GET #index" do
    it "assigns the list of tasks to @tasks" do
      task = create(:task)
      get :index
      expect(assigns(:tasks)).to eq [task]
    end

    it "renders the :index template" do
      get :index
      expect(response.status).to eq(200)
      expect(response).to render_template :index
    end
  end

  describe "GET #new" do
    it "assigns a new Task to @task" do
      get :new
      expect(assigns(:task)).to be_a_new(Task)
    end

    it "renders the :new template" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "GET #edit" do
    before :each do
      @task = create(:task)
    end

    it "assigns the requested Task to @task" do
      get :edit, id: @task
      expect(assigns(:task)).to eq @task
    end

    it "renders the :edit template" do
      get :edit, id: @task
      expect(response).to render_template :edit
    end
  end

  describe "POST #create" do
    context "valid attributes" do
      it "saves the new task to database" do
        expect do
          post :create, task: attributes_for(:task)
        end.to change(Task, :count).by(1)
      end

      it "redirects to :index page" do
        post :create, task: attributes_for(:task)
        expect(response).to redirect_to(admin_tasks_url)
      end
    end

    context "invalid attributes" do
      it "does not save the new task to database" do
        expect do
          post :create, task: attributes_for(:task_without_name)
        end.to_not change(Task, :count)
      end

      it "re-render the :new page" do
        post :create, task: attributes_for(:task_without_name)
        expect(response).to render_template :new
      end
    end
  end

  describe "PUT #update" do
    before :each do
      @task_name = "Valid test task name"
      @task = create(:task, name: @task_name)
    end

    it "locates the requested task" do
      put :update, id: @task, task: attributes_for(:task)
      expect(assigns(:task)).to eq @task
    end

    context "valid attributes" do
      it "changes @project attributes" do
        new_name = "New task name"
        put :update, id: @task, task: attributes_for(:project,
          name: new_name)
        @task.reload
        expect(@task.name).to eq new_name
      end

      it "redirects to :index page" do
        put :update, id: @task, task: attributes_for(:task)
        expect(response).to redirect_to(admin_tasks_url)
      end
    end

    context "invalid attributes" do
      it "does not change @task attributes" do
        put :update, id: @task, task: attributes_for(:project,
          name: nil)
        @task.reload
        expect(@task.name).to eq @task_name
      end

      it "re-render the :edit page" do
        put :update, id: @task, task: attributes_for(:project,
          name: nil)
        expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE #destroy" do
    before :each do
      @task = create(:task)
    end

    it "deletes @task" do
      expect do
        delete :destroy, id: @task
      end.to change(Task, :count).by(-1)
    end

    it "redirects to :index page" do
      delete :destroy, id: @task
      expect(response).to redirect_to(admin_tasks_url)
    end
  end
end
