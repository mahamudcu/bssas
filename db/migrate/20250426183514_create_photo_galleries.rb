class CreatePhotoGalleries < ActiveRecord::Migration[5.2]
  def change
    create_table :photo_galleries do |t|
      t.string :title
      t.string :image
      t.text :description

      t.timestamps
    end
  end
end
