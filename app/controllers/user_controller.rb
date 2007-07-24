# Controls more administrative access to students.  Part of the admin section.
class UserController < ApplicationController
  before_filter :admin_login_required
  layout "admin"
  before_filter :set_semester

# displays further options  
  def index
    
  end
  
# List of those students still waiting to be accepted into Greenword - ordered by course
  def waiting
    @courses = @semester.courses.find(:all)
  end

# lists all students
  def list
    @courses = @semester.courses.find(:all)
    @no_class_students = @semester.users.find(:all, :conditions => ['course_id IS NULL'])
  end

# Displays the responses of a particular student for the components of a test.  Also displays gallery posts and discussion posts.
#
# Link is here for the student_all_report
  def answers
   @student = @semester.users.find(params[:id])
   @word_answers = @student.word_answers.find(:all)
   @word_hash = split_into_hash_of_arrays(@word_answers) { |ans| ans.word } 
   @completion_answers = @student.completion_answers.find(:all)
   @scenario_answers = @student.scenario_answers.find(:all)
   @discussion_posts = Post.find_discussion_posts(@student.id)
   @gallery_posts = Post.find_gallery_posts(@student.id)
  end

# Allows editing of attributes for a user
  def edit
    @student = @semester.users.find(params[:id])
  end

# Performs update for the edit
  def update
    return unless request.post?
    @user = User.find(params[:id])
    @user.attributes = params[:student]
    if @user.save
      redirect_to :action => :view, :id => @user.id
    else
      redirect_to :action => :edit, :id => @user.id
    end
  end

# displays details about the user  
  def view
    @student = @semester.users.find(params[:id])
    
  end
  
# Displays graph and post stats for a particular student
  def stats
     @student = @semester.users.find(params[:id])
     @posts = @student.posts.find_recent
  end

# Sets a student to admitted to the Greenword Semester.  Used in waiting view
  def admit
    return unless request.post?
    student = @semester.users.find(params[:id])
    student.admitted = true
    if(student.save)
      render :update do |page|
         page.visual_effect :fade, "waiting-#{params[:id]}"
      end
    else
      render :update do |page|
        page.visual_effect :shake, 'head'
      end
    end
  end

# Helper function used somewhere.
  def split_into_hash_of_arrays(arry)
    hash = Hash.new
    for element in arry
      expr = yield(element)
      if not hash.has_key? expr.value
        hash[expr.value] = []
      end
      hash[expr.value].push element.value
    end
    hash
  end
  
end
