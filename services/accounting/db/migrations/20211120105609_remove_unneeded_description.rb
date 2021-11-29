Hanami::Model.migration do
  change do
    alter_table :deposit_transactions do
      drop_column :description
    end

    alter_table :withdraw_transactions do
      drop_column :description
    end
  end
end
