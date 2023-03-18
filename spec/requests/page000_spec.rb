require 'rails_helper'

RSpec.describe "Page000s", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/page000/index"
      expect(response).to have_http_status(:success)
    end
  end

end
