class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  # before_action :authenticate_user!
  # before_action :admin_only, :except => :show
  authorize_resource


  def index
    if params[:tag]
      @articles = Article.tagged_with(params[:tag])
    else
      @articles = Article.all
    end
  end

  def show
    render :layout => false
  end

  def new
    # authorize! :create, @article
    @article = Article.new
  end

  def edit
    # authorize! :update, @article
  end

  def create
    # authorize! :create, @article

    @article = Article.new(article_params)

    respond_to do |format|
      if @article.save
        if params[:image]
            @article.pictures.create(image: params[:image])
        end
        format.html { redirect_to articles_url, notice: 'Article was successfully created.' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    # authorize! :update, @article

    respond_to do |format|
      if @article.update(article_params)
        if params[:image]
            @article.pictures.create(image: params[:image])
        end
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    # authorize! :destroy, @article
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_article
      @article = Article.find(params[:id])
    end

    def article_params
      params.require(:article).permit(:title, :text, :category_id, :tag_list)
    end
end