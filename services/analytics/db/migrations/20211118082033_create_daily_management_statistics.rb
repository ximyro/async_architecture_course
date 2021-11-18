Hanami::Model.migration do
  change do
    create_table :daily_management_statistics do
      primary_key :id
      column :date, Date, null: false, uniq: true, index: true
      column :earned, 'decimal', null: false, default: 0
      column :employee_with_debt, :integer, null: false, default: 0
      column :most_expensive_task_public_id, String, null: false, default: ''
      column :most_expensive_task_cost, 'decimal', null: false, default: 0
      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
