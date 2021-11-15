Hanami::Model.migration do
  change do
    create_table :users do
      primary_key :id

      column :full_name, String
      column :public_id, String, null: false, unique: true
      column :email, String, null: false, unique: true
      column :role, String, null: false
      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
