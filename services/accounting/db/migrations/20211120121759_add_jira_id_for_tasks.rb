Hanami::Model.migration do
  change do
    alter_table :tasks do
      add_column :jira_id, String, null: false, default: ''
    end
  end
end
