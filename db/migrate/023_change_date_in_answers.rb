class ChangeDateInAnswers < ActiveRecord::Migration
  def self.up
    remove_column "answers", "created_on"
    add_column "answers", "created_at", :datetime
  end

  def self.down
        remove_column "answers", "created_at"
        add_column "answers", "created_on", :date
  end
end
