class PingsController < ApplicationController
  def index
    render json: { message: 'pong' }
  end
end
