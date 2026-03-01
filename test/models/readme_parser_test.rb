require 'test_helper'

class ReadmeParserTest < ActiveSupport::TestCase
  def setup
    @readme = <<-README
## Category 1
### Sub-Category 1
- [Link 1](http://example.com/1) - Description 1
### Sub-Category 2
- [Link 2](http://example.com/2) - Description 2
## Category 2
### Sub-Category 3
- [Link 3](http://example.com/3) - Description 3
  README
    @parser = ReadmeParser.new(@readme)
  end
  
  def test_parse_links
    expected_links = {
      'Category 1' => {
        'Sub-Category 1' => [
          { name: 'Link 1', url: 'http://example.com/1', description: 'Description 1' }
        ],
        'Sub-Category 2' => [
          { name: 'Link 2', url: 'http://example.com/2', description: 'Description 2' }
        ]
      },
      'Category 2' => {
        'Sub-Category 3' => [
          { name: 'Link 3', url: 'http://example.com/3', description: 'Description 3' }
        ]
      }
    }
    assert_equal expected_links, @parser.parse_links
  end

  def test_parse_links_with_no_links
    parser = ReadmeParser.new('No links here')
    assert_equal({}, parser.parse_links)
  end

  def test_readme_with_no_categories
    readme = <<-README
- [Link 1](http://example.com/1) - Description 1
  - [Link 2](http://example.com/2) - Description 2
    README
    parser = ReadmeParser.new(readme)
    expected_links = {
      'Uncategorized' => {
        'Uncategorized' => [
          { name: 'Link 1', url: 'http://example.com/1', description: 'Description 1' },
          { name: 'Link 2', url: 'http://example.com/2', description: 'Description 2' }
        ]
      }
    }
    assert_equal expected_links, parser.parse_links
  end

  def test_parse_links_with_fourth_level_headers
    readme = <<-README
## Category 1
### Sub-Category 1
#### Nested Sub-Category
- [Link 1](http://example.com/1) - Description 1
    README
    parser = ReadmeParser.new(readme)
    expected_links = {
      'Category 1' => {
        'Nested Sub-Category' => [
          { name: 'Link 1', url: 'http://example.com/1', description: 'Description 1' }
        ]
      }
    }
    assert_equal expected_links, parser.parse_links
  end

  def test_ignored_categories_are_skipped
    readme = <<-README
## Contents
- [Link 1](http://example.com/1) - Should be ignored
## Real Category
### Sub-Category
- [Link 2](http://example.com/2) - Description 2
## License
- [Link 3](http://example.com/3) - Should be ignored
    README
    parser = ReadmeParser.new(readme)
    result = parser.parse_links
    assert_nil result['Contents']
    assert_nil result['License']
    assert result['Real Category'].present?
  end

  def test_sub_category_reset_on_new_category
    readme = <<-README
## Category 1
### Sub-Category 1
- [Link 1](http://example.com/1) - Description 1
## Category 2
- [Link 2](http://example.com/2) - Description 2
    README
    parser = ReadmeParser.new(readme)
    result = parser.parse_links
    # Link 2 should be under nil sub_category, not Sub-Category 1
    assert_nil result['Category 2']['Sub-Category 1']
    assert result['Category 2'][nil].present?
  end
end