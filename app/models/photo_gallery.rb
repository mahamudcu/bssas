class PhotoGallery < ApplicationRecord
  mount_uploader :image, AvatarUploader
end
