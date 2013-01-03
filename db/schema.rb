# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20080806141847) do

  create_table "collections", :force => true do |t|
    t.integer  "contributor_id",    :limit => 11
    t.integer  "last_editor_id",    :limit => 11
    t.integer  "latest_file_id",    :limit => 11
    t.integer  "current_status",    :limit => 11
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "admin_notes"
    t.string   "project_name"
    t.string   "project_url"
    t.string   "default_thumbnail"
    t.integer  "classification",    :limit => 10, :precision => 10, :scale => 0
  end

  create_table "editorial_board_members", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "classification", :limit => 10, :precision => 10, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "uploaded_files", :force => true do |t|
    t.string   "original_name"
    t.string   "received_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "state",                                                                  :default => "passive"
    t.datetime "deleted_at"
    t.string   "real_name"
    t.string   "institution"
    t.integer  "role",                      :limit => 11
    t.integer  "disabled",                  :limit => 10, :precision => 10, :scale => 0
  end

end
