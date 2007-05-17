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
   @word_hash = split_into_hash_of_arrays(@word_answers) { |ans| ans.word } 
   @completion_answers = @student.completion_answers.find(:all)
   @scenario_answers = @student.scenario_answers.find(:all)
   @discussion_posts = Post.find_discussion_posts(@student.id)
   @gallery_posts = Post.find_gallery_posts(@student.id)
  end
  
  def view
    @student = @semester.users.find(params[:id])
    
  end
  
  
  
  def stats
     @student = @semester.users.find(params[:id])
     @posts = @student.posts.find_recent
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
