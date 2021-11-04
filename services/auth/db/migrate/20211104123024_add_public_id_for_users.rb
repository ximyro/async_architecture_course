class AddPublicIdForUsers < ActiveRecord::Migration[6.1]
  def change
    enable_extension "pgcrypto"
    change_table(:users) do |t|
      t.uuid :public_id, default: "gen_random_uuid()", null: false
    end
  end
end
