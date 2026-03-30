class DashboardController < ApplicationController
  def index
    @lists_count = List.displayable.count
    @projects_count = Project.not_awesome_list.where.not(last_synced_at: nil).with_repository.count
    @topics_count = Topic.count
    @recent_lists = List.displayable.order(created_at: :desc).limit(5)
    @top_languages = List.displayable.with_primary_language
                        .group(:primary_language)
                        .order('count_all desc')
                        .limit(5)
                        .count
  end
end
