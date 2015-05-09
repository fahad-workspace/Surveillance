class CreateMilestones < ActiveRecord::Migration
  def change
    create_table :milestones do |t|
      t.integer :github_milestone_id
      t.integer :number
      t.string :title
      t.integer :open_issues
      t.integer :closed_issues
      t.string :state
      t.datetime :created_at
      t.datetime :updated_at
      t.datetime :due_on
      t.datetime :closed_at
      t.references :repository, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
