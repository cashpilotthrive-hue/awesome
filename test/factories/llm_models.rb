FactoryBot.define do
  factory :llm_model do
    sequence(:name) { |n| "LLM Model #{n}" }
    sequence(:slug) { |n| "llm-model-#{n}" }
    description { "A large language model for text generation." }
    url { "https://example.com/model" }
    provider { "ExampleAI" }
    parameters { "70B" }
    context_window { 128_000 }
    license { "Apache 2.0" }
    open_source { false }
    api_available { false }
    github_url { nil }
    paper_url { nil }
    release_date { "2025-01-01" }
  end
end
