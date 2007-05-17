class AdminController < ApplicationController
  before_filter :admin_login_required
  before_filter :set_locale
  before_filter :set_semester
  
  def index
    @cur_semester = @semester
  end

  def translate
    Locale.set('es-CR')
    @view_translations = ViewTranslation.find(:all, 
                :conditions => [ 'text IS NULL AND language_id = ?', Locale.language.id ], 
                :order => 'tr_key')
   @all_translations = ViewTranslation.find(:all, 
                :conditions => ['language_id = ?', Locale.language.id],
                :order => 'text')
  end
  
  def translation_text
    @translation = ViewTranslation.find(params[:id])
    render :text => @translation.text || ""  
  end
  
  def set_translation_text
    @translation = ViewTranslation.find(params[:id])
    previous = @translation.text
    @translation.text = params[:value]
    @translation.text = previous unless @translation.save
    render :partial => "translation_text", :object => @translation.text  
  end
  
  def user
    
  end
  
  def results
    if request.post?
     @search_term = params[:search][:search]
     @results = Post.find_by_contents(@search_term)
   else
     redirect_to :action => :search
   end
   
   end
  
  def test
    @semester = Semester.find(1)
    @tests = @semester.tests.find(:all)
  end
  
  def edit_test
    @test = params[:id]
  end
  
  def forums
    @discussion = @semester.forums.find_discussion
    @gallery = @semester.forums.find_photo
  end
  
  def edit_forum
    @forum = @semester.forums.find(params[:id])
    return unless request.post?
    @forum.update_attributes!(params[:forum])
    redirect_to(:controller => 'admin', :action => 'forums')
    flash[:notice] = "Forum edited"
  rescue ActiveRecord::RecordInvalid
    flash[:notice] = "Error in Forum Creation"
    render :action => 'new_forum'
  end
  
  def destroy_forum
    if request.post?
      forum = @semester.forums.find(params[:id])
      begin
        forum.destroy
        flash[:notice] = "#{forum.name} deleted"
        # redirect_to( :controller => 'test', :action => 'words', :id => test_id) and return
      rescue Exception => e
        flash[:notice] = e.message
      end
      redirect_to :controller => 'admin', :action => 'forums'
    end
  end
  
  def new_forum
        @forum_type = params[:forum_type]
        @forum = Forum.new(params[:forum])
        @forum.semester_id = @semester.id
        
        return unless request.post?
        @forum.save!     
        redirect_to(:controller => 'admin', :action => 'forums')
        flash[:notice] = "New Forum created"
      rescue ActiveRecord::RecordInvalid
        flash[:notice] = "Error in Forum Creation"
        render :action => 'new_forum'
  end
  
  
end
