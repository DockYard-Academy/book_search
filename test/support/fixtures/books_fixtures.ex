defmodule BookSearch.BooksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BookSearch.Books` context.
  """

  @doc """
  Generate a book.
  """
  def book_fixture(attrs \\ %{}, tags \\ []) do
    {:ok, book} =
      attrs
      |> Enum.into(%{
        title: "some title"
      })
      |> BookSearch.Books.create_book(tags)

    book
  end
end
