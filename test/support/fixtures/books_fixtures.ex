defmodule BookSearch.BooksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BookSearch.Books` context.
  """

  @doc """
  Generate a book.
  """
  def book_fixture(attrs \\ %{}) do
    {:ok, book} =
      attrs
      |> Enum.into(%{
        title: "some title"
      })
      |> BookSearch.Books.create_book()

    book
  end
end
