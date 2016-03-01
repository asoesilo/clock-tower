require 'spec_helper'

describe Api::ProjectsController do

  logged_in_user

  describe "#index" do
    it "should render a JSON object" do
      get :index
      expect(response.content_type).to eq("application/json")
    end

    it "should render a list of all projects" do
      project = build :project
      expect(Project).to receive(:all).and_return([project])
      get :index
      expect(response.body).to eq([project].to_json)
    end
  end

end