# Handles the views of most of the pages that students have access to.  Don't confuse with the user_controller which is mainly for admin access. Student was used to make the url's more intuitive. 
class StudentController < ApplicationController
  before_filter :set_locale
  before_filter :set_semester
  before_filter :set_test
  before_filter :block_locked, :except => [:results, :index]

# Displays basic information about the student as well as the announcements that are toggled to be on the front page  
  def index
    @user = @current_user
    @announcements = @semester.announcements.find_front_page
  end

# Used to display the associations between words/situations/completions 
  def results
    @english= @semester.test_sets.find_english
    @spanish = @semester.test_sets.find_spanish
  end

# This is the beginning method for the word test. It checks to ensure that the student has not already complete the test, and then returns the last word not responded to. 
# 
# When taking the test, the next_word method along with the next_word.rjs file will facilitate the transition to the next word in the test and ensure that all the blanks have been filled before continuing.
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
  
  # Returns the next word to be displayed in the test. the associated rjs template handles some of the logistics (unfortunatly)
  def next_word  
     @words = @current_test.words
  # We need to save all the answers to the question  atomically -- i.e. only if all are valid 
  #     will any be saved    
  # First grab the answers array from the input
    @notice = nil
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
        # flash[:notice] = "Error: Answer cannot be blank"
        @notice = "Error: Answer cannot be blank"
        @next_word = current_word 
    end
    
      redirect_to :controller => "student", :action => "word" unless request.xhr?
  end
  
  # This is the beginning method for the completion test. See word for more info
  def completion
    @completions = @current_test.completions
    redirect_to :action => :index and return if @completions.empty?
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
  
  # This is the beginning method for the completion test. See word for more info
  def scenario
    @scenarios = @current_test.scenarios
    redirect_to :action => :index and return if @scenarios.nil?
    last_answered = @current_user.last_scenario
    if !last_answered.nil?
      @last_scenario = @scenarios.find(last_answered)
      if @last_scenario.last?
        flash[:notice] = "You have already taken this test"
        redirect_to :controller => "student", :action => "index" and return
      else
        @last_scenario = @last_scenario.lower_item
      end
    else
      @last_scenario = @scenarios.find(:first)
    end
    @answer = ScenarioAnswer.new
  end
  
    # Returns the next completion to be displayed in the test. the associated rjs template handles some of the logistics (unfortunatly)
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
      @notice = nil
      # Here we save all the created WordAnswers if all are present
      if answer.save
        # flash[:notice] = " "
         @next_completion = current_completion.lower_item
         # if @next_completion.nil?
           # flash[:notice]  = "Completion Test Completed.  Thank you!"
           # redirect_to :action => "index" and return
         # end
       else
          @notice = "Error: Answer cannot be blank"
          # flash[:notice] = "Error: Answer cannot be blank"
           @next_completion = current_completion 
      end
      redirect_to :controller => "student", :action => "completion" unless request.xhr?
  end
  
# Returns the next scenario to be displayed in the test. the associated rjs template handles some of the logistics (unfortunatly)
  def next_scenario  
     @scenarios = @current_test.scenarios
     # We need to save all the answers to the question  atomically -- i.e. only if all are valid 
     #     will any be saved  
      answer = ScenarioAnswer.new(:value => params['value'],                              
                                  :user_id => @current_user.id, 
                                  :question_id => params['question_id'])
      
      # Set up the scenario to be displayed  
      current_scenario = @scenarios.find(params['question_id'])
      @next_scenario = current_scenario
      @notice = nil

      # Here we save all the created ScenarioAnswers if all are present
      if answer.save
        @notice = "Error: Answer cannot be blank"
        @next_scenario = current_scenario.lower_item
         # if @next_completion.nil?
           # flash[:notice]  = "Completion Test Completed.  Thank you!"
           # redirect_to :action => "index" and return
         # end
       else
          @notice = "Error: Answer cannot be blank"
          @next_scenario = current_scenario 
      end
      redirect_to :controller => "student", :action => "scenario" unless request.xhr?
  end
  
    
# not used anymore
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
 
# displays all the announcements for the current semester 
  def announcements
    @announcements = @semester.announcements.find(:all)
  end
  
# Displays documents and links for the semester.   Removed from the LibraryController for nicer urls, though it does make the app less RESTful
  def library
    @documents = @semester.documents.find(:all, :order => "created_on DESC")
    @links = @semester.links.find(:all, :order => "created_on DESC")
  end
  
  private

# Sets the test based on the languge of the user  
  def set_test
    @current_test = @semester.test_sets.find(:first,
                    :conditions => ["language = ?", @current_user.language])
  end
  
# Prevents tests being taken in locked semesters
  def block_locked
    redirect_to :action => :index and return if @semester.locked?
  end
  
end
