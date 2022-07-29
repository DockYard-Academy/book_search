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

alias BookSearch.Tags
alias BookSearch.Authors
alias BookSearch.Books

if Mix.env() == :dev do
  {:ok, author1} = BookSearch.Authors.create_author(%{name: "Patrick Rothfuss"})
  {:ok, author2} = BookSearch.Authors.create_author(%{name: "Dennis E Taylor"})

  BookSearch.Books.create_book(%{name: "Name of the Wind", author: author1})
  BookSearch.Books.create_book(%{name: "We are Legend (We are Bob)", author: author2})

  ["fiction", "fantasy", "history", "sci-fi"]
  |> Enum.each(fn tag_name ->
    BookSearch.Tags.create_tag(%{name: tag_name})
  end)
end
