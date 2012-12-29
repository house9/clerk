ActiveRecord::Schema.define do
  self.verbose = false

  create_table :posts, :force => true do |t|
    t.string :title
    t.string :body
    t.integer :created_by_id
    t.integer :updated_by_id
    t.timestamps
  end

  create_table :foos, :force => true do |t|
    t.string :bar
    t.integer :user_id
    t.integer :updater_id
    t.timestamps
  end

  create_table :users, :force => true do |t|
    t.string :name
    t.integer :created_by_id
    t.integer :updated_by_id
    t.timestamps
  end
end