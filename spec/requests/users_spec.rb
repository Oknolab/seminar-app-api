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

  describe "PATCH /users/:id" do
    describe "when valid" do
      before do
        @user = create(:user)
        @params = {
          user: {
            name: "user_edited",
          }
        }

        patch "/users/#{@user[:id]}", params: @params
      end

      it "returns 200" do
        expect(response).to have_http_status(200)
      end

      it "updates user" do
        @user.reload
        expect(@user[:name]).to eq(@params[:user][:name])
      end

      # it "returns user" do
      #   res = JSON.parse(response.body)["user"]
      #   expect(res).to eq(@user.as_json)
      # end
    end

    describe "when invalid" do
      before do
        @user = create(:user)
        patch "/users/#{@user[:id]}", params: { user: { name: "" } }
      end

      it "returns 422" do
        expect(response).to have_http_status(422)
      end

      it "returns errors" do
        res = JSON.parse(response.body)
        expect(res).to include("errors")
      end

      it "does not update user" do
        @user.reload
        expect(@user[:name]).to_not eq("")
      end
    end

    describe "when user not found" do
      before do
        patch "/users/0", params: { user: { name: "user_edited" } }
      end

      it "returns 404" do
        expect(response).to have_http_status(404)
      end

      it "returns error" do
        res = JSON.parse(response.body)
        expect(res).to include("errors")
      end
    end
  end

  describe "DELETE /users/:id" do
    describe "when valid" do
      before do
        @user = create(:user)
        delete "/users/#{@user[:id]}"
      end

      it "returns 200" do
        expect(response).to have_http_status(200)
      end

      it "deletes user" do
        expect(User.count).to eq(0)
      end
    end

    describe "when user not found" do
      before do
        delete "/users/0"
      end

      it "returns 404" do
        expect(response).to have_http_status(404)
      end

      it "returns error" do
        res = JSON.parse(response.body)
        expect(res).to include("errors")
      end
    end
  end
end
