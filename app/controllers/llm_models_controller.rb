class LlmModelsController < ApplicationController
  def index
    scope = LlmModel.all

    scope = scope.search(params[:query]) if params[:query].present?
    scope = scope.provider(params[:provider]) if params[:provider].present?
    scope = scope.open_source if params[:open_source] == 'true'
    scope = scope.with_api if params[:api_available] == 'true'

    if params[:sort].present?
      case params[:sort]
      when 'release_date'
        scope = scope.order_by_release_date
      else
        scope = scope.order_by_name
      end
    else
      scope = scope.order_by_name
    end

    @pagy, @llm_models = pagy(scope)
    fresh_when(@llm_models, public: true)
  end

  def show
    @llm_model = LlmModel.find_by!(slug: params[:id])
    fresh_when(@llm_model, public: true)
  end
end
