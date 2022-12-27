defmodule BookSearch.Books.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    field :title, :string
    belongs_to :author, BookSearch.Authors.Author
    has_one :book_content, BookSearch.Books.BookContent
    many_to_many :tags, BookSearch.Tags.Tag, join_through: "book_tags", on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(book, attrs, tags \\ []) do
    book
    |> cast(attrs, [:title, :author_id])
    |> validate_required([:title])
    |> put_assoc(:tags, tags)
    |> cast_assoc(:book_content)
  end
end
