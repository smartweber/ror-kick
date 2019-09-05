require 'rails_helper'

RSpec.describe Api::UsersController, :type => :controller do

  describe "GET show" do
    it "returns http success" do
      get :create
      expect(response).to have_http_status(:success)
    end
  end

  describe "PUT patch" do
    it "returns http success" do
      put :patch
      expect(response).to have_http_status(:success)
    end
  end

end
