defmodule BookSearchWeb.BookController do
  use BookSearchWeb, :controller

  alias BookSearch.Books
  alias BookSearch.Books.Book

  def index(conn, %{"author_id" => author_id}) do
    books = Books.list_books(author_id)
    render(conn, "index.html", books: books, author_id: author_id)
  end

  def index(conn, %{"title" => title}) do
    books = Books.list_books(title: title)
    render(conn, "index.html", books: books)
  end

  def index(conn, _params) do
    books = Books.list_books()
    render(conn, "index.html", books: books)
  end

  def new(conn, %{"author_id" => author_id}) do
    changeset = Books.change_book(%Book{})
    render(conn, "new.html", changeset: changeset, author_id: author_id)
  end

  def create(conn, %{"book" => book_params, "author_id" => author_id}) do
    author = BookSearch.Authors.get_author!(author_id)

    case Books.create_book(Map.put(book_params, :author, author)) do
      {:ok, book} ->
        conn
        |> put_flash(:info, "Book created successfully.")
        |> redirect(to: Routes.author_book_path(conn, :show, author_id, book))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, author_id: author_id)
    end
  end

  def show(conn, %{"id" => id, "author_id" => author_id}) do
    book = Books.get_book!(id)
    render(conn, "show.html", author_id: author_id, book: book)
  end

  def edit(conn, %{"id" => id, "author_id" => author_id}) do
    book = Books.get_book!(id)
    changeset = Books.change_book(book)
    render(conn, "edit.html", book: book, changeset: changeset, author_id: author_id)
  end

  def update(conn, %{"id" => id, "book" => book_params, "author_id" => author_id}) do
    book = Books.get_book!(id)

    case Books.update_book(book, book_params) do
      {:ok, book} ->
        conn
        |> put_flash(:info, "Book updated successfully.")
        |> redirect(to: Routes.author_book_path(conn, :show, author_id, book))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", book: book, changeset: changeset, author_id: author_id)
    end
  end

  def delete(conn, %{"id" => id, "author_id" => author_id}) do
    book = Books.get_book!(id)
    {:ok, _book} = Books.delete_book(book)

    conn
    |> put_flash(:info, "Book deleted successfully.")
    |> redirect(to: Routes.author_book_path(conn, :index, author_id))
  end
end
