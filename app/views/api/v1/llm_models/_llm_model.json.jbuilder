json.cache! [llm_model, 'v1'] do
  json.extract! llm_model, :id, :slug, :name, :description, :url, :provider, :parameters, :context_window,
                :license, :open_source, :api_available, :github_url, :paper_url, :release_date,
                :created_at, :updated_at
  json.llm_model_url api_v1_llm_model_url(llm_model)
  json.html_url llm_model_url(llm_model)
end
