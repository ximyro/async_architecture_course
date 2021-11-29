Hanami::Model.migration do
  change do
    alter_table :users do
      add_column :balance, 'decimal', null: false, default: 0
    end
  end
end
