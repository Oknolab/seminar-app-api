require 'rails_helper'

RSpec.describe "Pings", type: :request do
  describe "GET /index" do
    before do
      get "/ping"
    end

    it "returns 200" do
      expect(response).to have_http_status(200)
    end
  end
end
