class Api::V1::InventionsController < ApplicationController
  def index
    @inventions = Invention.all
    respond_to do |format|
      format.json {render json: @inventions, status: 200}
      format.xml {render xml: @inventions, status: 200}
    end
  end

  def show
  end

  def update
  end

  def destroy
  end

  def create
  end
end
