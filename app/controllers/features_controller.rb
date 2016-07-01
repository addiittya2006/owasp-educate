class FeaturesController < ApplicationController
  # before_action :set_feature, only: [:show, :edit, :update, :destroy]
  before_action :set_feature, only: [:show]

  respond_to :html

  def index
    @features = Feature.all
    respond_with(@features)
  end

  def show
    respond_with(@feature)
  end

  # def new
  #   @feature = Feature.new
  #   respond_with(@feature)
  # end

  # def edit
  # end

  # def create
  #   @feature = Feature.new(feature_params)
  #   @feature.save
  # end

  # def update
  #   @feature.update(feature_params)
  #   respond_with(@feature)
  # end

  def use
    @feature = Feature.find(params[:feature_id])
    if !params[:many].nil?
      @feature.count = @feature.count + params[:many].to_i
    else
      @feature.count = @feature.count + 1
    end
    if @feature.save
      respond_to do |format|
        format.json { render json: "{ \"status\" : \"ok\" }" }
      end
    end
  end

  private
  def set_feature
    @feature = Feature.find(params[:id])
  end

  def feature_params
    params.require(:feature).permit(:count, :many)
  end
end
