Hanami::Model.migration do
  change do
    extension :pg_enum
    create_enum :task_statuses, %w(created completed)

    alter_table :tasks do
      add_column :status, 'task_statuses', null: false, default: 'created'
    end
  end
end
