class StatsController < ApplicationController
  require 'scruffy'
  before_filter :set_semester
  layout "admin"
  
  def forums
    @forums = @semester.forums
    
  end
  
  def students
  end
  
  def graph
    
    range = "created_at #{(12.months.ago.to_date..Date.today).to_s(:db)}"
    @posts = Post.count(:all, :group => "DATE_FORMAT(created_at, '%Y-%m')", :order =>"created_at ASC")
    months = (@posts.keys).sort
    
    keys = Hash[*months.collect {|v| [months.index(v),v.to_s] }.flatten]
    data = keys.collect {|k,v| @posts[v].nil? ? 0 : @posts[v]}
    
    graph = Scruffy::Graph.new(:title =>  "History", :theme => Scruffy::Themes::RubyBlog.new)
        graph << Scruffy::Layers::Line.new(:title =>  'John', 
                                          :points => data)
        graph << Scruffy::Layers::Line.new(:title =>  'Sara', :points =>
    [120, 50, -80, 20])

        send_data(graph.render(:width =>  600, :as => 'PNG'), :type =>
    'image/png', :disposition=>  'inline')
  end
  
end
