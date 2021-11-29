Hanami::Model.migration do
  change do
    alter_table :tasks do
      add_column :assignment_fee, 'decimal', null: false, default: 0.0
      add_column :amount, 'decimal', null: false, default: 0.0
    end
  end
end
