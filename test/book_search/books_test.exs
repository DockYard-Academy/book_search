defmodule BookSearch.BooksTest do
  use BookSearch.DataCase

  alias BookSearch.Books

  describe "books" do
    alias BookSearch.Books.Book

    import BookSearch.BooksFixtures
    import BookSearch.AuthorsFixtures
    import BookSearch.TagsFixtures

    test "list_books/0 returns all books" do
      author = author_fixture()
      book = book_fixture(author: author)

      assert [fetched_book] = Books.list_books()
      assert fetched_book.title == book.title
      assert fetched_book.author_id == book.author_id
      assert fetched_book.author == author
    end

    test "get_book!/1 returns the book with given id" do
      author = author_fixture()
      book = book_fixture(author: author)
      fetched_book = Books.get_book!(book.id)
      assert fetched_book.id == book.id
      assert fetched_book.author_id == book.author_id
      assert fetched_book.title == book.title
    end

    test "create_book/1 with valid data creates a book" do
      author = author_fixture()
      valid_attrs = %{title: "some title", author: author}

      assert {:ok, %Book{} = book} = Books.create_book(valid_attrs)
      assert book.title == "some title"
    end

    test "create_book/1 with tags" do
      author = author_fixture()
      tag1 = tag_fixture()
      tag2 = tag_fixture()
      valid_attrs = %{title: "some title", author: author, tags: [tag1, tag2]}

      assert {:ok, %Book{} = book} = Books.create_book(valid_attrs)
      assert book.title == "some title"
      assert book.tags == [tag1, tag2]
    end

    test "create_book/1 with invalid data returns error changeset" do
      author = author_fixture()
      invalid_attrs = %{title: nil, author: author}
      assert {:error, %Ecto.Changeset{}} = Books.create_book(invalid_attrs)
    end

    test "update_book/2 with tags" do
      author = author_fixture()
      tag1 = tag_fixture(name: "Fantasy")
      tag2 = tag_fixture(name: "Fiction")
      book = book_fixture(author: author, tags: [tag1])
      update_attrs = %{title: "Name of the Wind", tags: [tag2]}

      assert {:ok, %Book{} = book} = Books.update_book(book, update_attrs)
      assert book.title == update_attrs.title
      assert book.tags == [tag2]
    end

    test "update_book/2 with valid data updates the book" do
      author = author_fixture()
      book = book_fixture(author: author)
      update_attrs = %{title: "some updated title"}

      assert {:ok, %Book{} = book} = Books.update_book(book, update_attrs)
      assert book.title == "some updated title"
    end

    test "update_book/2 with invalid data returns error changeset" do
      author = author_fixture()
      book = book_fixture(author: author)
      invalid_attrs = %{title: nil, author: author}
      assert {:error, %Ecto.Changeset{}} = Books.update_book(book, invalid_attrs)
      fetched_book = Books.get_book!(book.id)
      assert fetched_book.id == book.id
      assert fetched_book.author_id == book.author_id
      assert fetched_book.title == book.title
    end

    test "delete_book/1 deletes the book" do
      author = author_fixture()
      book = book_fixture(author: author)
      assert {:ok, %Book{}} = Books.delete_book(book)
      assert_raise Ecto.NoResultsError, fn -> Books.get_book!(book.id) end
    end

    test "change_book/1 returns a book changeset" do
      author = author_fixture()
      book = book_fixture(author: author)
      assert %Ecto.Changeset{} = Books.change_book(book)
    end
  end
end
