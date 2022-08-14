defmodule BookSearch.Books.BookContents do
  use Ecto.Schema
  import Ecto.Changeset

  schema "book_contents" do
    field :content, :string
    belongs_to :book, BookSearch.Books.Book

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:content])
    |> validate_required([:content])
  end
end
