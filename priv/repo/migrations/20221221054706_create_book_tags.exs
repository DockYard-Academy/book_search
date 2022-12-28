defmodule BookSearch.Repo.Migrations.CreateBookTags do
  # Use the Ecto.Migration module to create a database migration
  use Ecto.Migration

  def change do
    # Create a new table called 'book_tags'
    create table(:book_tags) do
      # Add a column named 'book_id' with a reference to the 'books' table
      add(:book_id, references(:books, on_delete: :delete_all), null: false)
      # Add a column named 'tag_id' with a reference to the 'tags' table
      add(:tag_id, references(:tags, on_delete: :delete_all), null: false)
    end

    # Create a unique index on the 'book_tags' table with the 'book_id' and 'tag_id' columns
    create(unique_index(:book_tags, [:book_id, :tag_id]))
  end
end
