class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @questions = Question.all
    respond_with(@questions)
  end

  def show
    respond_with(@question)
  end

  def new
    @question = Question.new
    respond_with(@question)
  end

  def edit
  end

  def upvote
    # @question.upvotes = @question.upvotes + 1
    # @question.save
    @question = Question.find(params[:question_id])
    @question.upvotes = @question.upvotes + 1
    if @question.save
      respond_to do |format|
        flash[:notice] = "Downvoted!"
        format.html { redirect_to questions_url }
      end
    end
  end

  def downvote
    # @question.update_attribute(:upvote, @question.upvotes - 1)
    @question = Question.find(params[:question_id])
    @question.upvotes = @question.upvotes - 1
    if @question.save
      respond_to do |format|
        flash[:notice] = "Downvoted!"
        format.html { redirect_to questions_url }
      end
    end

  end

  def create
    @question = Question.new(question_params)
    @question.save
    respond_with(@question)
  end

  def update
    @question.update(question_params)
    respond_with(@question)
  end

  def destroy
    @question.destroy
    respond_with(@question)
  end

  private
  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :description, :upvotes)
  end
end
