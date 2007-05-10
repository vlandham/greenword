class SemesterController < ApplicationController
 before_filter :admin_login_required
 layout 'admin'
 def index
   @semesters = Semester.find(:all, :order => "created_on DESC")
 end
 
 def duplicate
   if(request.post?)
     old_semester = Semseter.find(params[:id])
     if(old_semseter)
       new_semester = Semester.new(params[:semester])
       if(new_semester.save)
         old_semester.duplicate_test_sets(new_semester.id)
       end
     else
       flash[:notice] = "Semester not Valid"
     end
  end
 end
  
end
