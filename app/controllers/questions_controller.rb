class QuestionsController < ApplicationController

  before_action :authorize, except: [:show, :index]

  before_action :load_searches, only: [:show, :new, :create]

  def index
    @questions = repo.query(params[:q], current_user)
    load_searches
  end

  def show
    @question = repo.by_id_with_answers_and_users(params[:id])
  end

  def new
    @question = Question.new
  end

  def create
    transaction = CreateQuestion.new
    transaction.(question_params.merge!({ user_id: @current_user.id })) do |result|
      result.success do |question|
        flash[:notice] = "Question has been created."
        redirect_to questions_path
      end

      result.failure :validate do |errors|
        @question = Question.new(question_params)
        @errors = errors
        flash[:alert] = "Question could not be created."
        render :new
      end
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, :q).to_h.symbolize_keys
  end


  def repo
    QuestionRepository.new(ROM.env)
  end
end