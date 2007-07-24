# CourseController holds methods to manage and modify courses - which are known as 'classes' in the views.  The name classes was not used as it is a key word in ruby and would result in error / confusion.  Each class should be part of a section (group in the views).  This is done so the forums are limited to a sub-set of the classes involved in the Greenword experiment.
#
# Before enrollment is allowed, all courses and sections should be set up and assigned correctly.  This is to ensure students will have the correct courses to choose from in the sign-up process, and so that they will be able to see the right forums.
class CourseController < ApplicationController
  before_filter :set_semester
  before_filter :admin_login_required
  layout "admin"
  
  # display the courses and sections so that courses can be assigned to a particular section
  def index
    @courses = @semester.courses.find_ordered
    @sections = @semester.sections.find(:all)
  end
  
  # Create a new course and save it to the model layer.  Currently courses are created without an associated secetion.  But for the forum stuff to work correctly, all courses need to be assigned to a semester.  The best way for this to work would be to create a number of sections (which in this implementation will be 1 section for every 2 courses) and then create the courses.
  #
  # When creating a new semester via the copy method, there is an checkbox option to also copy over the old semesters courses and sections.  This would be the recommend method to create courses if the course names stayed the same (or nearly the same) 
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
   
   # edit course details like name.  The names are displayed in the signup section of the students
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
  
  # Used in the ajax manipulation of the courses and the sections.  When a course is dragged over a section, it is assigned to that section.  
  #
  # Note the render :update section which is another way to perform ajax manipulation of the page as a substitute for a standalone .rjs page. 
  def add_to_section
    course_id = params[:id].split("-")[1]
    @course = @semester.courses.find(course_id)
    @section = @semester.sections.find(params["section_id"])
    @course.section_id = @section.id
    @course.update
    @courses = @semester.courses.find_ordered
    render :update do |page|
       # page.replace "course-#{course_id}", :partial => 'course', :object => @course
       page.replace_html "courses", :partial => 'courses', :object => @courses
       page.visual_effect :highlight, "course-#{course_id}"
    end
  end
  
  # Display courses by section
  def by_section
    @sections = @semester.sections.find(:all)
     # @courses = @semester.courses.find(:all, :order => "section_id")
  end
  
end
