defmodule BookSearch.Books do
  @moduledoc """
  The Books context.
  """

  import Ecto.Query, warn: false
  alias BookSearch.Repo

  alias BookSearch.Books.Book

  @doc """
  Returns the list of books.

  ## Examples

      iex> list_books()
      [%Book{}, ...]

  """
  def list_books do
    Book
    |> preload(:author)
    |> Repo.all()
  end

  def list_books(title: title, tags: tag_ids) do
    search = "%#{title}%"

    query =
      Book
      |> preload(:author)
      |> where([book], ilike(book.title, ^search))

    query =
      case tag_ids do
        [] ->
          query

        tag_ids ->
          query
          |> join(:inner, [book], tag in assoc(book, :tags))
          |> where([book, tag], tag.id in ^tag_ids)
      end

    Repo.all(query)
  end

  def list_books(author_id) do
    Book
    |> preload(:author)
    |> where([book], book.author_id == ^author_id)
    |> Repo.all()
  end

  @doc """
  Gets a single book.

  Raises `Ecto.NoResultsError` if the Book does not exist.

  ## Examples

      iex> get_book!(123)
      %Book{}

      iex> get_book!(456)
      ** (Ecto.NoResultsError)

  """
  def get_book!(id), do: Book |> preload([:tags, :book_contents]) |> Repo.get!(id)

  @doc """
  Creates a book.

  ## Examples

      iex> create_book(%{field: value})
      {:ok, %Book{}}

      iex> create_book(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_book(attrs \\ %{}) do
    {author, attrs} = Map.pop!(attrs, :author)
    {tags, attrs} = Map.pop(attrs, :tags, [])

    author
    |> Ecto.build_assoc(:books)
    |> Book.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:tags, tags)
    |> Ecto.Changeset.cast_assoc(:book_contents)
    |> Repo.insert()
  end

  @doc """
  Updates a book.

  ## Examples

      iex> update_book(book, %{field: new_value})
      {:ok, %Book{}}

      iex> update_book(book, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_book(%Book{} = book, attrs) do
    {tags, attrs} = Map.pop(attrs, :tags, [])

    book
    |> Book.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:tags, tags)
    |> Ecto.Changeset.cast_assoc(:book_contents)
    |> Repo.update()
  end

  @doc """
  Deletes a book.

  ## Examples

      iex> delete_book(book)
      {:ok, %Book{}}

      iex> delete_book(book)
      {:error, %Ecto.Changeset{}}

  """
  def delete_book(%Book{} = book) do
    Repo.delete(book)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking book changes.

  ## Examples

      iex> change_book(book)
      %Ecto.Changeset{data: %Book{}}

  """
  def change_book(%Book{} = book, attrs \\ %{}) do
    Book.changeset(book, attrs)
  end
end
