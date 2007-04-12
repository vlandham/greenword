class AddPositionToCompletions < ActiveRecord::Migration
  def self.up
    remove_column "completions", "order"
    add_column "completions", "position", :integer
  end

  def self.down
    remove_column "completions", "position"
    add_column "completions", "order", :integer
    
  end
end
