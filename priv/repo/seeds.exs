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
  {:ok, author1} = Authors.create_author(%{name: "Patrick Rothfuss"})
  {:ok, author2} = Authors.create_author(%{name: "Dennis E Taylor"})

  [tag1, tag2, tag3, tag4] =
    ["fiction", "fantasy", "history", "sci-fi"]
    |> Enum.map(fn tag_name ->
      {:ok, tag} = Tags.create_tag(%{name: tag_name})
      tag
    end)

  Books.create_book(%{title: "Name of the Wind", author: author1, tags: [tag1, tag2]})

  Books.create_book(%{
    title: "We are Legend (We are Bob)",
    author: author2,
    tags: [tag3, tag4]
  })
end
