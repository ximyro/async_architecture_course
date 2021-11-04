class AddFullName < ActiveRecord::Migration[6.1]
  def change
    change_table(:users) do |t|
      t.string :full_name, default: "", null: false
    end
  end
end
