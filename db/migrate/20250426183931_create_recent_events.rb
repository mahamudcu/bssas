class CreateRecentEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :recent_events do |t|
      t.string :title
      t.string :image
      t.text :description

      t.timestamps
    end
  end
end
