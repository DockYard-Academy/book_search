defmodule BookSearch.Repo do
  use Ecto.Repo,
    otp_app: :book_search,
    adapter: Ecto.Adapters.Postgres
end
