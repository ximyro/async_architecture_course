Hanami::Model.migration do
  change do
    create_table :daily_management_statistics do
      primary_key :id
      column :date, Date, null: false
      column :earn, 'decimal', null: false
      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
