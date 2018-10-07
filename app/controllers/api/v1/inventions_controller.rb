class Api::V1::InventionsController < ApplicationController
  before_action :set_invention, only: :destroy
  def index
    @inventions = Invention.all
    respond_to do |format|
      format.json {render json: @inventions, status: 200}
      format.xml {render xml: @inventions, status: 200}
    end
  end

  def show
    #take care of finding by bits or by bit count or by material
    unless params[:title].nil?
      @invention = Invention.find_ty_title(params[:title])
    else
      @invention = Invention.find(params[:id])
    end
    render status: 200, json: @invention
  end

  def update
    #take care if error during database save
    unless params[:title].nil?
      @invention = Invention.find_ty_title(params[:title])
    else
      @invention = Invention.find(params[:id])
    end
    @invention.update(params)
    render status: 200, json: @invention
  end

  def destroy
    @invention.destroy
    render status: 204, json: {}
  end

  def destroy_by_title
    @invention = Invention.find_by_title(params[:title])
    @invention.destroy
    render status: 204, json: {}
  end

  def create
    @invention = Invention.new(invention_params)
    if @invention.save!
      render status: 201, json: @invention
    else
      render json: @invention.errors, status: :unprocessable_entity
    end
  end

  private

  def set_invention
    @invention = Invention.find(params[:id])
  end

  def invention_params
    params.require(:invention).permit(:title, :description,
      :user_name, :user_email, :bits => {}, :materials => [])
  end
end
