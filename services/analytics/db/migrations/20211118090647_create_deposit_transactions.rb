Hanami::Model.migration do
  change do
    create_table :deposit_transactions do
      primary_key :id

      column :task_public_id, String, null: false
      column :user_public_id, String, null: false
      column :amount, 'decimal', null: false, default: 0
      column :reason, String, null: false, default: ''
      column :description, String

      column :created_at, DateTime, null: false, index: true
      column :updated_at, DateTime, null: false
    end
  end
end
