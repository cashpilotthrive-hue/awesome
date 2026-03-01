class ExportsController < ApplicationController
  def index
    fresh_when([List.maximum(:updated_at), Project.maximum(:updated_at)], public: true)
  end
end
