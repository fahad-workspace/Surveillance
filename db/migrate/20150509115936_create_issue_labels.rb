class CreateIssueLabels < ActiveRecord::Migration
  def change
    create_table :issue_labels do |t|
      t.references :issue, index: true, foreign_key: true
      t.references :label, index: true, foreign_key: true
      t.references :repository, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
