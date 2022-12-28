defmodule BookSearchWeb.BookController do
  use BookSearchWeb, :controller

  alias BookSearch.Authors
  alias BookSearch.Books
  alias BookSearch.Books.Book
  alias BookSearch.Tags

  def index(conn, _params) do
    books = Books.list_books() |> BookSearch.Repo.preload([:author])
    render(conn, "index.html", books: books)
  end

  def new(conn, _params) do
    changeset = Books.change_book(%Book{})
    authors = Authors.list_authors()
    render(conn, "new.html", changeset: changeset, authors: authors)
  end

  def create(conn, %{"book" => book_params}) do
    # Extract the 'tags' field from the 'book_params' map and assign its value to the 'tag_ids' variable.
    # If the 'tags' field is not present, assign an empty list to 'tag_ids'.
    # The remaining key-value pairs in the 'book_params' map are assigned to the 'book_params' variable.
    {tag_ids, book_params} = Map.pop(book_params, "tags", [])
    # Use the 'Enum.map/2' function to transform the 'tag_ids' list into a list of 'Tag' structs.
    # The '&Tags.get_tag!/1' function is passed to the '&' operator and used as the iterator function.
    tags = Enum.map(tag_ids, &Tags.get_tag!/1)

    case Books.create_book(book_params, tags) do
      {:ok, book} ->
        conn
        |> put_flash(:info, "Book created successfully.")
        |> redirect(to: Routes.book_path(conn, :show, book))

      {:error, %Ecto.Changeset{} = changeset} ->
        authors = Authors.list_authors()
        render(conn, "new.html", changeset: changeset, authors: authors)
    end
  end

  def show(conn, %{"id" => id}) do
    book = Books.get_book!(id) |> BookSearch.Repo.preload([:author, :tags, :book_content])
    render(conn, "show.html", book: book)
  end

  def edit(conn, %{"id" => id}) do
    book = Books.get_book!(id) |> BookSearch.Repo.preload(:book_content)

    # Use the 'Enum.map/2' function to transform the 'tags' field of the 'book' struct into a list of tag ids.
    # The '& &1.id' function is passed to the '&' operator and used as the iterator function.
    tag_ids = Enum.map(book.tags, & &1.id)

    changeset = Books.change_book(book)
    authors = Authors.list_authors()

    render(conn, "edit.html", book: book, changeset: changeset, authors: authors, tag_ids: tag_ids)
  end

  def update(conn, %{"id" => id, "book" => book_params}) do
    book = Books.get_book!(id)

    # Extract the 'tags' field from the 'book_params' map and assign its value to the 'tag_ids' variable.
    # If the 'tags' field is not present, assign an empty list to 'tag_ids'.
    # The remaining key-value pairs in the 'book_params' map are assigned to the 'book_params' variable.
    {tag_ids, book_params} = Map.pop(book_params, "tags", [])
    # Use the 'Enum.map/2' function to transform the 'tag_ids' list into a list of 'Tag' structs.
    # The '&Tags.get_tag!/1' function is passed to the '&' operator and used as the iterator function.
    tags = Enum.map(tag_ids, &Tags.get_tag!/1)

    case Books.update_book(book, book_params, tags) do
      {:ok, book} ->
        conn
        |> put_flash(:info, "Book updated successfully.")
        |> redirect(to: Routes.book_path(conn, :show, book))

      {:error, %Ecto.Changeset{} = changeset} ->
        authors = Authors.list_authors()
        render(conn, "edit.html", book: book, changeset: changeset, authors: authors)
    end
  end

  def delete(conn, %{"id" => id}) do
    book = Books.get_book!(id)
    {:ok, _book} = Books.delete_book(book)

    conn
    |> put_flash(:info, "Book deleted successfully.")
    |> redirect(to: Routes.book_path(conn, :index))
  end
end
