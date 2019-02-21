class AddGrandparentReftoCategories < ActiveRecord::Migration[5.2]
  def change
    add_reference :categories, :grandparent, index: true
  end
end
