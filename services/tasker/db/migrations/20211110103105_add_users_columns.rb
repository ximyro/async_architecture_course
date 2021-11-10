Hanami::Model.migration do
  change do
    alter_table :users do
      add_column :full_name, String
      add_column :public_id, String, null: false, unique: true
      add_column :email, String, null: false, unique: true
      add_column :role, String, null: false
    end
  end
end
