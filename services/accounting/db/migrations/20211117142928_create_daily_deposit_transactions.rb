Hanami::Model.migration do
  change do
    create_table :daily_deposit_transactions do
      primary_key :id
      column :reason, String, null: false, default: ''
      column :amount, 'decimal', null: false
      column :transaction_ids, 'integer[]', null: false
      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
