class ResultsController < ApplicationController
  before_filter :set_semester
  before_filter :admin_login_required, :except => [:index]
  layout "admin"
  
  def index
    redirect_to :action => "edit" and return
  end
  
  def edit
     @english = @semester.test_sets.find_english
     @spanish = @semester.test_sets.find_spanish
  end
  
  
  def toggle_word
    return unless request.post?
    word = Word.find(params[:id])
    if word.visible?
      word.visible = false
    else
      word.visible = true
    end
    if(word.save)
      render :update do |page|
         page.replace  "word-#{params[:id]}", :partial => 'word', :locals => {:word => word}
         page.visual_effect :highlight, "word-#{params[:id]}"
      end
    else
      render :update do |page|
        page.visual_effect :shake, 'head'
      end
    end
  end
  
 
  def toggle_completion
    return unless request.post?
    completion = Completion.find(params[:id])
    if completion.visible?
      completion.visible = false
    else
      completion.visible = true
    end
    if(completion.save)
      render :update do |page|
         page.replace  "completion-#{params[:id]}", :partial => 'completion', :locals => {:completion => completion}
         page.visual_effect :highlight, "completion-#{params[:id]}"
      end
    else
      render :update do |page|
        page.visual_effect :shake, 'head'
      end
    end
  end
  
  def toggle_scenario
    return unless request.post?
    scenario = Scenario.find(params[:id])
    if scenario.visible?
      scenario.visible = false
    else
      scenario.visible = true
    end
    if(scenario.save)
      render :update do |page|
         page.replace  "scenario-#{params[:id]}", :partial => 'scenario', :locals => {:scenario => scenario}
         page.visual_effect :highlight, "scenario-#{params[:id]}"
      end
    else
      render :update do |page|
        page.visual_effect :shake, 'head'
      end
    end
  end
  
end
