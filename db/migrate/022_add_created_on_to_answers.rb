class AddCreatedOnToAnswers < ActiveRecord::Migration
  def self.up
    add_column "answers", "created_on", :date
  end

  def self.down
    remove_column "answers", "created_on"
  end
end
