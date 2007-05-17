class TestController < ApplicationController
  before_filter :set_semester
  before_filter :admin_login_required
  layout "admin"

  def index
     @english = @semester.test_sets.find_english
     @spanish = @semester.test_sets.find_spanish
  end
  
  def edit
    @test = @semester.test_sets.find(params[:id])
  end
  
  def view
    redirect_to :action => :index and return unless params[:id]
    @test = @semester.test_sets.find(params[:id])
  end
  
  def compare
    @english = @semester.test_sets.find_english
    @spanish = @semester.test_sets.find_spanish
  end
  
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
  
  # Words section  

  def words
    # unless params[:id]
      # redirect_to(:controller => 'test', :action => 'index')
    # end
    @test = @semester.test_sets.find(params[:id])   
    @words = @test.words.find(:all)
    
  end
  
  def word_sort
    @test = @semester.test_sets.find(params[:id])
    @test.words.each do |word|
      word.position = params['sortable'].index(word.id.to_s) +1
      word.save
    end
    render :nothing => true
  end
  
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

# completion section
  def completions
    @test = @semester.test_sets.find(params[:id]) 
    @completions = @test.completions.find(:all)
  end
  
  def completion_sort
    @test = @semester.test_sets.find(params[:id])
    @test.completions.each do |completion|
      completion.position = params['sortable'].index(completion.id.to_s) +1
      completion.save
    end
    render :nothing => true
  end
  
  def completion_create
     @completion = Completion.new(params[:completion])
     test_id = @completion.test_set_id
     return unless request.post?
     @completion.save!     
     flash[:notice] = "New Completion created"
     redirect_to(:controller => 'test', :action => 'completions', :id => test_id)
   rescue ActiveRecord::RecordInvalid
     flash[:notice] = "Error in completion creation"
      redirect_to(:controller => 'test', :action => 'completion', :id => test_id)
   end
   
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

  def scenario
    @test = @semester.test_sets.find(params[:id])
    test_id = @test.id
    @scenario = @test.scenario
    if @scenario == nil
      scenario_create(test_id)
    end
    if request.post?  
      if @scenario.update_attributes(params[:scenario])
        flash[:notice] = "Scenario Has been Updated"
        redirect_to :controller => 'test', :action => 'view', :id => test_id
      end
    end
  end
  
  def scenario_create(test_id)
    scenario = Scenario.new(:value => "edit", :show => 0, :test_set_id => test_id, :visible => 0  )
    scenario.save
    redirect_to :action => "scenario", :id => test_id and return
  end
  
end
