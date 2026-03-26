require 'test_helper'

class LlmModelTest < ActiveSupport::TestCase
  test "should validate presence of name" do
    llm_model = LlmModel.new(slug: "test-model")
    assert_not llm_model.valid?
    assert_includes llm_model.errors[:name], "can't be blank"
  end

  test "should validate presence of slug" do
    llm_model = LlmModel.new(name: "Test Model", slug: nil)
    llm_model.valid?
    # slug should be auto-generated from name
    assert llm_model.valid?
    assert_equal "test-model", llm_model.slug
  end

  test "should validate uniqueness of slug" do
    create(:llm_model, slug: "gpt-4")
    duplicate = build(:llm_model, slug: "gpt-4")
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:slug], "has already been taken"
  end

  test "should auto-generate slug from name" do
    llm_model = LlmModel.new(name: "GPT-4 Turbo")
    llm_model.valid?
    assert_equal "gpt-4-turbo", llm_model.slug
  end

  test "should not overwrite existing slug" do
    llm_model = LlmModel.new(name: "GPT-4 Turbo", slug: "custom-slug")
    llm_model.valid?
    assert_equal "custom-slug", llm_model.slug
  end

  test "to_param returns slug" do
    llm_model = build(:llm_model, slug: "gpt-4")
    assert_equal "gpt-4", llm_model.to_param
  end

  test "to_s returns name" do
    llm_model = build(:llm_model, name: "GPT-4")
    assert_equal "GPT-4", llm_model.to_s
  end

  test "open_source scope returns only open source models" do
    open_model = create(:llm_model, open_source: true)
    closed_model = create(:llm_model, open_source: false)

    results = LlmModel.open_source
    assert_includes results, open_model
    assert_not_includes results, closed_model
  end

  test "proprietary scope returns only proprietary models" do
    open_model = create(:llm_model, open_source: true)
    closed_model = create(:llm_model, open_source: false)

    results = LlmModel.proprietary
    assert_includes results, closed_model
    assert_not_includes results, open_model
  end

  test "with_api scope returns models with API available" do
    with_api = create(:llm_model, api_available: true)
    without_api = create(:llm_model, api_available: false)

    results = LlmModel.with_api
    assert_includes results, with_api
    assert_not_includes results, without_api
  end

  test "provider scope filters by provider" do
    openai_model = create(:llm_model, provider: "OpenAI")
    anthropic_model = create(:llm_model, provider: "Anthropic")

    results = LlmModel.provider("OpenAI")
    assert_includes results, openai_model
    assert_not_includes results, anthropic_model
  end

  test "search scope searches by name, description, and provider" do
    model = create(:llm_model, name: "GPT-4", description: "A large language model", provider: "OpenAI")
    other = create(:llm_model, name: "Other Model", description: "Something else", provider: "Other")

    assert_includes LlmModel.search("GPT"), model
    assert_not_includes LlmModel.search("GPT"), other

    assert_includes LlmModel.search("large language"), model
    assert_not_includes LlmModel.search("large language"), other

    assert_includes LlmModel.search("OpenAI"), model
    assert_not_includes LlmModel.search("OpenAI"), other
  end

  test "default open_source value should be false" do
    llm_model = LlmModel.new(name: "Test")
    assert_equal false, llm_model.open_source
  end

  test "default api_available value should be false" do
    llm_model = LlmModel.new(name: "Test")
    assert_equal false, llm_model.api_available
  end
end
