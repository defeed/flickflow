class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.references :movie, index: true
      t.string :kind
      t.string :title
      t.string :youtube_id

      t.timestamps
    end
  end
end
