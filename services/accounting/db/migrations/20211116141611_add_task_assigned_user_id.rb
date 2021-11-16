Hanami::Model.migration do
  change do
    alter_table :tasks do
      add_column :assigned_user_id, String
    end
  end
end
