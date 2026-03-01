require 'test_helper'

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test 'renders dashboard index' do
    get dashboard_path
    assert_response :success
    assert_template 'dashboard/index'
  end

  test 'dashboard shows list and project counts' do
    create(:list,
      projects_count: 10,
      repository: {
        'fork' => false,
        'archived' => false,
        'description' => 'A great list',
        'topics' => ['ruby']
      }
    )

    get dashboard_path
    assert_response :success
    assert_includes response.body, 'Awesome Lists'
    assert_includes response.body, 'Projects'
    assert_includes response.body, 'Topics'
  end

  test 'dashboard shows operations links' do
    get dashboard_path
    assert_response :success
    assert_includes response.body, 'API Docs'
    assert_includes response.body, 'Open Data'
    assert_includes response.body, 'RSS Feed'
    assert_includes response.body, 'Markdown Export'
  end

  test 'dashboard shows ecosystems environments' do
    get dashboard_path
    assert_response :success
    assert_includes response.body, 'Ecosyste.ms Environments'
    assert_includes response.body, 'Packages'
    assert_includes response.body, 'Repositories'
  end
end
