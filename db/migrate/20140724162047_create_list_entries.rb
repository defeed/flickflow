class CreateListEntries < ActiveRecord::Migration
  def change
    create_table :list_entries do |t|
      t.references :list
      t.references :listable, polymorphic: true

      t.timestamps
    end
    
    add_index :list_entries, [:list_id, :listable_id, :listable_type], unique: true
  end
end
