class AddOptionsToBrands < ActiveRecord::Migration[5.2]
  def change
    change_column_null :brands, :name, false
    add_foreign_key :brands, :brand_groups, column: :brand_group_id
  end
end
