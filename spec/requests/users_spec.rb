require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /users" do
    before do
      create_list(:user, 3)
      get "/users"
    end

    it "returns 200" do
      expect(response).to have_http_status(200)
    end

    it "returns all users" do
      res = JSON.parse(response.body)["users"]
      expect(res.count).to eq(User.count)
    end
  end

  describe "POST /users" do
    describe "when valid" do
      before do
        @params = {
          user: {
            name: "user",
            email: "user@examle.com",
            password: "password"
          }
        }
        post "/users", params: @params
      end

      it "returns 200" do
        expect(response).to have_http_status(200)
      end

      it "creates user" do
        expect(User.count).to eq 1
      end

      it "returns user" do
        user = User.last
        res = JSON.parse(response.body)["user"]
        expect(res).to eq(user.as_json)
      end
    end

    describe "when invalid" do
      before do
        post "/users", params: { user: { name: "user" } }
      end

      it "returns 422" do
        expect(response).to have_http_status(422)
      end

      it "returns errors" do
        res = JSON.parse(response.body)
        expect(res).to include("errors")
      end

      it "does not create user" do
        expect(User.count).to eq 0
      end
    end
  end
end
