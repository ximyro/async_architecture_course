Hanami::Model.migration do
  change do
    create_table :daily_deposit_transactions do
      primary_key :id
      column :reason, String, null: false, default: ''
      column :amount, 'decimal', null: false
      column :transaction_ids, 'integer[]', null: false
      foreign_key :user_id, :users
      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
