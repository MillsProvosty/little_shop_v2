class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :name
      t.boolean :active
      t.decimal :price
      t.text :description
      t.string :image, default: "https://picsum.photos/200/300"
      t.integer :inventory
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
