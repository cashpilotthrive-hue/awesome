require "test_helper"

class ListTest < ActiveSupport::TestCase
  context "find_spoken_language" do
    should "return nil when description is not present" do
      list = build(:list, description: nil)
      assert_nil list.find_spoken_language
    end

    should "return nil when description is empty" do
      list = build(:list, description: "")
      assert_nil list.find_spoken_language
    end

    should "return nil when description is too short" do
      list = build(:list, description: "Short text")
      assert_nil list.find_spoken_language
    end

    should "detect English language" do
      list = build(:list, description: "This is a collection of awesome resources for learning programming and software development")
      assert_equal "English", list.find_spoken_language
    end

    should "detect German language" do
      list = build(:list, description: "Dies ist eine Sammlung von großartigen Ressourcen zum Erlernen der Programmierung und Softwareentwicklung")
      assert_equal "German", list.find_spoken_language
    end

    should "detect Spanish language" do
      list = build(:list, description: "Esta es una colección de recursos increíbles para aprender programación y desarrollo de software")
      assert_equal "Spanish", list.find_spoken_language
    end

    should "handle descriptions with emojis" do
      list = build(:list, description: "This is a collection of awesome resources 🚀 for learning programming 💻 and software development")
      assert_equal "English", list.find_spoken_language
    end

    should "handle descriptions with markdown emojis" do
      list = build(:list, description: "This is a collection of awesome resources :rocket: for learning programming :computer: and software development")
      assert_equal "English", list.find_spoken_language
    end
  end

  context "awesome_description" do
    should "return nil when description is blank" do
      list = build(:list, description: nil)
      assert_nil list.awesome_description

      list2 = build(:list, description: "")
      assert_nil list2.awesome_description
    end

    should "add a period when description has none" do
      list = build(:list, description: "A curated list of awesome resources")
      assert list.awesome_description.end_with?('.')
    end

    should "not add a period when description already ends with one" do
      list = build(:list, description: "A curated list of awesome resources.")
      assert_equal "A curated list of awesome resources.", list.awesome_description
    end

    should "strip leading and trailing whitespace" do
      list = build(:list, description: "  A curated list  ")
      assert_equal "A curated list.", list.awesome_description
    end

    should "capitalize the first letter" do
      list = build(:list, description: "a curated list of resources.")
      assert_equal "A curated list of resources.", list.awesome_description
    end

    should "normalize GitHub casing" do
      list = build(:list, description: "Resources for github developers.")
      assert_equal "Resources for GitHub developers.", list.awesome_description
    end

    should "normalize GitLab casing" do
      list = build(:list, description: "Resources for gitlab developers.")
      assert_equal "Resources for GitLab developers.", list.awesome_description
    end

    should "normalize JavaScript casing" do
      list = build(:list, description: "A curated list of javascript resources.")
      assert_equal "A curated list of JavaScript resources.", list.awesome_description
    end

    should "normalize TypeScript casing" do
      list = build(:list, description: "A curated list of typescript resources.")
      assert_equal "A curated list of TypeScript resources.", list.awesome_description
    end

    should "normalize macOS variants" do
      [
        ["Resources for Mac OS X users.", "Resources for macOS users."],
        ["Resources for OSX users.", "Resources for macOS users."],
        ["Resources for MacOS users.", "Resources for macOS users."]
      ].each do |input, expected|
        list = build(:list, description: input)
        assert_equal expected, list.awesome_description, "Failed for input: #{input}"
      end
    end

    should "normalize YouTube casing" do
      list = build(:list, description: "A list of youtube channels.")
      assert_equal "A list of YouTube channels.", list.awesome_description
    end

    should "normalize Stack Overflow" do
      list = build(:list, description: "Q&A on stackoverflow for developers.")
      assert_equal "Q&A on Stack Overflow for developers.", list.awesome_description
    end

    should "normalize Node.js" do
      list = build(:list, description: "Resources for nodejs developers.")
      assert_equal "Resources for Node.js developers.", list.awesome_description
    end

    should "normalize Vue.js" do
      list = build(:list, description: "Resources for vuejs developers.")
      assert_equal "Resources for Vue.js developers.", list.awesome_description
    end

    should "normalize jQuery" do
      list = build(:list, description: "Resources for jquery developers.")
      assert_equal "Resources for jQuery developers.", list.awesome_description
    end

    should "normalize GraphQL" do
      list = build(:list, description: "Resources for graphql developers.")
      assert_equal "Resources for GraphQL developers.", list.awesome_description
    end

    should "normalize PostgreSQL" do
      list = build(:list, description: "Resources for postgresql databases.")
      assert_equal "Resources for PostgreSQL databases.", list.awesome_description
    end

    should "normalize MongoDB" do
      list = build(:list, description: "Resources for mongodb databases.")
      assert_equal "Resources for MongoDB databases.", list.awesome_description
    end

    should "normalize Kubernetes" do
      list = build(:list, description: "Resources for kubernetes orchestration.")
      assert_equal "Resources for Kubernetes orchestration.", list.awesome_description
    end

    should "normalize WordPress" do
      list = build(:list, description: "Resources for wordpress sites.")
      assert_equal "Resources for WordPress sites.", list.awesome_description
    end

    should "remove URLs from description" do
      list = build(:list, description: "A list of resources at https://example.com for developers.")
      result = list.awesome_description
      assert_not result.include?('https://example.com')
    end

    should "not duplicate periods" do
      list = build(:list, description: "A list of resources...")
      assert_not list.awesome_description.include?('..')
    end

    should "collapse multiple spaces" do
      list = build(:list, description: "A list  with  extra   spaces.")
      assert_equal "A list with extra spaces.", list.awesome_description
    end
  end
end
