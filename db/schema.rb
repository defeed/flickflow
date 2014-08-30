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

ActiveRecord::Schema.define(version: 20140823131020) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alternative_titles", force: true do |t|
    t.string   "movie_id"
    t.string   "title"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "alternative_titles", ["movie_id", "title"], name: "index_alternative_titles_on_movie_id_and_title", using: :btree

  create_table "auth_tokens", force: true do |t|
    t.string   "token",      null: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "auth_tokens", ["token"], name: "index_auth_tokens_on_token", unique: true, using: :btree

  create_table "authentications", force: true do |t|
    t.integer  "user_id",    null: false
    t.string   "provider",   null: false
    t.string   "uid",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "countries", ["slug"], name: "index_countries_on_slug", unique: true, using: :btree

  create_table "countries_movies", id: false, force: true do |t|
    t.integer "country_id", null: false
    t.integer "movie_id",   null: false
  end

  add_index "countries_movies", ["country_id", "movie_id"], name: "index_countries_movies_on_country_id_and_movie_id", using: :btree

  create_table "critic_reviews", force: true do |t|
    t.integer  "movie_id"
    t.string   "author"
    t.string   "publisher"
    t.text     "excerpt"
    t.integer  "rating"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", force: true do |t|
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
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "fetches", force: true do |t|
    t.integer  "fetchable_id"
    t.string   "fetchable_type"
    t.integer  "page"
    t.integer  "response_code"
    t.string   "response_message"
    t.boolean  "has_data",         default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fetches", ["fetchable_id", "fetchable_type"], name: "index_fetches_on_fetchable_id_and_fetchable_type", using: :btree

  create_table "genres", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "genres", ["slug"], name: "index_genres_on_slug", unique: true, using: :btree

  create_table "genres_movies", id: false, force: true do |t|
    t.integer "genre_id", null: false
    t.integer "movie_id", null: false
  end

  add_index "genres_movies", ["genre_id", "movie_id"], name: "index_genres_movies_on_genre_id_and_movie_id", using: :btree

  create_table "images", force: true do |t|
    t.string   "type"
    t.string   "file"
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.string   "remote_url"
    t.boolean  "is_primary",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "images", ["imageable_id", "imageable_type"], name: "index_images_on_imageable_id_and_imageable_type", using: :btree

  create_table "keywords", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "keywords", ["name"], name: "index_keywords_on_name", unique: true, using: :btree
  add_index "keywords", ["slug"], name: "index_keywords_on_slug", unique: true, using: :btree

  create_table "keywords_movies", id: false, force: true do |t|
    t.integer "keyword_id", null: false
    t.integer "movie_id",   null: false
  end

  add_index "keywords_movies", ["keyword_id", "movie_id"], name: "index_keywords_movies_on_keyword_id_and_movie_id", using: :btree
  add_index "keywords_movies", ["movie_id", "keyword_id"], name: "index_keywords_movies_on_movie_id_and_keyword_id", using: :btree

  create_table "languages", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "languages", ["slug"], name: "index_languages_on_slug", unique: true, using: :btree

  create_table "languages_movies", id: false, force: true do |t|
    t.integer "language_id", null: false
    t.integer "movie_id",    null: false
  end

  add_index "languages_movies", ["language_id", "movie_id"], name: "index_languages_movies_on_language_id_and_movie_id", using: :btree

  create_table "list_entries", force: true do |t|
    t.integer  "list_id"
    t.integer  "listable_id"
    t.string   "listable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "list_entries", ["list_id", "listable_id", "listable_type"], name: "index_list_entries_on_list_id_and_listable_id_and_listable_type", unique: true, using: :btree

  create_table "lists", force: true do |t|
    t.integer  "user_id"
    t.integer  "list_type"
    t.string   "name"
    t.boolean  "is_private", default: false
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lists", ["name"], name: "index_lists_on_name", using: :btree
  add_index "lists", ["slug"], name: "index_lists_on_slug", using: :btree
  add_index "lists", ["user_id", "list_type"], name: "index_lists_on_user_id_and_list_type", using: :btree
  add_index "lists", ["user_id", "name"], name: "index_lists_on_user_id_and_name", using: :btree

  create_table "movies", force: true do |t|
    t.string   "imdb_id"
    t.string   "title"
    t.string   "original_title"
    t.string   "sort_title"
    t.integer  "year"
    t.date     "released_on"
    t.float    "imdb_rating"
    t.integer  "imdb_rating_count"
    t.integer  "rotten_critics_rating"
    t.integer  "rotten_audience_rating"
    t.integer  "metacritic_rating"
    t.string   "mpaa_rating"
    t.string   "description",            limit: 1000
    t.text     "storyline"
    t.integer  "runtime"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "movies", ["imdb_id"], name: "index_movies_on_imdb_id", unique: true, using: :btree
  add_index "movies", ["slug"], name: "index_movies_on_slug", unique: true, using: :btree
  add_index "movies", ["title"], name: "index_movies_on_title", using: :btree

  create_table "participations", force: true do |t|
    t.integer  "movie_id"
    t.integer  "person_id"
    t.integer  "job"
    t.string   "credit"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "participations", ["movie_id", "person_id", "job", "credit"], name: "participations_index", unique: true, using: :btree
  add_index "participations", ["movie_id", "person_id"], name: "index_participations_on_movie_id_and_person_id", using: :btree

  create_table "people", force: true do |t|
    t.string   "imdb_id"
    t.string   "name"
    t.string   "birth_name"
    t.date     "born_on"
    t.date     "died_on"
    t.text     "bio"
    t.string   "photo_url"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "people", ["imdb_id"], name: "index_people_on_imdb_id", unique: true, using: :btree
  add_index "people", ["name"], name: "index_people_on_name", using: :btree
  add_index "people", ["slug"], name: "index_people_on_slug", unique: true, using: :btree

  create_table "recommendations", force: true do |t|
    t.integer "movie_id"
    t.integer "other_movie_id"
  end

  add_index "recommendations", ["movie_id", "other_movie_id"], name: "index_recommendations_on_movie_id_and_other_movie_id", unique: true, using: :btree
  add_index "recommendations", ["other_movie_id", "movie_id"], name: "index_recommendations_on_other_movie_id_and_movie_id", unique: true, using: :btree

  create_table "releases", force: true do |t|
    t.integer  "country_id"
    t.integer  "movie_id"
    t.date     "released_on"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "releases", ["country_id", "movie_id"], name: "index_releases_on_country_id_and_movie_id", using: :btree

  create_table "trivia", force: true do |t|
    t.integer  "movie_id"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "username"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "salt"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.datetime "last_login_at"
    t.datetime "last_logout_at"
    t.datetime "last_activity_at"
    t.string   "last_login_from_ip_address"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["last_logout_at", "last_activity_at"], name: "index_users_on_last_logout_at_and_last_activity_at", using: :btree
  add_index "users", ["remember_me_token"], name: "index_users_on_remember_me_token", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
