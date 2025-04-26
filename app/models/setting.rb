class Setting < ApplicationRecord
  mount_uploader :logo, AvatarUploader
end
