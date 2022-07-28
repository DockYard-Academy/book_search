defmodule BookSearchWeb.BookControllerTest do
  use BookSearchWeb.ConnCase

  import BookSearch.BooksFixtures
  import BookSearch.AuthorsFixtures

  @create_attrs %{title: "some title"}
  @update_attrs %{title: "some updated title"}
  @invalid_attrs %{title: nil}

  describe "index" do
    test "lists all books", %{conn: conn} do
      author = author_fixture()
      book = book_fixture(author: author)
      conn = get(conn, Routes.book_path(conn, :index))
      assert html_response(conn, 200) =~ book.title
    end

    test "lists all books by author", %{conn: conn} do
      author1 = author_fixture(name: "Dennis E Taylor")
      author2 = author_fixture(name: "Patrick Rothfuss")

      book1 = book_fixture(author: author1, title: "We are Legend")
      book2 = book_fixture(author: author2, title: "Name of the Wind")

      conn = get(conn, Routes.author_book_path(conn, :index, author1))
      assert html_response(conn, 200) =~ book1.title
      refute html_response(conn, 200) =~ book2.title
    end
  end

  describe "new book" do
    test "renders form", %{conn: conn} do
      author = author_fixture()
      conn = get(conn, Routes.author_book_path(conn, :new, author))
      assert html_response(conn, 200) =~ "New Book"
    end
  end

  describe "create book" do
    test "redirects to show when data is valid", %{conn: conn} do
      author = author_fixture()
      conn = post(conn, Routes.author_book_path(conn, :create, author), book: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.author_book_path(conn, :show, author, id)

      conn = get(conn, Routes.author_book_path(conn, :show, author, id))
      assert html_response(conn, 200) =~ "Show Book"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      author = author_fixture()
      conn = post(conn, Routes.author_book_path(conn, :create, author), book: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Book"
    end
  end

  describe "edit book" do
    setup [:create_book]

    test "renders form for editing chosen book", %{conn: conn, book: book} do
      conn = get(conn, Routes.author_book_path(conn, :edit, book.author_id, book))
      assert html_response(conn, 200) =~ "Edit Book"
    end
  end

  describe "update book" do
    setup [:create_book]

    test "redirects when data is valid", %{conn: conn, book: book} do
      conn =
        put(conn, Routes.author_book_path(conn, :update, book.author_id, book),
          book: @update_attrs
        )

      assert redirected_to(conn) == Routes.author_book_path(conn, :show, book.author_id, book)

      conn = get(conn, Routes.author_book_path(conn, :show, book.author_id, book))
      assert html_response(conn, 200) =~ "some updated title"
    end

    test "renders errors when data is invalid", %{conn: conn, book: book} do
      conn =
        put(conn, Routes.author_book_path(conn, :update, book.author_id, book),
          book: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "Edit Book"
    end
  end

  describe "delete book" do
    setup [:create_book]

    test "deletes chosen book", %{conn: conn, book: book} do
      conn = delete(conn, Routes.author_book_path(conn, :delete, book.author_id, book))
      assert redirected_to(conn) == Routes.author_book_path(conn, :index, book.author_id)

      assert_error_sent 404, fn ->
        get(conn, Routes.author_book_path(conn, :show, book.author_id, book))
      end
    end
  end

  defp create_book(_) do
    book = book_fixture(author: author_fixture())
    %{book: book}
  end
end
