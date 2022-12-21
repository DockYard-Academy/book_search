defmodule BookSearch.Books.Book do
  # Use the Ecto.Schema module to define a schema for the 'books' table
  use Ecto.Schema
  # Import the Ecto.Changeset module for use in the changeset function
  import Ecto.Changeset

  # Define the schema for the 'books' table
  schema "books" do
    # Add a 'title' column of type 'string'
    field :title, :string
    # Add a foreign key column named 'author_id' that references the 'authors' table
    belongs_to :author, BookSearch.Authors.Author
    # Add a many-to-many relationship with the 'tags' table through the 'book_tags' join table
    many_to_many :tags, BookSearch.Tags.Tag, join_through: "book_tags", on_replace: :delete

    # Add timestamps for the 'inserted_at' and 'updated_at' columns
    timestamps()
  end

  # Define a changeset function for updating books
  @doc false
  def changeset(book, attrs, tags \\ []) do
    # Cast the 'attrs' map to include only the 'title' and 'author_id' fields
    book
    |> cast(attrs, [:title, :author_id])
    # Update the many-to-many relationship with the 'tags' table
    |> put_assoc(:tags, tags)
    # Validate that the 'title' field is present
    |> validate_required([:title])
  end
end
