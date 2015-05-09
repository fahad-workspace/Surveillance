class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.integer :github_repository_id
      t.string :name
      t.string :full_name
      t.boolean :private
      t.datetime :created_at
      t.datetime :updated_at
      t.datetime :pushed_at
      t.string :language
      t.boolean :has_issues
      t.integer :open_issues_count
      t.integer :subscribers_count
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
