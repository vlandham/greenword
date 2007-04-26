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
  
  def show
    type = params[:type]
    @item
    @answers
    @hash_ans
    case(type)
    when 'word'
      @item = Word.find(params[:id])
      @answers = @item.word_answers
    when 'comp'
      @item = Completion.find(params[:id])
      @answers = @item.completion_answers
    when 'sen'
      @item = Scenario.find(params[:id])
      @answers = @item.scenario_answers
    end
    @hash_ans = split_into_hash_of_arrays(@answers) { |ans| ans.user } 
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
  
  def split_into_hash_of_arrays(arry)
    hash = Hash.new
    for element in arry
      expr = yield(element)
      if not hash.has_key? expr
        hash[expr] = []
      end
      hash[expr].push element
    end
    hash
  end
  
end
