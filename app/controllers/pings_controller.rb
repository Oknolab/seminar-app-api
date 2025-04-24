class PingsController < ApplicationController
    def index
        render json: { message: "Pong" }, status: :ok
    end
end