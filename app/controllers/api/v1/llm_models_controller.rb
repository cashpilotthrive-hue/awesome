class Api::V1::LlmModelsController < Api::V1::ApplicationController
  def index
    scope = LlmModel.all

    scope = scope.search(params[:query]) if params[:query].present?
    scope = scope.provider(params[:provider]) if params[:provider].present?
    scope = scope.open_source if params[:open_source] == 'true'
    scope = scope.with_api if params[:api_available] == 'true'

    if params[:sort].present? || params[:order].present?
      sort = params[:sort].presence || 'name'
      if params[:order] == 'desc'
        scope = scope.order(Arel.sql(sort).desc.nulls_last)
      else
        scope = scope.order(Arel.sql(sort).asc.nulls_last)
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
