class UserController < ApplicationController
  before_filter :admin_login_required
  layout "admin"
  before_filter :set_semester
  
  def index
    
  end
  
  def waiting
    @courses = @semester.courses.find(:all)
  end
  
  def list
    @courses = @semester.courses.find(:all)
  end
  
  def edit
   @student = @semester.users.find(params[:id])
   @word_answers = @student.word_answers.find(:all)
   @completion_answers = @student.completion_answers.find(:all)
   @scenario_answers = @student.scenario_answers.find(:all)
  end
  
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
  
end
