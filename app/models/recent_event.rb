class RecentEvent < ApplicationRecord
  mount_uploader :image, AvatarUploader
end
