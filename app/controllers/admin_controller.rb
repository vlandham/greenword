# Controls various administrative tasks.  These actions include translating texts, creating other admins, and editing tests.
# Many of the other admin tasks are kept in their respective controllers, i.e. editing / viewing user details is in the user_controller
#
# This was done to ultimately make the code more intuitive to follow, but isn't 100% consistent.  Hence the use of this controller to
# take care of loose ends and actions which don't seem to fit specifically in their own controller.
class AdminController < ApplicationController
  before_filter :admin_login_required
  before_filter :set_locale
  before_filter :set_semester
  
  # Displays navigation for rest of the actions here, and in the other controllers.
  def index
    @cur_semester = @semester
  end

  # Used to display untranslated as well as translated text to allow new translations / changes to be made.  
  # 
  # The tutorial used to set this up is located at www:http://www.artweb-design.de/2006/11/10/get-on-rails-with-globalize-comprehensive-writeup
  def translate
    Locale.set('es-CR')
    @view_translations = ViewTranslation.find(:all, 
                :conditions => [ 'text IS NULL AND language_id = ?', Locale.language.id ], 
                :order => 'tr_key')
   @all_translations = ViewTranslation.find(:all, 
                :conditions => ['text IS NOT NULL AND language_id = ?', Locale.language.id],
                :order => 'text')
  end
  
  # Used for the ajax editablility of the translation.
  def translation_text
    @translation = ViewTranslation.find(params[:id])
    render :text => @translation.text || ""  
  end

  # Used for the ajax editablility of the translation.  
  def set_translation_text
    @translation = ViewTranslation.find(params[:id])
    previous = @translation.text
    @translation.text = params[:value] unless params[:value].empty?
    @translation.text = previous unless @translation.save
    render :partial => "translation_text", :object => @translation.text  
  end
  
  # Used to create a new administrator for the current semester.
  def new_admin
    @user = User.new(params[:user])
    @user.semester_id = @semester.id
    return unless request.post?
    @user.admitted = true
    @user.admin = true
    @user.save!
    self.current_user = @user
    redirect_to(:controller => 'admin', :action => 'index')
    flash[:notice] = "New Admin: #{@user.whole_name} Created"
  rescue ActiveRecord::RecordInvalid
    render :action => 'new_admin'
  end
  
  
  # The results section here refers to the search process and not the display of results handled in the results_controller.  This action recieves the query from the search action and pulls up the results.  If the query was empty, we are redirected back to the search action.
  def results
    # if request.post?
     @query = params[:query] 
     redirect_to :action => :search and return if @query.nil? or @query.empty?
     # @results = Post.find_by_contents(@search_term)
     @total, @results = Post.full_text_search(@query, :page => (params[:page]||1)) 
     @pages = pages_for(@total)
   end

  # Display links to go to the gallery or discussion forum for this semester
  def forums
    @discussion = @semester.forums.find_discussion
    @gallery = @semester.forums.find_photo
  end
  
  # Allows to change the name of the forums.  Really shouldn't be used, as there are only two forums and their attributes don't need to be modified.  These forums are created when a new semester is made from a copy of an old semester.
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
  
  # Delete a particular forum.  This should also delete all the posts / topics associated with the forum. like edit_forum this isn't needed and shouldn't really be used.
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
  
  # Creates a new forum, based on the forum_type parameter fed to it. This allows for easy creation of the two different types of forums.  The only time this is needed is when you've created a semester from scratch. Then the veiw for index will display links to create the new forums.  If a forum is copied from a previous one then new forums are automatically created in the semester_controller
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
   
  # Toggles on the enroll feature for a semester, meaning that students can sign-up for this semester, once this is turned on.  This action will also turn off enrollment, with the idea that an admin might want to stop enrollment after a certain date 
  def toggle_enroll
    @semester.toggle(:enrollable)
    @semester.save
    redirect_to :action => :index
  end
    
end
