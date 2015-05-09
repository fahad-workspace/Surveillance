class CreateContributors < ActiveRecord::Migration
  def change
    create_table :contributors do |t|
      t.integer :total_contributions
      t.integer :recent_contributions
      t.integer :repository_id
      t.references :repository, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
