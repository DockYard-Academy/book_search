defmodule BookSearch.Repo.Migrations.CreateBookContents do
  use Ecto.Migration

  def change do
    create table(:book_contents) do
      add :content, :text, null: false
      add :book_id, references(:books, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:book_contents, [:book_id])
  end
end
