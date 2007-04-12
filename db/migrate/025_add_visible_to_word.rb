class AddVisibleToWord < ActiveRecord::Migration
  def self.up
    add_column "words", "visible", :boolean, :default => false
  end

  def self.down
    remove_column "words", "visible"
  end
end
