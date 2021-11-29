Hanami::Model.migration do
  change do
    alter_table :deposit_transactions do
      add_column :reason, String, null: false, default: ''
      add_column :description, String, null: false, default: ''
    end

    alter_table :withdraw_transactions do
      add_column :reason, String, null: false, default: ''
      add_column :description, String, null: false, default: ''
    end
  end
end
