class Api::V1::InventionsController < ApplicationController
  before_action :set_invention, only: [:destroy, :update, :show]
  before_action :set_invention_by_title, only: [:update_by_title, :destroy_by_title, :find_by_title]
  def index
    authenticate_request and return
    @inventions = Invention.all
    render status: 200, json: @inventions
  end

  def show
    authenticate_request and return
    #take care of finding by bits or by bit count or by material
    render status: 200, json: @invention
  end

  def find_by_title
    authenticate_request and return
    render status: 200, json: @invention
  end

  def update
    authenticate_request and return
    process_update
  end

  def update_by_title
    authenticate_request and return
    process_update
  end

  def where_bit_names_are
    authenticate_request and return
    @inventions = Invention.where_bit_names_are(params[:bit_names])
    render status: 200, json: @inventions
  end

  def destroy
    authenticate_request and return
    @invention.destroy
    render status: 204, json: {}
  end

  def destroy_by_title
    authenticate_request and return
    @invention = Invention.find_by_title(params[:title])
    @invention.destroy
    render status: 204, json: {}
  end

  def create
    authenticate_request and return
    @invention = Invention.new(invention_params)
    if @invention.save
      render status: 201, json: @invention
    else
      render json: @invention.errors, status: :unprocessable_entity
    end
  end

  private

  def set_invention
    @invention = Invention.find(params[:id])
  end

  def set_invention_by_title
    @invention = Invention.find_by_title(params[:title])
  end

  def process_update
    if @invention.update(invention_params)
      render status: 201, json: @invention
    else
      render json: @invention.errors, status: :unprocessable_entity
    end
  end

  def invention_params
    params.require(:invention).permit(:title, :description,
      :user_name, :user_email, :bits => {}, :materials => [])
  end
end
