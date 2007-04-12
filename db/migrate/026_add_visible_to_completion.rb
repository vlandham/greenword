class AddVisibleToCompletion < ActiveRecord::Migration
  def self.up
    add_column "completions", "visible", :boolean, :default => false
    add_column "scenarios", "visible", :boolean, :default => false
  end

  def self.down
     remove_column "completions", "visible"
     remove_column "scenarios", "visible"
     
  end
end
