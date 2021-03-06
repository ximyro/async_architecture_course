Hanami::Model.migration do
  change do
    create_table :deposit_transactions do
      primary_key :id

      foreign_key :user_id, :users
      foreign_key :task_id, :tasks
      column :amount, 'decimal', null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
