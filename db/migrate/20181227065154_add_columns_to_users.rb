class AddColumnsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :nickname, :string,  null: false, default: '', after: :id
  end
end
