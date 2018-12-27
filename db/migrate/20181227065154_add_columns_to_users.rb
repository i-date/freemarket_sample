class AddColumnsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :nickname,        :string,  null: false, default: ''
    add_column :users, :profile,         :text
    add_column :users, :last_name,       :string,  null: false, default: ''
    add_column :users, :first_name,      :string,  null: false, default: ''
    add_column :users, :last_name_kana,  :string,  null: false, default: ''
    add_column :users, :first_name_kana, :string,  null: false, default: ''
    add_column :users, :birth_year,      :integer, null: false, default: '00'
    add_column :users, :birth_month,     :integer, null: false, default: '00'
    add_column :users, :birth_day,       :integer, null: false, default: '00'
    add_column :users, :phone_number,    :integer, unique: true
  end
end
