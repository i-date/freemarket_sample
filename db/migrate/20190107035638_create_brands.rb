class CreateBrands < ActiveRecord::Migration[5.2]
  def change
    create_table :brands do |t|
      t.string :name
      t.references :brand_group, index: true
      t.timestamps
    end
  end
end
