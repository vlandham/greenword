# Controls creation, and manipulation of semesters.  Semesters house all other models in Greenword.  They can be viewed as the highest level of organization for the application.  Some of the duplicating of a semester is handled (incorrectly) here, while some of it is in the semester model class. 
class SemesterController < ApplicationController
 before_filter :admin_login_required
 before_filter :set_semester
 layout 'admin'
 
# List all semesters in the database 
 def index
   @semesters = Semester.find(:all, :order => "created_on DESC")
 end

# allow the creation of a new semester.  Probably want to use copy instead of new, as it copies information from the old semester into the new semester which will proabably be useful.
 def new
   @semester = Semester.new
 end
 
# Sets up the process of copying duplicate information to a new semester. 
 def copy
  @old_semester = Semester.find(params[:id])
  # redirect_to :action => :index and return if @old_semester == nil
  @semester = Semester.new
 end
 
# Allows the modification of semester attributes like name and url
 def edit
   @semester = Semester.find(params[:id])
   redirect_to :action => :index if @semester.nil?
 end

# Another index like display
 def view
   @semesters = Semester.find(:all, :order => "created_on DESC")
 end

# Changes the current semester kept in the current_semester Setting.  
#
# Future work is planned to change this configuration and instead allow for semester setting based on the url. For example, fall06.greenword.net would automatically acquire the fall 06 semester. 
#
# Thus, this method will probably not be used in the future.
 def set_current_semester
   Settings.current_semester = params[:id] if Semester.exists?(params[:id])
   redirect_to :action => :view
 end
 
# Performs the actual update of a semester. 
 def update
   if request.post?
     @semester = Semester.find(params[:id])
     unless(@semester.nil?)

       if(@semester.update_attributes(params[:semester]))
         flash[:notice] = "#{@semester.name} updated"
         redirect_to :action => :index
       else
         render :action => :edit, :id => @semester.id
       end
     end
   end
 end
 
# Used by the copy method to duplicate information(instances) from a previous semester.
# = Automatic Duplication:
# * blank Gallery and Discussion forums using create_new_forums
# * Current admin user making the duplicate using copy_current_user
# = Optional Automatic Duplication:
# * Sections(Groups) from old semester using copy_sections
# * Courses(Classes) from old semester using copy_classes_from_section
#
# Previous semester must be valid to make a copy, and new semester must have been sucessfully saved.
 def duplicate
   if(request.post?)
     old_semester = Semester.find(params[:id])
     if(old_semester)
       copy_classes_box = params[:copy_classes]
       # puts "Copy classes box: "+copy_classes_box
       new_semester = Semester.new(params[:semester])
       new_semester.enrollable = false
       if(new_semester.save)
         old_semester.duplicate_test_sets(new_semester.id)
         flash[:notice] = "Semester #{old_semester.name} Duplicated, new semester created"
         Settings.current_semester = new_semester.id
         #creates blank forums-- photo & discussion
         new_semester.create_new_forums
         # copies current admin user to new semester
         copy_current_user(new_semester.id)
         
         # if the checkbox is checked, copy old classes
         if(copy_classes_box == "1")         
           copy_sections( old_semester.id,new_semester.id)
         end
         redirect_to :action => :index
       else
         flash[:notice] = "Problem with attributes of new semeseter"
         redirect_to :action => :new, :id => old_semester.id
       end
     else
       flash[:notice] = "Old Semester not Valid"
       redirect_to :action => :index
     end
  end
 end
 
 protected
 
# Used in duplicate method to copy old sections
 def copy_sections(old_semester_id, current_semester_id)
    @semester = Semester.find(old_semester_id)
    if(@semester)
      sections = @semester.sections
      sections.each do |section|
        new_section = Section.new(section.attributes)
        new_section.semester_id = current_semester_id
        if(new_section.save)
          copy_classes_from_section(section, new_section )
        end
      end
      
    end
 end
 
# Used in copy_sections to create new courses with the same information as the old ones and associate them with the correct copied section.
 def copy_classes_from_section(section, new_section)
   old_courses = section.courses
   old_courses.each do |old_course|
     new_course = Course.new(old_course.attributes)
     new_course.semester_id = new_section.semester_id
     new_course.section_id = new_section.id
     new_course.save
   end
 end
 
 # Not used anymore
 def copy_classes(old_semester_id,current_semester_id)
   @semester = Semester.find(old_semester_id)
   if(@semester)
     courses = @semester.courses
     # puts "Number of courses: "+courses.size.to_s
     courses.each do |course|
       new_course = Course.new(course.attributes)
       new_course.semester_id = current_semester_id
       new_course.save
     end
   end
 end


 
 # Creates a duplicate of the user making the new semester so that someone can log in.
 #
 # Currently, only the current user is duplicated for security reasons
 def copy_current_user(current_semester_id)
   @semester = Semester.find(current_semester_id)
    if(@semester)
      new_user = @current_user.clone
      new_user.semester_id = current_semester_id
      new_user.save!
    end
   
 end  
end
