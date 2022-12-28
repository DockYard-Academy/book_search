defmodule BookSearch.BooksTest do
  use BookSearch.DataCase

  alias BookSearch.Books

  describe "books" do
    alias BookSearch.Books.Book

    import BookSearch.BooksFixtures
    import BookSearch.AuthorsFixtures
    import BookSearch.TagsFixtures

    @invalid_attrs %{title: nil}

    test "list_books/0 returns all books" do
      book = book_fixture()
      assert Books.list_books() == [book]
    end

    test "get_book!/1 returns the book with given id" do
      book = book_fixture()
      assert Books.get_book!(book.id) == book
    end

    test "create_book/1 with valid data creates a book" do
      valid_attrs = %{title: "some title"}

      assert {:ok, %Book{} = book} = Books.create_book(valid_attrs)
      assert book.title == "some title"
    end

    test "create_book/1 with author creates a book with an associated author" do
      author = author_fixture()
      valid_attrs = %{title: "some title", author_id: author.id}

      assert {:ok, %Book{} = book} = Books.create_book(valid_attrs)
      assert book.title == "some title"
      assert book.author_id == author.id
    end

    test "create_book/1 with book content creates a book with associated book content" do
      valid_attrs = %{title: "some title", book_content: %{full_text: "some full text"}}

      assert {:ok, %Book{} = book} = Books.create_book(valid_attrs)
      assert book.title == "some title"
      assert book.book_content.full_text == "some full text"
    end

    # Test the 'create_book/2' function with a request that includes tags.
    test "create_book/1 with tags" do
      # Create two tags.
      tag1 = tag_fixture(name: "tag1")
      tag2 = tag_fixture(name: "tag2")
      # Define a map of valid book attributes.
      valid_attrs = %{title: "some title"}

      # Call the 'create_book/2' function with the valid attributes and the associated tags.
      # Assert that the function returns an ':ok' tuple with a book struct as the second element.
      # Assign the book struct to the 'book' variable.
      assert {:ok, %Book{} = book} = Books.create_book(valid_attrs, [tag1, tag2])
      # Assert that the book has the expected 'title' and 'tags' fields.
      assert book.title == "some title"
      assert book.tags == [tag1, tag2]
    end

    test "create_book/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Books.create_book(@invalid_attrs)
    end

    test "update_book/2 with valid data updates the book" do
      book = book_fixture()
      update_attrs = %{title: "some updated title"}

      assert {:ok, %Book{} = book} = Books.update_book(book, update_attrs)
      assert book.title == "some updated title"
    end

    test "update_book/2 with author updates book's associated author" do
      original_author = author_fixture()
      updated_author = author_fixture()
      book = book_fixture(author_id: original_author.id)
      update_attrs = %{title: "some updated title", author_id: updated_author.id}

      assert {:ok, %Book{} = book} = Books.update_book(book, update_attrs)
      assert book.title == "some updated title"
      assert book.author_id == updated_author.id
    end

    test "update_book/2 with book content book's associated book content" do
      book = book_fixture()
      update_attrs = %{book_content: %{full_text: "updated full text"}}

      assert {:ok, %Book{} = book} = Books.update_book(book, update_attrs)
      assert book.book_content.full_text == "updated full text"
    end

    test "update_book/2 with invalid data returns error changeset" do
      book = book_fixture()
      assert {:error, %Ecto.Changeset{}} = Books.update_book(book, @invalid_attrs)
      assert book == Books.get_book!(book.id)
    end

    # Test the 'update_book/3' function with a request that includes tags.
    test "update_book/3 with tags" do
      # Create two tags.
      tag1 = tag_fixture()
      tag2 = tag_fixture()
      # Create a book with no tags.
      book = book_fixture(tags: [])
      # Define a map of valid book attributes.
      update_attrs = %{title: "some updated title"}

      # Call the 'update_book/3' function with the book fixture, the update attributes, and the tag to associate.
      # Assert that the function returns an ':ok' tuple with a book struct as the second element.
      # Assign the book struct to the 'book' variable.
      assert {:ok, %Book{} = book} = Books.update_book(book, update_attrs, [tag1, tag2])
      # Assert that the book has the expected 'title' and 'tags' fields.
      assert book.title == "some updated title"
      assert book.tags == [tag1, tag2]
    end

    test "delete_book/1 deletes the book" do
      book = book_fixture()
      assert {:ok, %Book{}} = Books.delete_book(book)
      assert_raise Ecto.NoResultsError, fn -> Books.get_book!(book.id) end
    end

    test "change_book/1 returns a book changeset" do
      book = book_fixture()
      assert %Ecto.Changeset{} = Books.change_book(book)
    end
  end
end
