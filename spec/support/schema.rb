ActiveRecord::Schema.define do
  self.verbose = false

  create_table :posts, :force => true do |t|
    t.string :title
    t.string :body
    t.integer :created_by_id
    t.integer :updated_by_id
    t.timestamps
  end
end