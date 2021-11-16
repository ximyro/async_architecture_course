Hanami::Model.migration do
  change do
    create_table :tasks do
      primary_key :id

      column :title,                 String
      column :description,           String
      column :status,           String
      column :public_id, String, null: false, unique: true
      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
