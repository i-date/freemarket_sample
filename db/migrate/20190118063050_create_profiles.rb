class CreateProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :profiles do |t|
      t.string :nickname
      t.text :body
      t.string :last_name
      t.string :first_name
      t.string :last_name_kana
      t.string :first_name_kana
      t.integer :birth_year
      t.integer :birth_month
      t.integer :birth_day
      t.integer :phone_number, unique: true
      t.integer :zipcode
      t.integer :prefecture
      t.string :city
      t.string :block
      t.string :building
      t.references :user, null: false, index: true, foreign_key: true
      t.timestamps
    end
  end
end
