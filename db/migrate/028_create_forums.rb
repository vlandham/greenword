class CreateForums < ActiveRecord::Migration
  def self.up
    create_table :forums do |t|
      t.column :name,             :string
      t.column :description,      :string
      t.column :semester_id,      :integer
      t.column :topics_count,     :integer, :default => 0
      t.column :posts_count,      :integer, :default => 0
      t.column :position,         :integer
      t.column :description_html, :text
      t.column :forum_type,       :string
    end
  end

  def self.down
    drop_table :forums
  end
end
