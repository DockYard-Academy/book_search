defmodule BookSearch.Repo.Migrations.CreateBookContent do
  use Ecto.Migration

  def change do
    create table(:book_content) do
      add :full_text, :text
      add :book_id, references(:books, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:book_content, [:book_id])
  end
end
