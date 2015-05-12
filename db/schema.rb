# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150509160233) do

  create_table "contributors", force: :cascade do |t|
    t.integer "total_contributions", limit: 4
    t.integer "recent_contributions", limit: 4
    t.integer "repository_id", limit: 4
    t.integer "user_id", limit: 4
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "contributors", ["repository_id"], name: "index_contributors_on_repository_id", using: :btree
  add_index "contributors", ["user_id"], name: "index_contributors_on_user_id", using: :btree

  create_table "issue_labels", force: :cascade do |t|
    t.integer "issue_id", limit: 4
    t.integer "label_id", limit: 4
    t.integer "repository_id", limit: 4
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "issue_labels", ["issue_id"], name: "index_issue_labels_on_issue_id", using: :btree
  add_index "issue_labels", ["label_id"], name: "index_issue_labels_on_label_id", using: :btree
  add_index "issue_labels", ["repository_id"], name: "index_issue_labels_on_repository_id", using: :btree

  create_table "issues", force: :cascade do |t|
    t.integer "github_issue_id", limit: 4
    t.integer "number", limit: 4
    t.string "title", limit: 255
    t.string "state", limit: 255
    t.integer "issue_assignee_id", limit: 4
    t.integer "milestone_id", limit: 4
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "closed_at"
    t.integer "repository_id", limit: 4
    t.integer "user_id", limit: 4
  end

  add_index "issues", ["repository_id"], name: "index_issues_on_repository_id", using: :btree
  add_index "issues", ["user_id"], name: "index_issues_on_user_id", using: :btree

  create_table "labels", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "color", limit: 255
    t.integer "repository_id", limit: 4
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "labels", ["repository_id"], name: "index_labels_on_repository_id", using: :btree

  create_table "milestones", force: :cascade do |t|
    t.integer "github_milestone_id", limit: 4
    t.integer "number", limit: 4
    t.string "title", limit: 255
    t.integer "open_issues", limit: 4
    t.integer "closed_issues", limit: 4
    t.string "state", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "due_on"
    t.datetime "closed_at"
    t.integer "repository_id", limit: 4
    t.integer "user_id", limit: 4
  end

  add_index "milestones", ["repository_id"], name: "index_milestones_on_repository_id", using: :btree
  add_index "milestones", ["user_id"], name: "index_milestones_on_user_id", using: :btree

  create_table "repositories", force: :cascade do |t|
    t.integer "github_repository_id", limit: 4
    t.string "name", limit: 255
    t.string "full_name", limit: 255
    t.boolean "private", limit: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "pushed_at"
    t.string "language", limit: 255
    t.boolean "has_issues", limit: 1
    t.integer "open_issues_count", limit: 4
    t.integer "subscribers_count", limit: 4
    t.integer "user_id", limit: 4
  end

  add_index "repositories", ["user_id"], name: "index_repositories_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.integer "github_user_id", limit: 4
    t.string "github_user_login", limit: 255
    t.string "github_user_type", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "contributors", "repositories"
  add_foreign_key "contributors", "users"
  add_foreign_key "issue_labels", "issues"
  add_foreign_key "issue_labels", "labels"
  add_foreign_key "issue_labels", "repositories"
  add_foreign_key "issues", "repositories"
  add_foreign_key "issues", "users"
  add_foreign_key "labels", "repositories"
  add_foreign_key "milestones", "repositories"
  add_foreign_key "milestones", "users"
  add_foreign_key "repositories", "users"
end
