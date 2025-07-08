class CreateVideos < ActiveRecord::Migration[7.1]
  def change
    create_table :videos do |t|
      t.string :title
      t.text :description
      t.string :genre
      t.integer :release_year
      t.string :thumbnail
      t.string :video_url

      t.timestamps
    end
  end
end
