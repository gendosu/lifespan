ActiveRecord::Migration.suppress_messages do
  ActiveRecord::Migration.create_table "articles", :force => true do |t|
    t.string "name"
    t.integer "user_id"

    t.datetime "start_at", null: false
    t.datetime "end_at"
  end

  ActiveRecord::Migration.create_table "users", :force => true do |t|
    t.string "name"
  end
end
