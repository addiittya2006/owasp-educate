class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    # @questions = Question.where('report = ? OR report IS ?', false, nil)
    @questions = Question.where(report:[false, nil])
    @bug_reports = Question.where(report: true)
  end

  def show
    respond_with(@question)
  end

  def new
    @question = Question.new
  end

  def edit
  end

  def upvote
    @question = Question.find(params[:question_id])
    @question.upvotes = @question.upvotes + 1
    if @question.save
      respond_to do |format|
        flash[:notice] = "Upvoted!"
        format.html { redirect_to questions_url }
      end
    end
  end

  def downvote
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
    @question.upvotes = 0
    respond_to do |format|
      if @question.save
        format.html { redirect_to questions_url, notice: 'Feedback successfully Noted' }
        format.json { render json: "{ \"status\" : \"success\" }"}
      else
        format.html { render :new }
        format.json { render json: "{ \"status\" : \"failed\" }"}
      end
    end
  end

  def update
    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to questions_url, notice: 'Your Question was updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @question.destroy
    respond_to do |format|
      format.html { redirect_to questions_url, notice: 'That issue was Solved.' }
    end
  end

  private
  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :description, :upvotes, :report)
  end
end
