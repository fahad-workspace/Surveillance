class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :github_user_id
      t.string :github_user_login
      t.string :github_user_type

      t.timestamps null: false
    end
  end
end
