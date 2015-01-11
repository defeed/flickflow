class CreateFetches < ActiveRecord::Migration
  def change
    create_table :fetches do |t|
      t.references :fetchable, polymorphic: true
      t.integer :page

      t.timestamps
    end

    add_index :fetches, [:fetchable_id, :fetchable_type]
  end
end
