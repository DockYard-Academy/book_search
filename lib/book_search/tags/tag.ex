defmodule BookSearch.Tags.Tag do
  # Use the Ecto.Schema module to define a schema for the 'tags' table
  use Ecto.Schema
  # Import the Ecto.Changeset module for use in the changeset function
  import Ecto.Changeset

  # Define the schema for the 'tags' table
  schema "tags" do
    # Add a 'name' column of type 'string'
    field :name, :string
    # Add a many-to-many relationship with the 'books' table through the 'book_tags' join table
    many_to_many :books, BookSearch.Books.Book, join_through: "book_tags", on_replace: :delete

    # Add timestamps for the 'inserted_at' and 'updated_at' columns
    timestamps()
  end

  # Define a changeset function for updating tags
  @doc false
  def changeset(tag, attrs) do
    # Cast the 'attrs' map to include only the 'name' field
    tag
    |> cast(attrs, [:name])
    # Validate that the 'name' field is present
    |> validate_required([:name])
  end
end
