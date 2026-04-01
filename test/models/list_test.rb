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
    end

    should "capitalize first letter" do
      list = build(:list, description: "a collection of resources")
      assert list.awesome_description.start_with?("A")
    end

    should "add period at end if missing" do
      list = build(:list, description: "A collection of resources")
      assert list.awesome_description.end_with?(".")
    end

    should "not duplicate period at end" do
      list = build(:list, description: "A collection of resources.")
      assert_equal "A collection of resources.", list.awesome_description
    end

    should "fix GitHub casing" do
      list = build(:list, description: "A collection of github resources")
      assert_includes list.awesome_description, "GitHub"
    end

    should "fix JavaScript casing" do
      list = build(:list, description: "Awesome javascript libraries")
      assert_includes list.awesome_description, "JavaScript"
    end

    should "fix TypeScript casing" do
      list = build(:list, description: "Awesome typescript tools")
      assert_includes list.awesome_description, "TypeScript"
    end

    should "fix Node.js casing" do
      list = build(:list, description: "Awesome nodejs frameworks")
      assert_includes list.awesome_description, "Node.js"
    end

    should "fix React casing" do
      list = build(:list, description: "Awesome ReactJS components")
      assert_includes list.awesome_description, "React"
    end

    should "fix Vue.js casing" do
      list = build(:list, description: "Awesome vuejs components")
      assert_includes list.awesome_description, "Vue.js"
    end

    should "fix golang to Go" do
      list = build(:list, description: "A curated list of golang libraries and tools")
      assert_includes list.awesome_description, "Go"
      assert_not_includes list.awesome_description, "golang"
    end

    should "fix PostgreSQL casing" do
      list = build(:list, description: "Awesome postgresql extensions")
      assert_includes list.awesome_description, "PostgreSQL"
    end

    should "fix GraphQL casing" do
      list = build(:list, description: "A list of graphql tools")
      assert_includes list.awesome_description, "GraphQL"
    end

    should "fix iOS casing" do
      list = build(:list, description: "A collection of ios libraries")
      assert_includes list.awesome_description, "iOS"
      assert_not_includes list.awesome_description, " ios "
    end

    should "fix macOS casing from OSX" do
      list = build(:list, description: "A collection of OSX apps")
      assert_includes list.awesome_description, "macOS"
    end

    should "fix YouTube casing" do
      list = build(:list, description: "A list of youtube channels")
      assert_includes list.awesome_description, "YouTube"
    end

    should "remove URLs from description" do
      list = build(:list, description: "Check out https://example.com for more info")
      assert_not_includes list.awesome_description, "https://"
    end

    should "remove newlines" do
      list = build(:list, description: "Line one\nLine two")
      assert_not_includes list.awesome_description, "\n"
    end
  end
end
