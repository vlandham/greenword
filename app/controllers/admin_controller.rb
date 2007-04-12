class AdminController < ApplicationController
  before_filter :admin_login_required
  before_filter :set_locale
  before_filter :set_semester
  
  def index
  end

  def translate
    Locale.set('es-CR')
    @view_translations = ViewTranslation.find(:all, 
                :conditions => [ 'text IS NULL AND language_id = ?', Locale.language.id ], 
                :order => 'tr_key')
   @all_translations = ViewTranslation.find(:all, 
                :conditions => ['language_id = ?', Locale.language.id],
                :order => 'text')
  end
  
  def translation_text
    @translation = ViewTranslation.find(params[:id])
    render :text => @translation.text || ""  
  end
  
  def set_translation_text
    @translation = ViewTranslation.find(params[:id])
    previous = @translation.text
    @translation.text = params[:value]
    @translation.text = previous unless @translation.save
    render :partial => "translation_text", :object => @translation.text  
  end
  
  def user
    
  end
  
  def test
    @semester = Semester.find(1)
    @tests = @semester.tests.find(:all)
  end
  
  def edit_test
    @test = params[:id]
  end
  
  
  
end
