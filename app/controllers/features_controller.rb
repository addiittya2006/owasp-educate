class FeaturesController < ApplicationController
  # before_action :set_feature, only: [:show, :edit, :update, :destroy]
  before_action :set_feature, only: [:show]
  before_filter :check_privileges, except: :use

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
      # @feature.count = @feature.count + params[:many].to_i
      params[:many].to_i.times do
        @feature.usages.create(ip_address: request.remote_ip)
      end
    else
      @feature.usages.create(ip_address: request.remote_ip)
    end
    if @feature.save
      respond_to do |format|
        format.json { render json: "{ \"status\" : \"ok\" }"}
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

  def check_privileges
    redirect_to articles_url, notice: 'You dont have enough permissions to be here' unless !current_user.nil? && current_user.admin?
  end
end
