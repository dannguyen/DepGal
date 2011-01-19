class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.string :title
      t.text :description
      t.string :source_path
      t.integer :rating

      t.timestamps
    end
  end

  def self.down
    drop_table :images
  end
end
