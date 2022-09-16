defmodule BookSearch.AuthorsTest do
  use BookSearch.DataCase

  alias BookSearch.Authors

  describe "authors" do
    alias BookSearch.Authors.Author

    import BookSearch.AuthorsFixtures

    @invalid_attrs %{name: nil}

    test "list_authors/0 returns all authors" do
      author = author_fixture()
      assert Authors.list_authors() == [author]
    end

    test "list_authors/1 _ matching name" do
      author = author_fixture(name: "Andrew Rowe")
      assert Authors.list_authors("Andrew Rowe") == [author]
    end

    test "list_authors/1 _ partially matching name" do
      author = author_fixture(name: "Dennis E Taylor")
      assert Authors.list_authors("Dennis") == [author]
      assert Authors.list_authors("E") == [author]
      assert Authors.list_authors("Taylor") == [author]
    end

    test "list_authors/1 _ case insensitive match" do
      author = author_fixture(name: "Dennis E Taylor")
      assert Authors.list_authors("DENNIS") == [author]
      assert Authors.list_authors("dennis") == [author]
    end

    test "list_authors/1 _ non matching name" do
      assert Authors.list_authors("Dennis E Taylor") == []
    end

    test "get_author!/1 returns the author with given id" do
      author = author_fixture()
      assert Authors.get_author!(author.id) == author
    end

    test "create_author/1 with valid data creates a author" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Author{} = author} = Authors.create_author(valid_attrs)
      assert author.name == "some name"
    end

    test "create_author/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Authors.create_author(@invalid_attrs)
    end

    test "update_author/2 with valid data updates the author" do
      author = author_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Author{} = author} = Authors.update_author(author, update_attrs)
      assert author.name == "some updated name"
    end

    test "update_author/2 with invalid data returns error changeset" do
      author = author_fixture()
      assert {:error, %Ecto.Changeset{}} = Authors.update_author(author, @invalid_attrs)
      assert author == Authors.get_author!(author.id)
    end

    test "delete_author/1 deletes the author" do
      author = author_fixture()
      assert {:ok, %Author{}} = Authors.delete_author(author)
      assert_raise Ecto.NoResultsError, fn -> Authors.get_author!(author.id) end
    end

    test "change_author/1 returns a author changeset" do
      author = author_fixture()
      assert %Ecto.Changeset{} = Authors.change_author(author)
    end
  end
end
