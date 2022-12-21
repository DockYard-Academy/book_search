defmodule BookSearchWeb.BookControllerTest do
  use BookSearchWeb.ConnCase

  import BookSearch.BooksFixtures
  import BookSearch.AuthorsFixtures
  import BookSearch.TagsFixtures

  @create_attrs %{title: "some title"}
  @update_attrs %{title: "some updated title"}
  @invalid_attrs %{title: nil}

  describe "index" do
    test "lists all books", %{conn: conn} do
      conn = get(conn, Routes.book_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Books"
    end
  end

  describe "new book" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.book_path(conn, :new))
      assert html_response(conn, 200) =~ "New Book"
    end
  end

  describe "create book" do
    # Test the 'create' action of the 'BookController' with a request that includes tags.
    test "create a book with tags", %{conn: conn} do
      # Create two tags.
      tag1 = tag_fixture(name: "tag1")
      tag2 = tag_fixture(name: "tag2")

      # Add the tag ids to the 'create_attrs' map.
      create_attrs_with_tags = Map.put(@create_attrs, :tags, [tag1.id, tag2.id])

      # Send a POST request to the 'create' action with the 'create_attrs_with_tags' map as the request body.
      conn = post(conn, Routes.book_path(conn, :create), book: create_attrs_with_tags)

      # Assert that the response is a redirect to the 'show' action with the new book's id as a parameter.
      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.book_path(conn, :show, id)

      # Send a GET request to the 'show' action with the new book's id as a parameter.
      conn = get(conn, Routes.book_path(conn, :show, id))

      # Assert that the response has a 200 status code and contains the tag names.
      response = html_response(conn, 200)
      assert response =~ "Show Book"
      assert response =~ tag1.name
      assert response =~ tag2.name
    end

    test "create a book with an associated author", %{conn: conn} do
      author = author_fixture()
      create_attrs_with_author = Map.put(@create_attrs, :author_id, author.id)

      conn = post(conn, Routes.book_path(conn, :create), book: create_attrs_with_author)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.book_path(conn, :show, id)

      conn = get(conn, Routes.book_path(conn, :show, id))

      response = html_response(conn, 200)

      assert response =~ "Show Book"
      assert response =~ author.name
    end

    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.book_path(conn, :create), book: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.book_path(conn, :show, id)

      conn = get(conn, Routes.book_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Book"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.book_path(conn, :create), book: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Book"
    end
  end

  describe "edit book" do
    setup [:create_book]

    test "renders form for editing chosen book", %{conn: conn, book: book} do
      conn = get(conn, Routes.book_path(conn, :edit, book))
      assert html_response(conn, 200) =~ "Edit Book"
    end
  end

  describe "update book" do
    setup [:create_book]

    # Test the 'update' action of the 'BookController' with a request that includes tags.
    test "update a book with tags", %{conn: conn, book: book} do
      # Create two tags.
      tag1 = tag_fixture(name: "tag1")
      tag2 = tag_fixture(name: "tag2")
      # Add the tag ids to the 'update_attrs' map.
      update_attrs_with_author = Map.put(@update_attrs, :tags, [tag1.id, tag2.id])

      # Send a PUT request to the 'update' action with the 'update_attrs_with_author' map as the request body and the book's id as a parameter.
      conn = put(conn, Routes.book_path(conn, :update, book), book: update_attrs_with_author)

      # Assert that the response is a redirect to the 'show' action with the book's id as a parameter.
      assert redirected_to(conn) == Routes.book_path(conn, :show, book)
      # Send a GET request to the 'show' action with the book's id as a parameter.
      conn = get(conn, Routes.book_path(conn, :show, book))

      # Assert that the response has a 200 status code and contains the expected text.
      response = html_response(conn, 200)
      assert response =~ "some updated title"
      assert response =~ tag1.name
      assert response =~ tag2.name
    end

    test "update a book with an associated author", %{conn: conn, book: book} do
      author = author_fixture()
      update_attrs_with_author = Map.put(@update_attrs, :author_id, author.id)

      conn = put(conn, Routes.book_path(conn, :update, book), book: update_attrs_with_author)
      assert redirected_to(conn) == Routes.book_path(conn, :show, book)
      conn = get(conn, Routes.book_path(conn, :show, book))

      response = html_response(conn, 200)

      assert response =~ "some updated title"
      assert response =~ author.name
    end

    test "redirects when data is valid", %{conn: conn, book: book} do
      conn = put(conn, Routes.book_path(conn, :update, book), book: @update_attrs)
      assert redirected_to(conn) == Routes.book_path(conn, :show, book)

      conn = get(conn, Routes.book_path(conn, :show, book))
      assert html_response(conn, 200) =~ "some updated title"
    end

    test "renders errors when data is invalid", %{conn: conn, book: book} do
      conn = put(conn, Routes.book_path(conn, :update, book), book: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Book"
    end
  end

  describe "delete book" do
    setup [:create_book]

    test "deletes chosen book", %{conn: conn, book: book} do
      conn = delete(conn, Routes.book_path(conn, :delete, book))
      assert redirected_to(conn) == Routes.book_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.book_path(conn, :show, book))
      end
    end
  end

  defp create_book(_) do
    book = book_fixture()
    %{book: book}
  end
end
