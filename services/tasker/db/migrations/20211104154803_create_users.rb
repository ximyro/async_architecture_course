Hanami::Model.migration do
  change do
    create_table :users do
      primary_key :id 

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
