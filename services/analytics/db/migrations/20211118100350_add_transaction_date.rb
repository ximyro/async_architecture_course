Hanami::Model.migration do
  change do
    alter_table :deposit_transactions do
      add_column :date, DateTime, null: false
    end

    alter_table :withdrawn_transactions do
      add_column :date, DateTime, null: false
    end
  end
end
