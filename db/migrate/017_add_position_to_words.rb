class AddPositionToWords < ActiveRecord::Migration
  def self.up
    remove_column "words", "order"
    add_column "words", "position", :integer
    
  end

  def self.down
    remove_column "words", "position"
    add_column "words", "order", :integer
  end
end
