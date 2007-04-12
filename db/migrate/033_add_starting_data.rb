class AddStartingData < ActiveRecord::Migration
  def self.up
    User.create( :first_name => "Admin", :last_name => "Admin", :login => "admin@ku.edu", 
                 :email => "admin@ku.edu", :password => "password", :admitted => 1, :admin => 1
                 :semester_id => 1)
    Semester.create( :name => "First Semester", :freeze => 0)
  end

  def self.down
    
  end
end
