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

ActiveRecord::Schema.define(version: 20150508090955) do

  create_table "contributors", force: :cascade do |t|
    t.string "login", limit: 255
    t.integer "github_contributor_id", limit: 4
    t.string "type", limit: 255
    t.integer "total_contributions", limit: 4
    t.integer "recent_contributions", limit: 4
    t.integer "repository_id", limit: 4
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "issues", force: :cascade do |t|
    t.integer "github_issue_id", limit: 4
    t.integer "number", limit: 4
    t.string "title", limit: 255
    t.integer "issue_creator_id", limit: 4
    t.string "state", limit: 255
    t.integer "issue_assignee_id", limit: 4
    t.integer "milestone_id", limit: 4
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "closed_at"
  end

  create_table "issues_labels", id: false, force: :cascade do |t|
    t.integer "issue_id", limit: 4, null: false
    t.integer "label_id", limit: 4, null: false
  end

  create_table "labels", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "color", limit: 255
    t.integer "repository_id", limit: 4
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

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
    t.integer "milestone_creator_id", limit: 4
  end

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
    t.integer "repository_owner_id", limit: 4
  end

end
