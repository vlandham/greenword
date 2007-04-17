# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 36) do

  create_table "answers", :force => true do |t|
    t.column "user_id",     :integer
    t.column "type",        :string
    t.column "value",       :text
    t.column "question_id", :integer
    t.column "created_at",  :datetime
  end

  create_table "completions", :force => true do |t|
    t.column "value",       :string
    t.column "show",        :boolean
    t.column "test_set_id", :integer
    t.column "visible",     :boolean, :default => false
    t.column "position",    :integer
  end

  create_table "courses", :force => true do |t|
    t.column "section_id", :integer
    t.column "name",       :string
    t.column "number",     :string
  end

  create_table "forums", :force => true do |t|
    t.column "name",             :string
    t.column "description",      :string
    t.column "semester_id",      :integer
    t.column "topics_count",     :integer, :default => 0
    t.column "posts_count",      :integer, :default => 0
    t.column "position",         :integer
    t.column "description_html", :text
    t.column "forum_type",       :string
  end

  create_table "globalize_countries", :force => true do |t|
    t.column "code",                   :string, :limit => 2
    t.column "english_name",           :string
    t.column "date_format",            :string
    t.column "currency_format",        :string
    t.column "currency_code",          :string, :limit => 3
    t.column "thousands_sep",          :string, :limit => 2
    t.column "decimal_sep",            :string, :limit => 2
    t.column "currency_decimal_sep",   :string, :limit => 2
    t.column "number_grouping_scheme", :string
  end

  add_index "globalize_countries", ["code"], :name => "globalize_countries_code_index"

  create_table "globalize_languages", :force => true do |t|
    t.column "iso_639_1",             :string,  :limit => 2
    t.column "iso_639_2",             :string,  :limit => 3
    t.column "iso_639_3",             :string,  :limit => 3
    t.column "rfc_3066",              :string
    t.column "english_name",          :string
    t.column "english_name_locale",   :string
    t.column "english_name_modifier", :string
    t.column "native_name",           :string
    t.column "native_name_locale",    :string
    t.column "native_name_modifier",  :string
    t.column "macro_language",        :boolean
    t.column "direction",             :string
    t.column "pluralization",         :string
    t.column "scope",                 :string,  :limit => 1
  end

  add_index "globalize_languages", ["iso_639_1"], :name => "globalize_languages_iso_639_1_index"
  add_index "globalize_languages", ["iso_639_2"], :name => "globalize_languages_iso_639_2_index"
  add_index "globalize_languages", ["iso_639_3"], :name => "globalize_languages_iso_639_3_index"
  add_index "globalize_languages", ["rfc_3066"], :name => "globalize_languages_rfc_3066_index"

  create_table "globalize_translations", :force => true do |t|
    t.column "type",                :string
    t.column "tr_key",              :string
    t.column "table_name",          :string
    t.column "item_id",             :integer
    t.column "facet",               :string
    t.column "built_in",            :boolean, :default => true
    t.column "language_id",         :integer
    t.column "pluralization_index", :integer
    t.column "text",                :text
    t.column "namespace",           :string
  end

  add_index "globalize_translations", ["tr_key", "language_id"], :name => "globalize_translations_tr_key_index"
  add_index "globalize_translations", ["table_name", "item_id", "language_id"], :name => "globalize_translations_table_name_and_item_and_language"

  create_table "images", :force => true do |t|
    t.column "parent_id",    :integer
    t.column "forum_id",     :integer
    t.column "content_type", :string
    t.column "filename",     :string
    t.column "thumbnail",    :string
    t.column "size",         :integer
    t.column "width",        :integer
    t.column "height",       :integer
    t.column "created_at",   :datetime
    t.column "user_id",      :integer
    t.column "topic_id",     :integer
  end

  create_table "posts", :force => true do |t|
    t.column "user_id",    :integer
    t.column "topic_id",   :integer
    t.column "body",       :text
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "forum_id",   :integer
    t.column "body_html",  :text
  end

  create_table "scenarios", :force => true do |t|
    t.column "value",       :text
    t.column "show",        :boolean
    t.column "test_set_id", :integer
    t.column "visible",     :boolean, :default => false
  end

  create_table "sections", :force => true do |t|
    t.column "semester_id", :integer
    t.column "name",        :string
  end

  create_table "semesters", :force => true do |t|
    t.column "name",       :string
    t.column "created_on", :date
    t.column "freeze",     :boolean
    t.column "url",        :string
  end

  create_table "sessions", :force => true do |t|
    t.column "session_id", :string
    t.column "data",       :text
    t.column "updated_at", :datetime
  end

  add_index "sessions", ["session_id"], :name => "sessions_session_id_index"

  create_table "settings", :force => true do |t|
    t.column "var",        :string,   :default => "", :null => false
    t.column "value",      :text
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "test_sets", :force => true do |t|
    t.column "semester_id", :integer
    t.column "name",        :string
    t.column "language",    :string
  end

  create_table "topics", :force => true do |t|
    t.column "forum_id",     :integer
    t.column "user_id",      :integer
    t.column "title",        :string
    t.column "created_at",   :datetime
    t.column "updated_at",   :datetime
    t.column "hits",         :integer,  :default => 0
    t.column "sticky",       :integer,  :default => 0
    t.column "posts_count",  :integer,  :default => 0
    t.column "replied_at",   :datetime
    t.column "locked",       :boolean,  :default => false
    t.column "replied_by",   :integer
    t.column "last_post_id", :integer
  end

  create_table "users", :force => true do |t|
    t.column "first_name",                :string
    t.column "last_name",                 :string
    t.column "login",                     :string
    t.column "email",                     :string
    t.column "crypted_password",          :string,   :limit => 40
    t.column "salt",                      :string,   :limit => 40
    t.column "created_at",                :datetime
    t.column "updated_at",                :datetime
    t.column "remember_token",            :string
    t.column "remember_token_expires_at", :datetime
    t.column "admitted",                  :boolean,                :default => false
    t.column "admin",                     :boolean,                :default => false
    t.column "language",                  :string,                 :default => "en"
    t.column "course_id",                 :integer
    t.column "semester_id",               :integer
    t.column "posts_count",               :integer
    t.column "last_login_at",             :datetime
    t.column "last_seen_at",              :datetime
  end

  create_table "words", :force => true do |t|
    t.column "value",       :string
    t.column "show",        :boolean
    t.column "position",    :integer
    t.column "test_set_id", :integer
    t.column "visible",     :boolean, :default => false
  end

end
