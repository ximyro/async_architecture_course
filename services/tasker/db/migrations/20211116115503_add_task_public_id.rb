Hanami::Model.migration do
  change do
    execute 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp"'
    execute 'CREATE EXTENSION IF NOT EXISTS "pgcrypto"'

    alter_table :tasks do
      add_column :public_id, 'uuid', default: Hanami::Model::Sql.function(:gen_random_uuid), null: false, unique: true
    end
  end
end
