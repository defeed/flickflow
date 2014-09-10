class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :type
      t.string :file
      t.references :imageable, polymorphic: true, index: true
      t.string :remote_url, index: true
      t.boolean :is_primary, default: false
      t.uuid :uuid

      t.timestamps
    end
  end
end
