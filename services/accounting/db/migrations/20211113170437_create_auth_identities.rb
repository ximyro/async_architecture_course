Hanami::Model.migration do
  change do
    create_table :auth_identities do
      primary_key :id

      column :uid,                 String
      column :provider,            String, null: false
      column :login,               String, null: false
      column :token,               String
      foreign_key :user_id, :users, on_delete: :cascade

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
