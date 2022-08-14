defmodule BookSearch.Books.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    field :title, :string
    belongs_to :author, BookSearch.Authors.Author
    many_to_many :tags, BookSearch.Tags.Tag, join_through: "book_tags", on_replace: :delete
    has_one :book_contents, BookSearch.Books.BookContents, on_replace: :update
    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
