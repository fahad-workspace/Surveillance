class CreateLabels < ActiveRecord::Migration
  def change
    create_table :labels do |t|
      t.string :name
      t.string :color
      t.references :repository, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
