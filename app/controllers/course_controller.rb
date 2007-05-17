class CourseController < ApplicationController
  before_filter :set_semester
  before_filter :admin_login_required
  layout "admin"
  
  
  
  def index
    @courses = @semester.courses.find(:all)
  end
  
  def new
     @course = Course.new(params[:course])
     @course.semester_id = @semester.id
     return unless request.post?
     @course.save!     
     redirect_to(:controller => 'course', :action => 'index')
     flash[:notice] = "New course created"
   rescue ActiveRecord::RecordInvalid
     flash[:notice] = "Error in Section Creation"
     render :action => 'new'
   end
   
   def edit
     @course = @semester.courses.find(params[:id])
     return unless request.post?
     if(@course.update_attributes(params[:course]))
       flash[:notice] = "Course edited"
       redirect_to(:controller => 'course', :action => 'index')
     else
       flash[:notice] = "Error in Course Edit"
       render :action => 'edit'
     end
   end
  
  def list
    
  end
  
  def by_section
    @sections = @semester.sections.find(:all)
     # @courses = @semester.courses.find(:all, :order => "section_id")
  end
  
end
