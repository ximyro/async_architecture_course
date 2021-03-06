Hanami::Model.migration do
  change do
    create_table :auth_identities do
      primary_key :id

      foreign_key :user_id, :users, on_delete: :cascade

      column :uid,                 String
      column :provider,            String, null: false
      column :login,               String, null: false
      column :token,               String

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
