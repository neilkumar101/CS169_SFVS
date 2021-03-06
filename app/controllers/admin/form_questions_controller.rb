class Admin::FormQuestionsController < Admin::AdminController
  
  before_filter :require_admin
  before_filter :pressed_cancel?, :only => [:create, :update]
  
  def index
    @form = Form.find(params[:form_id])
    gon.form_id = params[:form_id]
    @form_questions = @form.form_questions.sort_by {|question| question.order}
  end

  def new
    #default: render 'new' template
  end

  def create
    @form = Form.find(params[:form_id])
    set_attr
    @form.form_questions.create(params[:form_question])
    @form.update_form_questions_order
    flash[:notice] = "Form Question was succesfully created"
    redirect_to admin_form_form_questions_path(@form)
  end

  def destroy
    @form_question = FormQuestion.find(params[:id])
    @form_question.destroy
    # update the ordering of the questions
    @form = Form.find_by_id(params[:form_id])
    @form.update_form_questions_order
    flash[:notice] = "Question deleted."
    redirect_to admin_form_form_questions_path(Form.find(params[:form_id]))
  end

  def edit
    @form = Form.find(params[:form_id])
    @form_question = FormQuestion.find(params[:id])
    if @form_question.question_type == "checkbox"
      @check_answer = get_answers_to_populate(@form_question.question_type, @form_question)
    elsif  @form_question.question_type == "radio_button"
      @radio_answer = get_answers_to_populate(@form_question.question_type, @form_question)
    end
  end

  def update
    # update the form_question with given attributes values
    @form = Form.find(params[:form_id])
    @form_question = FormQuestion.find(params[:id])
    set_attr
    @form_question.update_attributes!(params[:form_question])
    flash[:notice] = "Form Question was succesfully updated"
    redirect_to admin_form_form_questions_path(@form)
  end

  def sort
    params[:order].each do |key, value|
      FormQuestion.find(value[:id]).update_attribute(:order,value[:position])
    end
    render :nothing => true
  end

  def get_answers_from_param(q_type)
    option = q_type == "checkbox"? :check_answer : :radio_answer
    answers = []
    params[option].each do |key, value|
      if value != ""
        answers << value
      end
    end
    answers.to_s.gsub('"','')
  end

  def set_attr
    q_type = params[:form_question][:question_type]
    if q_type == "checkbox" || q_type == "radio_button"
      params[:form_question][:answers] = get_answers_from_param(q_type)
    end
    params[:form_question][:order] = @form_question.nil? ? @form.number_of_questions + 1 : @form_question.order
  end

  def pressed_cancel?
    if params[:commit] == 'Cancel'
      redirect_to admin_form_form_questions_path(:form_id => params[:form_id])
    end
  end

  def get_answers_to_populate(q_type, question)
    answers = []
    String(String(question.answers)[1..-2]).split(',').each do |selection|
      answers << selection.strip
    end
    answers
  end
end