class AddColumnToCredit < ActiveRecord::Migration[5.2]
  def change
    add_column :credits, :payjp_token, :string
  end
end
