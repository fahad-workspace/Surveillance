class CreateContributors < ActiveRecord::Migration
  def change
    create_table :contributors do |t|
      t.string :login
      t.integer :github_contributor_id
      t.string :type
      t.integer :total_contributions
      t.integer :recent_contributions
      t.integer :repository_id

      t.timestamps null: false
    end
  end
end
