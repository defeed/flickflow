class CreateFetches < ActiveRecord::Migration
  def change
    create_table :fetches do |t|
      t.references :fetchable, polymorphic: true
      t.integer :response_code
      t.string  :response_message
      t.boolean :has_data, default: false 

      t.timestamps
    end
    
    add_index :fetches, [:fetchable_id, :fetchable_type]
  end
end
