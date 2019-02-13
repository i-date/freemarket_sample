class Image < ApplicationRecord
  belongs_to :item

  mount_uploader :name, ImageUploader

  validates :name, presence: true
  validates :item_id, presence: true
end
