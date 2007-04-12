class CreateAnswers < ActiveRecord::Migration
  def self.up
    create_table :answers do |t|
      t.column :user_id, :integer
      t.column :type, :string
      t.column :value, :text
      t.column :question_id, :integer
    end
  end

  def self.down
    drop_table :answers
  end
end
