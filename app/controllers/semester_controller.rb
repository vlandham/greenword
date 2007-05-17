class SemesterController < ApplicationController
 before_filter :admin_login_required
 before_filter :set_semester
 layout 'admin'
 
 def index
   @semesters = Semester.find(:all, :order => "created_on DESC")
 end
 
 def new
  @old_semester = Semester.find(params[:id])
  @semester = Semester.new
 end
 
 def edit
   @semester = Semester.find(params[:id])
   redirect_to :action => :index if @semester.nil?
 end
 
 def view
   @semesters = Semester.find(:all, :order => "created_on DESC")
 end
 
 def set_current_semester
   Settings.current_semester = params[:id] if Semester.exists?(params[:id])
   redirect_to :action => :view
 end
 
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
 
 def duplicate
   if(request.post?)
     old_semester = Semester.find(params[:id])
     if(old_semester)
       copy_classes_box = params[:copy_classes]
       # puts "Copy classes box: "+copy_classes_box
       new_semester = Semester.new(params[:semester])
       new_semester.freeze = 0
       if(new_semester.save)
         old_semester.duplicate_test_sets(new_semester.id)
         flash[:notice] = "Semester #{old_semester.name} Duplicated, new semester created"
         Settings.current_semester = new_semester.id
         create_new_forums(new_semester.id)
         # if the checkbox is checked, copy old classes
         if(copy_classes_box == "1")
           
           copy_classes( old_semester.id,new_semester.id)
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
 
 def create_new_forums(current_semester_id)
   @semester = Semester.find(current_semester_id)
   if(@semester)
   # create discussion forum  
     if @semester.forums.find_discussion.nil?
       @discussion_forum = Forum.new( :name => "Discussion", 
              :description => "This is the Discussion Fourm", :semester_id => current_semester_id,
              :forum_type => 'dis')
       @discussion_forum.save
     end   
     #create gallery forum
     if @semester.forums.find_photo.nil?
       @gallery_forum = Forum.new( :name => "Gallery", 
               :description => "This is the Gallery Fourm", :semester_id => current_semester_id,
               :forum_type => 'pho')
        @gallery_forum.save
     end  
   end
 end
  
  
  
end
