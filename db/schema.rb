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

ActiveRecord::Schema.define(version: 20180405152727) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"
  enable_extension "postgis_topology"
  enable_extension "fuzzystrmatch"
  enable_extension "postgis_tiger_geocoder"
  enable_extension "uuid-ossp"

  create_table "addr", primary_key: "gid", force: :cascade do |t|
    t.bigint  "tlid"
    t.string  "fromhn",    limit: 12
    t.string  "tohn",      limit: 12
    t.string  "side",      limit: 1
    t.string  "zip",       limit: 5
    t.string  "plus4",     limit: 4
    t.string  "fromtyp",   limit: 1
    t.string  "totyp",     limit: 1
    t.integer "fromarmid"
    t.integer "toarmid"
    t.string  "arid",      limit: 22
    t.string  "mtfcc",     limit: 5
    t.string  "statefp",   limit: 2
    t.index ["tlid", "statefp"], name: "idx_tiger_addr_tlid_statefp", using: :btree
    t.index ["zip"], name: "idx_tiger_addr_zip", using: :btree
  end

# Could not dump table "addrfeat" because of following StandardError
#   Unknown type 'geometry' for column 'the_geom'

  create_table "admins", force: :cascade do |t|
    t.string   "email",              default: "", null: false
    t.integer  "sign_in_count",      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "failed_attempts",    default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "full_name"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "encrypted_password", default: "", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true, using: :btree
    t.index ["uid"], name: "index_admins_on_uid", unique: true, using: :btree
    t.index ["unlock_token"], name: "index_admins_on_unlock_token", unique: true, using: :btree
  end

  create_table "apps", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "name",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "auth_secret", null: false
  end

  create_table "assignments", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "split_id",                                null: false
    t.uuid     "visitor_id",                              null: false
    t.string   "variant",                                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "individually_overridden", default: false, null: false
    t.string   "mixpanel_result"
    t.uuid     "bulk_assignment_id"
    t.uuid     "visitor_supersession_id"
    t.string   "context"
    t.index ["bulk_assignment_id"], name: "index_assignments_on_bulk_assignment_id", using: :btree
    t.index ["split_id", "visitor_id"], name: "index_assignments_on_split_id_and_visitor_id", unique: true, using: :btree
    t.index ["split_id"], name: "index_assignments_on_split_id", using: :btree
    t.index ["visitor_id"], name: "index_assignments_on_visitor_id", using: :btree
    t.index ["visitor_supersession_id"], name: "index_assignments_on_visitor_supersession_id", using: :btree
  end

# Could not dump table "bg" because of following StandardError
#   Unknown type 'geometry' for column 'the_geom'

  create_table "bulk_assignments", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.integer  "admin_id",   null: false
    t.string   "reason",     null: false
    t.uuid     "split_id",   null: false
    t.string   "variant",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

# Could not dump table "county" because of following StandardError
#   Unknown type 'geometry' for column 'the_geom'

  create_table "county_lookup", primary_key: ["st_code", "co_code"], force: :cascade do |t|
    t.integer "st_code",            null: false
    t.string  "state",   limit: 2
    t.integer "co_code",            null: false
    t.string  "name",    limit: 90
    t.index "soundex((name)::text)", name: "county_lookup_name_idx", using: :btree
    t.index ["state"], name: "county_lookup_state_idx", using: :btree
  end

  create_table "countysub_lookup", primary_key: ["st_code", "co_code", "cs_code"], force: :cascade do |t|
    t.integer "st_code",            null: false
    t.string  "state",   limit: 2
    t.integer "co_code",            null: false
    t.string  "county",  limit: 90
    t.integer "cs_code",            null: false
    t.string  "name",    limit: 90
    t.index "soundex((name)::text)", name: "countysub_lookup_name_idx", using: :btree
    t.index ["state"], name: "countysub_lookup_state_idx", using: :btree
  end

# Could not dump table "cousub" because of following StandardError
#   Unknown type 'geometry' for column 'the_geom'

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "direction_lookup", primary_key: "name", id: :string, limit: 20, force: :cascade do |t|
    t.string "abbrev", limit: 3
    t.index ["abbrev"], name: "direction_lookup_abbrev_idx", using: :btree
  end

# Could not dump table "edges" because of following StandardError
#   Unknown type 'geometry' for column 'the_geom'

# Could not dump table "faces" because of following StandardError
#   Unknown type 'geometry' for column 'the_geom'

  create_table "featnames", primary_key: "gid", force: :cascade do |t|
    t.bigint "tlid"
    t.string "fullname",   limit: 100
    t.string "name",       limit: 100
    t.string "predirabrv", limit: 15
    t.string "pretypabrv", limit: 50
    t.string "prequalabr", limit: 15
    t.string "sufdirabrv", limit: 15
    t.string "suftypabrv", limit: 50
    t.string "sufqualabr", limit: 15
    t.string "predir",     limit: 2
    t.string "pretyp",     limit: 3
    t.string "prequal",    limit: 2
    t.string "sufdir",     limit: 2
    t.string "suftyp",     limit: 3
    t.string "sufqual",    limit: 2
    t.string "linearid",   limit: 22
    t.string "mtfcc",      limit: 5
    t.string "paflag",     limit: 1
    t.string "statefp",    limit: 2
    t.index "lower((name)::text)", name: "idx_tiger_featnames_lname", using: :btree
    t.index "soundex((name)::text)", name: "idx_tiger_featnames_snd_name", using: :btree
    t.index ["tlid", "statefp"], name: "idx_tiger_featnames_tlid_statefp", using: :btree
  end

  create_table "geocode_settings", primary_key: "name", id: :text, force: :cascade do |t|
    t.text "setting"
    t.text "unit"
    t.text "category"
    t.text "short_desc"
  end

  create_table "geocode_settings_default", primary_key: "name", id: :text, force: :cascade do |t|
    t.text "setting"
    t.text "unit"
    t.text "category"
    t.text "short_desc"
  end

  create_table "identifier_types", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "name"
    t.uuid     "owner_app_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name"], name: "index_identifier_types_on_name", unique: true, using: :btree
    t.index ["owner_app_id"], name: "index_identifier_types_on_owner_app_id", using: :btree
  end

  create_table "identifiers", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "visitor_id",         null: false
    t.uuid     "identifier_type_id", null: false
    t.string   "value",              null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["identifier_type_id"], name: "index_identifiers_on_identifier_type_id", using: :btree
    t.index ["value"], name: "index_identifiers_on_value", using: :btree
    t.index ["visitor_id"], name: "index_identifiers_on_visitor_id", using: :btree
  end

  create_table "loader_lookuptables", primary_key: "lookup_name", id: :text, comment: "This is the table name to inherit from and suffix of resulting output table -- how the table will be named --  edges here would mean -- ma_edges , pa_edges etc. except in the case of national tables. national level tables have no prefix", force: :cascade do |t|
    t.integer "process_order",                   default: 1000,  null: false
    t.text    "table_name",                                                   comment: "suffix of the tables to load e.g.  edges would load all tables like *edges.dbf(shp)  -- so tl_2010_42129_edges.dbf .  "
    t.boolean "single_mode",                     default: true,  null: false
    t.boolean "load",                            default: true,  null: false, comment: "Whether or not to load the table.  For states and zcta5 (you may just want to download states10, zcta510 nationwide file manually) load your own into a single table that inherits from tiger.states, tiger.zcta5.  You'll get improved performance for some geocoding cases."
    t.boolean "level_county",                    default: false, null: false
    t.boolean "level_state",                     default: false, null: false
    t.boolean "level_nation",                    default: false, null: false, comment: "These are tables that contain all data for the whole US so there is just a single file"
    t.text    "post_load_process"
    t.boolean "single_geom_mode",                default: false
    t.string  "insert_mode",           limit: 1, default: "c",   null: false
    t.text    "pre_load_process"
    t.text    "columns_exclude",                                              comment: "List of columns to exclude as an array. This is excluded from both input table and output table and rest of columns remaining are assumed to be in same order in both tables. gid, geoid,cpi,suffix1ce are excluded if no columns are specified.",                              array: true
    t.text    "website_root_override",                                        comment: "Path to use for wget instead of that specified in year table.  Needed currently for zcta where they release that only for 2000 and 2010"
  end

  create_table "loader_platform", primary_key: "os", id: :string, limit: 50, force: :cascade do |t|
    t.text "declare_sect"
    t.text "pgbin"
    t.text "wget"
    t.text "unzip_command"
    t.text "psql"
    t.text "path_sep"
    t.text "loader"
    t.text "environ_set_command"
    t.text "county_process_command"
  end

  create_table "loader_variables", primary_key: "tiger_year", id: :string, limit: 4, force: :cascade do |t|
    t.text "website_root"
    t.text "staging_fold"
    t.text "data_schema"
    t.text "staging_schema"
  end

  create_table "pagc_gaz", force: :cascade do |t|
    t.integer "seq"
    t.text    "word"
    t.text    "stdword"
    t.integer "token"
    t.boolean "is_custom", default: true, null: false
  end

  create_table "pagc_lex", force: :cascade do |t|
    t.integer "seq"
    t.text    "word"
    t.text    "stdword"
    t.integer "token"
    t.boolean "is_custom", default: true, null: false
  end

  create_table "pagc_rules", force: :cascade do |t|
    t.text    "rule"
    t.boolean "is_custom", default: true
  end

# Could not dump table "place" because of following StandardError
#   Unknown type 'geometry' for column 'the_geom'

  create_table "place_lookup", primary_key: ["st_code", "pl_code"], force: :cascade do |t|
    t.integer "st_code",            null: false
    t.string  "state",   limit: 2
    t.integer "pl_code",            null: false
    t.string  "name",    limit: 90
    t.index "soundex((name)::text)", name: "place_lookup_name_idx", using: :btree
    t.index ["state"], name: "place_lookup_state_idx", using: :btree
  end

  create_table "previous_assignments", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "variant",                                 null: false
    t.uuid     "assignment_id",                           null: false
    t.datetime "superseded_at",                           null: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.uuid     "bulk_assignment_id"
    t.boolean  "individually_overridden", default: false, null: false
    t.string   "context"
    t.uuid     "visitor_supersession_id"
    t.index ["assignment_id"], name: "index_previous_assignments_on_assignment_id", using: :btree
    t.index ["superseded_at"], name: "index_previous_assignments_on_superseded_at", using: :btree
    t.index ["visitor_supersession_id"], name: "index_previous_assignments_on_visitor_supersession_id", using: :btree
  end

  create_table "previous_split_registries", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "split_id",      null: false
    t.json     "registry",      null: false
    t.datetime "superseded_at", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["split_id"], name: "index_previous_split_registries_on_split_id", using: :btree
    t.index ["superseded_at"], name: "index_previous_split_registries_on_superseded_at", using: :btree
  end

  create_table "secondary_unit_lookup", primary_key: "name", id: :string, limit: 20, force: :cascade do |t|
    t.string "abbrev", limit: 5
    t.index ["abbrev"], name: "secondary_unit_lookup_abbrev_idx", using: :btree
  end

  create_table "spatial_ref_sys", primary_key: "srid", id: :integer, force: :cascade do |t|
    t.string  "auth_name", limit: 256
    t.integer "auth_srid"
    t.string  "srtext",    limit: 2048
    t.string  "proj4text", limit: 2048
  end

  create_table "splits", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "name"
    t.uuid     "owner_app_id",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "finished_at"
    t.json     "registry",            null: false
    t.text     "hypothesis"
    t.text     "assignment_criteria"
    t.text     "description"
    t.string   "owner"
    t.string   "location"
    t.integer  "platform"
    t.index ["name"], name: "index_splits_on_name", unique: true, using: :btree
    t.index ["owner_app_id"], name: "index_splits_on_owner_app_id", using: :btree
  end

# Could not dump table "state" because of following StandardError
#   Unknown type 'geometry' for column 'the_geom'

  create_table "state_lookup", primary_key: "st_code", id: :integer, force: :cascade do |t|
    t.string "name",    limit: 40
    t.string "abbrev",  limit: 3
    t.string "statefp", limit: 2
    t.index ["abbrev"], name: "state_lookup_abbrev_key", unique: true, using: :btree
    t.index ["name"], name: "state_lookup_name_key", unique: true, using: :btree
    t.index ["statefp"], name: "state_lookup_statefp_key", unique: true, using: :btree
  end

  create_table "street_type_lookup", primary_key: "name", id: :string, limit: 50, force: :cascade do |t|
    t.string  "abbrev", limit: 50
    t.boolean "is_hw",             default: false, null: false
    t.index ["abbrev"], name: "street_type_lookup_abbrev_idx", using: :btree
  end

# Could not dump table "tabblock" because of following StandardError
#   Unknown type 'geometry' for column 'the_geom'

# Could not dump table "tract" because of following StandardError
#   Unknown type 'geometry' for column 'the_geom'

  create_table "variant_details", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "split_id",                null: false
    t.string   "variant",                 null: false
    t.string   "display_name",            null: false
    t.text     "description",             null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "screenshot_file_name"
    t.string   "screenshot_content_type"
    t.integer  "screenshot_file_size"
    t.datetime "screenshot_updated_at"
    t.index ["split_id", "variant"], name: "index_variant_details_on_split_id_and_variant", unique: true, using: :btree
    t.index ["split_id"], name: "index_variant_details_on_split_id", using: :btree
  end

  create_table "visitor_supersessions", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "superseded_visitor_id",  null: false
    t.uuid     "superseding_visitor_id", null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["superseded_visitor_id"], name: "index_visitor_supersessions_on_superseded_visitor_id", using: :btree
    t.index ["superseding_visitor_id"], name: "index_visitor_supersessions_on_superseding_visitor_id", using: :btree
  end

  create_table "visitors", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "fingerprint"
  end

# Could not dump table "zcta5" because of following StandardError
#   Unknown type 'geometry' for column 'the_geom'

  create_table "zip_lookup", primary_key: "zip", id: :integer, force: :cascade do |t|
    t.integer "st_code"
    t.string  "state",   limit: 2
    t.integer "co_code"
    t.string  "county",  limit: 90
    t.integer "cs_code"
    t.string  "cousub",  limit: 90
    t.integer "pl_code"
    t.string  "place",   limit: 90
    t.integer "cnt"
  end

  create_table "zip_lookup_all", id: false, force: :cascade do |t|
    t.integer "zip"
    t.integer "st_code"
    t.string  "state",   limit: 2
    t.integer "co_code"
    t.string  "county",  limit: 90
    t.integer "cs_code"
    t.string  "cousub",  limit: 90
    t.integer "pl_code"
    t.string  "place",   limit: 90
    t.integer "cnt"
  end

  create_table "zip_lookup_base", primary_key: "zip", id: :string, limit: 5, force: :cascade do |t|
    t.string "state",   limit: 40
    t.string "county",  limit: 90
    t.string "city",    limit: 90
    t.string "statefp", limit: 2
  end

  create_table "zip_state", primary_key: ["zip", "stusps"], force: :cascade do |t|
    t.string "zip",     limit: 5, null: false
    t.string "stusps",  limit: 2, null: false
    t.string "statefp", limit: 2
  end

  create_table "zip_state_loc", primary_key: ["zip", "stusps", "place"], force: :cascade do |t|
    t.string "zip",     limit: 5,   null: false
    t.string "stusps",  limit: 2,   null: false
    t.string "statefp", limit: 2
    t.string "place",   limit: 100, null: false
  end

  add_foreign_key "assignments", "bulk_assignments"
  add_foreign_key "assignments", "splits"
  add_foreign_key "assignments", "visitor_supersessions"
  add_foreign_key "assignments", "visitors"
  add_foreign_key "bulk_assignments", "admins"
  add_foreign_key "bulk_assignments", "splits"
  add_foreign_key "identifier_types", "apps", column: "owner_app_id"
  add_foreign_key "identifiers", "identifier_types"
  add_foreign_key "identifiers", "visitors"
  add_foreign_key "previous_assignments", "assignments"
  add_foreign_key "previous_assignments", "bulk_assignments"
  add_foreign_key "previous_assignments", "visitor_supersessions"
  add_foreign_key "previous_split_registries", "splits"
  add_foreign_key "splits", "apps", column: "owner_app_id"
  add_foreign_key "variant_details", "splits"
  add_foreign_key "visitor_supersessions", "visitors", column: "superseded_visitor_id"
  add_foreign_key "visitor_supersessions", "visitors", column: "superseding_visitor_id"
end
