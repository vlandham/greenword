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
         flash[:notice] = "Problem with updated fields"
         redirect_to :action => :edit, :id => @semester.id
       end
     end
   end
 end
 
 def duplicate
   if(request.post?)
     old_semester = Semester.find(params[:id])
     if(old_semester)
       new_semester = Semester.new(params[:semester])
       new_semester.freeze = 0
       if(new_semester.save)
         old_semester.duplicate_test_sets(new_semester.id)
         flash[:notice] = "Semester #{old_semester.name} Duplicated, new semester created"
         Settings.current_semester = new_semester.id
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
  
end
