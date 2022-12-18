# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     BookSearch.Repo.insert!(%BookSearch.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias BookSearch.Authors
alias BookSearch.Authors.Author
alias BookSearch.Books
alias BookSearch.Books.Book
alias BookSearch.Repo

# author without books
Authors.create_author(%{name: Faker.Lorem.sentence(10)})

# book without author
Books.create_book(%{title: Faker.Lorem.sentence(10)})

# author with a book
{:ok, author} = Authors.create_author(%{name: Faker.Lorem.sentence(10)})

Enum.each(1..10, fn _ ->
  %Book{}
  |> Book.changeset(%{title: Faker.Lorem.sentence(10)})
  |> Ecto.Changeset.put_assoc(:author, author)
  |> Repo.insert!()
end)
