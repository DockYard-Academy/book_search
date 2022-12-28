defmodule BookSearch.Seeds do
  alias BookSearch.Authors
  alias BookSearch.Authors.Author
  alias BookSearch.Books
  alias BookSearch.Books.Book
  alias BookSearch.Tags
  alias BookSearch.Tags.Tag
  alias BookSearch.Repo

  def seed do
    seed_author()
    seed_book()
    seed_author_with_book()
    seed_tags()
  end

  def seed_author do
    case Repo.get_by(Author, name: "Andrew Rowe") do
      %Author{} = author ->
        IO.inspect(author.name, label: "Author Already Created")

      nil ->
        Authors.create_author(%{name: "Andrew Rowe"})
    end
  end

  def seed_book() do
    case Repo.get_by(Book, title: "Beowulf") do
      %Book{} = book ->
        IO.inspect(book.title, label: "Book Already Created")

      nil ->
        Books.create_book(%{title: "Beowulf"})
    end
  end

  # Create an author with a book.
  def seed_author_with_book do
    {:ok, author} =
      case Repo.get_by(Author, name: "Patrick Rothfuss") do
        %Author{} = author ->
          IO.inspect(author.name, label: "Author Already Created")
          {:ok, author}

        nil ->
          Authors.create_author(%{name: "Patrick Rothfuss"})
      end

    case Repo.get_by(Book, title: "Name of the Wind") do
      %Book{} = book ->
        IO.inspect(book.title, label: "Book Already Created")

      nil ->
        %Book{}
        |> Book.changeset(%{title: "Name of the Wind"})
        |> Ecto.Changeset.put_assoc(:author, author)
        |> Repo.insert!()
    end
  end

  def seed_tags do
    # Create tags
    ["fiction", "fantasy", "history", "sci-fi"]
    |> Enum.each(fn tag_name ->
      case Repo.get_by(Tag, name: tag_name) do
        %Tag{} = _tag ->
          IO.inspect(tag_name, label: "Tag Already Created")

        nil ->
          Tags.create_tag(%{name: tag_name})
      end
    end)
  end
end
