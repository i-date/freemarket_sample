class Category < ApplicationRecord
  has_many :items
  # parent-children
  has_many :children, class_name: "Category", foreign_key: "parent_id", dependent: :destroy
  belongs_to :parent, class_name: "Category", foreign_key: "parent_id", optional: true
  # grandparent-grandchildren
  has_many :grandchildren, class_name: "Category", foreign_key: "grandparent_id"
  belongs_to :grandparent, class_name: "Category", foreign_key: "grandparent_id", optional: true
end
