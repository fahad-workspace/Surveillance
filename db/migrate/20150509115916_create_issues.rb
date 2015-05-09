class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.integer :github_issue_id
      t.integer :number
      t.string :title
      t.string :state
      t.integer :issue_assignee_id
      t.integer :milestone_id
      t.datetime :created_at
      t.datetime :updated_at
      t.datetime :closed_at
      t.references :repository, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
