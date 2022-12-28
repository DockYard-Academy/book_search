defmodule BookSearchWeb.TagControllerTest do
  use BookSearchWeb.ConnCase

  import BookSearch.AuthorsFixtures
  import BookSearch.BooksFixtures
  import BookSearch.TagsFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  describe "index" do
    test "lists all tags", %{conn: conn} do
      conn = get(conn, Routes.tag_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Tags"
    end
  end

  # Test the 'show' action of the 'TagController'.
  describe "show" do
    # Test the 'show' action with a tag fixture that has an associated book.
    test "tag with associated book", %{conn: conn} do
      # Create a tag.
      tag = tag_fixture()
      # Create an author.
      author = author_fixture()
      # Create a book fixture with the associated tag and author.
      book = book_fixture([author: author], [tag])

      # Send a GET request to the 'show' action with the tag's id as a parameter.
      conn = get(conn, Routes.tag_path(conn, :show, tag))

      # Assert that the response has a 200 status code and contains the expected text.
      response = html_response(conn, 200)
      assert response =~ tag.name
      assert response =~ author.name
      assert response =~ book.title
    end
  end

  describe "new tag" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.tag_path(conn, :new))
      assert html_response(conn, 200) =~ "New Tag"
    end
  end

  describe "create tag" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.tag_path(conn, :create), tag: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.tag_path(conn, :show, id)

      conn = get(conn, Routes.tag_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Tag"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.tag_path(conn, :create), tag: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Tag"
    end
  end

  describe "edit tag" do
    setup [:create_tag]

    test "renders form for editing chosen tag", %{conn: conn, tag: tag} do
      conn = get(conn, Routes.tag_path(conn, :edit, tag))
      assert html_response(conn, 200) =~ "Edit Tag"
    end
  end

  describe "update tag" do
    setup [:create_tag]

    test "redirects when data is valid", %{conn: conn, tag: tag} do
      conn = put(conn, Routes.tag_path(conn, :update, tag), tag: @update_attrs)
      assert redirected_to(conn) == Routes.tag_path(conn, :show, tag)

      conn = get(conn, Routes.tag_path(conn, :show, tag))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, tag: tag} do
      conn = put(conn, Routes.tag_path(conn, :update, tag), tag: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Tag"
    end
  end

  describe "delete tag" do
    setup [:create_tag]

    test "deletes chosen tag", %{conn: conn, tag: tag} do
      conn = delete(conn, Routes.tag_path(conn, :delete, tag))
      assert redirected_to(conn) == Routes.tag_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.tag_path(conn, :show, tag))
      end
    end
  end

  defp create_tag(_) do
    tag = tag_fixture()
    %{tag: tag}
  end
end
