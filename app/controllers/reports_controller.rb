require 'csv'

class ReportsController < ApplicationController
  before_filter :set_semester
  
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
  
 
  
  def export_as_csv(report,name)
    report.rewind
    send_data(report.read,
      :type => 'text/csv; charset=iso-8859-1; header=present',
      :filename => "#{name}-report.csv")
  end
  
end
