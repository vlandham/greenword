require 'csv'

# ReportsController handles output to csv.  This controller has no views associated with it as the end product of each method is the creation of a csv file.  
class ReportsController < ApplicationController
  before_filter :set_semester
  
# Returns csv of the content, size, user - full name, and creation date for each post for a particular topic
  def topic_report
      topic = Topic.find(params[:id])
      @posts = topic.posts.find(:all, :order => "created_at DESC")
      report = StringIO.new
      CSV::Writer.generate(report, ',') do |csv|
        csv << %w(body size user date)
        @posts.each do |post|
          csv << [post.body, post.size, post.user.whole_name, post.created_at]
        end
      end
      export_as_csv(report,topic.title)      
  end

# Returns csv of content, size, and creation date for all posts sent from a specific user
  def student_forum_report
    @user = User.find(params[:id])
    @posts = @user.posts.find(:all, :order => "created_at DESC")
    
    report = StringIO.new
    CSV::Writer.generate(report, ',') do |csv|
      csv << %w(body size date)
      @posts.each do |post|
        csv << [post.body, post.size, post.created_at]
      end
    end
    export_as_csv(report,@user.whole_name+"-forum")
  end
  
# Returns csv of all words, word answers, situations, situations answers, scenarios, scenario answers, and posts for a particular user. 
  def student_all_report
    @user = User.find(params[:id])
    report = StringIO.new
      CSV::Writer.generate(report, ',') do |csv|
      #Get Words
      @words = @user.word_answers.find(:all, :order => "question_id ASC")
      csv << %w(question answer date)
      @words.each do |answer|
        csv << [answer.word.value, answer.value, answer.created_at]
      end
      #Get Situations
      @situation_answers = @user.completion_answers.find(:all, :order => "question_id ASC")
      @situation_answers.each do |answer|
        csv << [answer.completion.value, answer.value, answer.created_at]
      end
      #Get Scenarios
      @scenario_answers = @user.scenario_answers.find(:all, :order => "question_id ASC")
      @scenario_answers.each do |answer|
        csv << [answer.scenario.value, answer.value, answer.created_at]
      end
    
      #Get posts
      @posts = @user.posts.find(:all, :order => "created_at DESC")
      @posts.each do |post|
        csv << [post.topic.title, post.body, post.created_at]
      end
    end
    export_as_csv(report,@user.whole_name+"-all")
  end
  
# base function used by all report functions.  Actually creates the csv file and sends it to the browser
  def export_as_csv(report,name)
    report.rewind
    send_data(report.read,
      :type => 'text/csv; charset=iso-8859-1; header=present',
      :filename => "#{name}-report.csv")
  end
  
end
