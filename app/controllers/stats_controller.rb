class StatsController < ApplicationController
  require 'gruff'
  before_filter :set_semester
  layout "admin"
  
  def forums
    @forums = @semester.forums
    
  end
  
  def student_graph
    
    student = User.find(params[:id])
    if student
      g = Gruff::Line.new('580x210')
      g.theme = {
         :colors => ['#ff6600', '#3bb000', '#1e90ff', '#efba00', '#0aaafd'],
         :marker_color => '#aaaaaa',
         :background_colors => ['#eaeaea', '#ffffff']
       }

      g.hide_title = true
      g.hide_legend = true
      g.font = File.expand_path('fonts/Vera.ttf', RAILS_ROOT)
    
      range = "created_at #{(30.days.ago.to_date..Date.today).to_s(:db)}"
  
      @posts = student.posts.count(:all, :conditions => range,
                :group => "DATE_FORMAT(created_at, '%m-%d')", :order =>"created_at ASC")
                
      # Take the union of all keys & convert into a hash {1 => "month", 2 => "month2"...}
      # - This will be the x-axis.. representing the date range
      days = (@posts.keys).sort
      keys = Hash[*days.collect {|v| [days.index(v),v.to_s] }.flatten]

      # Plot the data - insert 0's for missing keys
      g.data("Posts", keys.collect {|k,v| @posts[v].nil? ? 0 : @posts[v]})
      
      g.labels = keys
      g.x_axis_label = nil
      send_data(g.to_blob, :disposition => 'inline', :type => 'image/png', :filename => "forum-stats.png")
    end
  end
  

  
  def forum_stats
      g = Gruff::Line.new('580x210')
      g.theme = {
         :colors => ['#ff6600', '#3bb000', '#1e90ff', '#efba00', '#0aaafd'],
         :marker_color => '#aaaaaa',
         :background_colors => ['#eaeaea', '#ffffff']
       }

      g.hide_title = true
      # g.hide_legend = true
      g.font = File.expand_path('fonts/Vera.ttf', RAILS_ROOT)
      
      range = "created_at #{(30.days.ago.to_date..Date.today).to_s(:db)}"
      # @posts
      # if(params[:forum] == 'dis')
        @posts = Forum.find_discussion.posts.count(:all, :conditions => range,
                :group => "DATE_FORMAT(created_at, '%m-%d')", :order =>"created_at ASC")
      # else
        # @posts = Forum.find_photo.posts.count(:all, :conditions => range, :group => "DATE_FORMAT(created_at, '%m-%d')", :order =>"created_at ASC")
      # end
      
      @gallery_posts = Forum.find_photo.posts.count(:all, :conditions => range, 
              :group => "DATE_FORMAT(created_at, '%m-%d')", :order =>"created_at ASC")
      # @votes = Vote.count(:all, :conditions => range, :group => "DATE_FORMAT(created_at, '%Y-%m')", :order =>"created_at ASC")
      # @bookmarks = Bookmark.count(:all, :conditions => range, :group => "DATE_FORMAT(created_at, '%Y-%m')", :order =>"created_at ASC")

      # Take the union of all keys & convert into a hash {1 => "month", 2 => "month2"...}
      # - This will be the x-axis.. representing the date range
      days = (@posts.keys | @gallery_posts.keys).sort
      keys = Hash[*days.collect {|v| [days.index(v),v.to_s] }.flatten]

      # Plot the data - insert 0's for missing keys
      g.data("Discussion", keys.collect {|k,v| @posts[v].nil? ? 0 : @posts[v]})
      g.data("Gallery", keys.collect {|k,v| @gallery_posts[v].nil? ? 0 : @gallery_posts[v]})
      # g.data("Votes", keys.collect {|k,v| @votes[v].nil? ? 0 : @votes[v]})
      # g.data("Bookmarks", keys.collect {|k,v| @bookmarks[v].nil? ? 0 : @bookmarks[v]})

      g.labels = keys
      g.x_axis_label = nil
      send_data(g.to_blob, :disposition => 'inline', :type => 'image/png', :filename => "forum-stats.png")
    end
    
    def language_chart
      forum = Forum.find(params[:id])
      if(forum)
        g = Gruff::Pie.new('580x210')
         g.theme = {
            :colors => ['#ff6600', '#3bb000', '#1e90ff', '#efba00', '#0aaafd'],
            :marker_color => '#aaaaaa',
            :background_colors => ['#eaeaea', '#ffffff']
          }

         g.hide_title = true
         # g.hide_legend = true
         g.font = File.expand_path('fonts/Vera.ttf', RAILS_ROOT)

         # Plot the data - insert 0's for missing keys
         g.data("Discussion", keys.collect {|k,v| @posts[v].nil? ? 0 : @posts[v]})
         g.data("Gallery", keys.collect {|k,v| @gallery_posts[v].nil? ? 0 : @gallery_posts[v]})

         g.labels = keys
         g.x_axis_label = nil
         send_data(g.to_blob, :disposition => 'inline', :type => 'image/png', :filename => "forum-stats.png")
      end
       
    end
    
    def test_graph
      g = Gruff::Line.new
      g.title = "My Graph" 

      g.data("Apples", [1, 2, 3, 4, 4, 3])
      g.data("Oranges", [4, 8, 7, 9, 8, 9])
      g.data("Watermelon", [2, 3, 1, 5, 6, 8])
      g.data("Peaches", [9, 9, 10, 8, 7, 9])

      g.labels = {0 => '2003', 2 => '2004', 4 => '2005'}
      send_data(g.to_blob, :disposition => 'inline', :type => 'image/png', :filename => "test.png")
      
    end
  
end
