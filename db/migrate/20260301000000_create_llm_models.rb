class CreateLlmModels < ActiveRecord::Migration[8.1]
  def change
    create_table :llm_models do |t|
      t.boolean "api_available", default: false
      t.integer "context_window"
      t.datetime "created_at", null: false
      t.text "description"
      t.string "github_url"
      t.string "license"
      t.string "name", null: false
      t.boolean "open_source", default: false
      t.string "paper_url"
      t.string "parameters"
      t.string "provider"
      t.date "release_date"
      t.string "slug", null: false
      t.datetime "updated_at", null: false
      t.string "url"
      t.index ["name"], name: "index_llm_models_on_name"
      t.index ["provider"], name: "index_llm_models_on_provider"
      t.index ["slug"], name: "index_llm_models_on_slug", unique: true
    end
  end
end
