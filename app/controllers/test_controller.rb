# Controls administrative actions on the test_sets and associated words/situations/scenarios.
#
# Methods involved in taking the test are in the StudentController
class TestController < ApplicationController
  before_filter :set_semester
  before_filter :admin_login_required
  layout "admin"

# Displays english and spanish test for the semester
# The view prevents more than one test_set of a particular language to be created
  def index
     @english = @semester.test_sets.find_english
     @spanish = @semester.test_sets.find_spanish
  end

# Allows a particular test to be edited  
  def edit
    @test = @semester.test_sets.find(params[:id])
  end
  
# Displays all components of a particular test
  def view
    redirect_to :action => :index and return unless params[:id]
    @test = @semester.test_sets.find(params[:id])
  end

# Displays english and spanish tests side-by-side  
  def compare
    @english = @semester.test_sets.find_english
    @spanish = @semester.test_sets.find_spanish
  end

# Allows the creation of a new test_set  
  def new
      @language = params[:lang]
      @test_set = TestSet.new(params[:test_set])
      @test_set.semester_id = @semester.id
      return unless request.post?
      @test_set.save!     
      redirect_to(:controller => 'test', :action => 'index')
      flash[:notice] = "New Test created"
    rescue ActiveRecord::RecordInvalid
      flash[:notice] = "Error in Section Creation"
      render :action => 'new'
  end

# Deletes test set and all components associated with it  
  def destroy
    if request.post?
      test = @semester.test_sets.find(params[:id])
      begin
        test.destroy
        flash[:notice] = "#{test.name} deleted"
        # redirect_to( :controller => 'test', :action => 'words', :id => test_id) and return
      rescue Exception => e
        flash[:notice] = e.message
      end
      redirect_to :controller => 'test', :action => 'index'
    end
  end
  
  
# Part of the ajaxed editing of the words for a particular test.  Displays them.
  def words
    # unless params[:id]
      # redirect_to(:controller => 'test', :action => 'index')
    # end
    @test = @semester.test_sets.find(params[:id])   
    @words = @test.words.find(:all)
    
  end
  
# Part of the ajaxed editing of the words for a particular test.  Re-sorts them.  
  def word_sort
    @test = @semester.test_sets.find(params[:id])
    @test.words.each do |word|
      word.position = params['sortable'].index(word.id.to_s) +1
      word.save
    end
    render :nothing => true
  end

# Part of the ajaxed editing of the words for a particular test.  creates and saves new word.
  def word_create
    @word = Word.new(params[:word])
    test_id = @word.test_set_id
    return unless request.post?
    @word.save!     
    # flash[:notice] = "New Word created"
    redirect_to(:controller => 'test', :action => 'words', :id => test_id)
  rescue ActiveRecord::RecordInvalid
    flash[:notice] = "Error in Section Creation"
     redirect_to(:controller => 'test', :action => 'words', :id => test_id)
  end
  
# Part of the ajaxed editing of the words for a particular test.  Deletes word.  
  def word_delete
    if request.post?
      word = Word.find(params[:id])
      test_id = word.test_set_id
      begin
        word.destroy
        flash[:notice] = "#{word.value} deleted"
        # redirect_to( :controller => 'test', :action => 'words', :id => test_id) and return
      rescue Exception => e
        flash[:notice] = e.message
      end
      redirect_to :controller => 'test', :action => 'words', :id => test_id
    end
  end

# Part of the ajaxed editing of the completions for a particular test.  Displays them.
  def completions
    @test = @semester.test_sets.find(params[:id]) 
    @completions = @test.completions.find(:all)
  end
  
# Part of the ajaxed editing of the completions for a particular test.  resorts them.  
  def completion_sort
    @test = @semester.test_sets.find(params[:id])
    @test.completions.each do |completion|
      completion.position = params['sortable'].index(completion.id.to_s) +1
      completion.save
    end
    render :nothing => true
  end
 
# Part of the ajaxed editing of the completions for a particular test.  creates and saves new one.  
  def completion_create
     @completion = Completion.new(params[:completion])
     test_id = @completion.test_set_id
     return unless request.post?
     @completion.save!     
     flash[:notice] = "New Completion created"
     redirect_to(:controller => 'test', :action => 'completions', :id => test_id)
   rescue ActiveRecord::RecordInvalid
     flash[:notice] = "Error in completion creation"
      redirect_to(:controller => 'test', :action => 'completions', :id => test_id)
   end

# Part of the ajaxed editing of the completions for a particular test.  Deletes one.   
   def completion_delete
     if request.post?
       completion = Completion.find(params[:id])
       test_id = completion.test_set_id
       begin
         completion.destroy
         flash[:notice] = "This completion was deleted"
         # redirect_to( :controller => 'test', :action => 'words', :id => test_id) and return
       rescue Exception => e
         flash[:notice] = e.message
       end
       redirect_to :controller => 'test', :action => 'completions', :id => test_id
     end
   end

# Part of the ajaxed editing of the scenarios for a particular test.  Displays them.  
  def scenarios
    @test = @semester.test_sets.find(params[:id]) 
    @scenarios = @test.scenarios.find(:all)
  end

# Part of the ajaxed editing of the scenarios for a particular test.  resorts them.    
  def scenarios_sort
    @test = @semester.test_sets.find(params[:id])
    @test.scenarios.each do |scenario|
      scenario.position = params['sortable'].index(scenario.id.to_s) +1
      scenario.save
    end
    render :nothing => true
  end

# Part of the ajaxed editing of the scenarios for a particular test.  creates and saves one.    
  def scenario_create
     @scenario = Scenario.new(params[:scenario])
     test_id = @scenario.test_set_id
     return unless request.post?
     @scenario.save!     
     flash[:notice] = "New Scenario created"
     redirect_to(:controller => 'test', :action => 'scenarios', :id => test_id)
   rescue ActiveRecord::RecordInvalid
     flash[:notice] = "Error in scenario creation"
      redirect_to(:controller => 'test', :action => 'scenarios', :id => test_id)
   end
   
# Part of the ajaxed editing of the scenarios for a particular test.  deletes one.     
#
# Not too DRY, huh?
   def scenario_delete
     if request.post?
       scenario = Scenario.find(params[:id])
       test_id = scenario.test_set_id
       begin
         scenario.destroy
         flash[:notice] = "This scenario was deleted"
         # redirect_to( :controller => 'test', :action => 'words', :id => test_id) and return
       rescue Exception => e
         flash[:notice] = e.message
       end
       redirect_to :controller => 'test', :action => 'scenarios', :id => test_id
     end
   end
  
  
end
