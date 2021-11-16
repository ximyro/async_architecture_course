Hanami::Model.migration do
  change do
    create_table :tasks do
      primary_key :id

      column :title,                 String
      column :description,           String
      foreign_key :user_id, :users, on_delete: :cascade
      column :public_id, String, null: false, unique: true
      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
