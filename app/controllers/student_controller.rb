class StudentController < ApplicationController
  before_filter :set_locale
  before_filter :set_semester
  before_filter :set_test

  
  def index
    @user = @current_user
  end
  
  def results
    @english= @semester.test_sets.find_english
    @spanish = @semester.test_sets.find_spanish
  end

  def word
    @words = @current_test.words
  # should be the next item after the last question answered  
  # if there is no last question answered, then it will be the first question
    last_answered = @current_user.last_word
    if !last_answered.nil?
        @last_word = @words.find(last_answered)
         if @last_word.last?
           flash[:notice] = "You have already taken this test"
           redirect_to :controller => "student", :action => "index" and return
         else
           @last_word = @last_word.lower_item
         end
    else
       @last_word = @words.find(:first)
    end
    @answers = []
    Settings.word_answer_number.times { |number| @answers[number] = WordAnswer.new}
  end
  
  def next_word  
     @words = @current_test.words
  # We need to save all the answers to the question  atomically -- i.e. only if all are valid 
  #     will any be saved    
  # First grab the answers array from the input
    answers = params['answer']
    # Create an empty array to hold the actual WordAnswer objects
    word_answers = []
    # This boolean will stay true if all the answers have been answered
    all_ok = true
    
    # For each answer in answers create a new WordAnswer in the word_answer array
    answers.each_with_index do |answer, index|
      word_answers[index] = WordAnswer.new(:value => params['answer'][index]['value'],                              
                                  :user_id => @current_user.id, 
                                  :question_id => params['question_id'])
      # if the word_answer is not valid -- i.e. there is an empty spot, then all_ok is false
      if !word_answers[index].valid?
        all_ok = false
      end
    end
    
    # Set up the next_word to be displayed  
    current_word = @words.find(params['question_id'])
    @next_word = current_word
    
    # Here we save all the created WordAnswers if all are present
    if all_ok
      word_answers.each do |answer|
        answer.save
      end
       @next_word = current_word.lower_item
     else
        flash[:notice] = "Error: Answer cannot be blank"
         @next_word = current_word 
    end
  end
  
  def completion
    @completions = @current_test.completions
  # should be the next item after the last question answered  
  # if there is no last question answered, then it will be the first question
    last_answered = @current_user.last_completion
    if !last_answered.nil?
       @last_completion = @completions.find(last_answered)
       if @last_completion.last?
          flash[:notice] = "You have already taken this test"
         redirect_to :controller => "student", :action => "index" and return
       else
         @last_completion = @last_completion.lower_item
       end
    else
       @last_completion = @completions.find(:first)
    end 
    @answer = CompletionAnswer.new
  end
  
  def next_completion  
     @completions = @current_test.completions
  # We need to save all the answers to the question  atomically -- i.e. only if all are valid 
  #     will any be saved  
      answer = CompletionAnswer.new(:value => params['answer'],                              
                                  :user_id => @current_user.id, 
                                  :question_id => params['question_id'])
      
      # Set up the next_word to be displayed  
      current_completion = @completions.find(params['question_id'])
      @next_completion = current_completion

      # Here we save all the created WordAnswers if all are present
      if answer.save
         @next_completion = current_completion.lower_item
         # if @next_completion.nil?
           # flash[:notice]  = "Completion Test Completed.  Thank you!"
           # redirect_to :action => "index" and return
         # end
       else
          flash[:notice] = "Error: Answer cannot be blank"
           @next_completion = current_completion 
      end
  end
  
  def scenario
    @scenario = @current_test.scenario
    last_answered = @current_user.last_scenario
    if !last_answered.nil?
      flash[:notice] = "You have already taken this test"
      redirect_to :controller => "student", :action => "index" and return
    end
    @answer = ScenarioAnswer.new
  end
  
  def save_scenario
    if request.post?
      answer = ScenarioAnswer.new(:value => params["answer"]['value'],                              
                                  :user_id => @current_user.id, 
                                  :question_id => params['question_id'])
      if answer.save
        flash[:notice] = "Test Complete Thanks!"
        redirect_to :controller => "student", :action => "index" and return
      else
        redirect_to :controller => "student", :action => "scenario"
      end
    end
  end
  
  private
  
  def set_test
    @current_test = @semester.test_sets.find(:first,
                    :conditions => ["language = ?", @current_user.language])
  end
  
end
