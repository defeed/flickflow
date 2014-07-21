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

ActiveRecord::Schema.define(version: 20140721115704) do

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

  create_table "countries", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries_movies", id: false, force: true do |t|
    t.integer "country_id", null: false
    t.integer "movie_id",   null: false
  end

  add_index "countries_movies", ["country_id", "movie_id"], name: "index_countries_movies_on_country_id_and_movie_id", using: :btree

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

  create_table "genres", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "genres_movies", id: false, force: true do |t|
    t.integer "genre_id", null: false
    t.integer "movie_id", null: false
  end

  add_index "genres_movies", ["genre_id", "movie_id"], name: "index_genres_movies_on_genre_id_and_movie_id", using: :btree

  create_table "keywords", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "keywords_movies", id: false, force: true do |t|
    t.integer "keyword_id", null: false
    t.integer "movie_id",   null: false
  end

  add_index "keywords_movies", ["keyword_id", "movie_id"], name: "index_keywords_movies_on_keyword_id_and_movie_id", using: :btree
  add_index "keywords_movies", ["movie_id", "keyword_id"], name: "index_keywords_movies_on_movie_id_and_keyword_id", using: :btree

  create_table "languages", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "languages_movies", id: false, force: true do |t|
    t.integer "language_id", null: false
    t.integer "movie_id",    null: false
  end

  add_index "languages_movies", ["language_id", "movie_id"], name: "index_languages_movies_on_language_id_and_movie_id", using: :btree

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
    t.string   "poster_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "movies", ["imdb_id"], name: "index_movies_on_imdb_id", unique: true, using: :btree
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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "people", ["imdb_id"], name: "index_people_on_imdb_id", unique: true, using: :btree
  add_index "people", ["name"], name: "index_people_on_name", using: :btree

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

end
