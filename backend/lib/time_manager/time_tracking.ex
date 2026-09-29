defmodule TimeManager.TimeTracking do
  @moduledoc """
  The TimeTracking context.
  """

  import Ecto.Query, warn: false
  alias TimeManager.Repo

  alias TimeManager.TimeTracking.Clock

  @doc """
  Returns the list of clocks.

  ## Examples

      iex> list_clocks()
      [%Clock{}, ...]

  """
  def list_clocks do
    Repo.all(Clock)
  end

  @doc """
  Gets a single clock.

  Raises `Ecto.NoResultsError` if the Clock does not exist.

  ## Examples

      iex> get_clock!(123)
      %Clock{}

      iex> get_clock!(456)
      ** (Ecto.NoResultsError)

  """
  def get_clock!(id), do: Repo.get!(Clock, id)

  @doc """
  Creates a clock.

  ## Examples

      iex> create_clock(%{field: value})
      {:ok, %Clock{}}

      iex> create_clock(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

def list_clocks_by_user(user_id) do
  Clock
  |> where([c], c.user_id == ^user_id)
  |> order_by([c], asc: c.time)
  |> Repo.all()
end

def toggle_clock(user_id) do
  last_clock =
    Clock
    |> where([c], c.user_id == ^user_id)
    |> order_by([c], desc: c.time)
    |> limit(1)
    |> Repo.one()

  next_status =
    case last_clock do
      nil -> true
      %Clock{status: true} -> false
      %Clock{status: false} -> true
    end

  %Clock{}
  |> Clock.changeset(%{"time" => DateTime.utc_now() |> DateTime.truncate(:second), "status" => next_status, "user_id" => user_id})
  |> Repo.insert()
end
  def create_clock(attrs) do
    %Clock{}
    |> Clock.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a clock.

  ## Examples

      iex> update_clock(clock, %{field: new_value})
      {:ok, %Clock{}}

      iex> update_clock(clock, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_clock(%Clock{} = clock, attrs) do
    clock
    |> Clock.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a clock.

  ## Examples

      iex> delete_clock(clock)
      {:ok, %Clock{}}

      iex> delete_clock(clock)
      {:error, %Ecto.Changeset{}}

  """
  def delete_clock(%Clock{} = clock) do
    Repo.delete(clock)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking clock changes.

  ## Examples

      iex> change_clock(clock)
      %Ecto.Changeset{data: %Clock{}}

  """
  def change_clock(%Clock{} = clock, attrs \\ %{}) do
    Clock.changeset(clock, attrs)
  end

  alias TimeManager.TimeTracking.WorkingTime

  @doc """
  Returns the list of workingtimes.

  ## Examples

      iex> list_workingtimes()
      [%WorkingTime{}, ...]

  """
  def list_workingtimes do
    Repo.all(WorkingTime)
  end

  @doc """
  Gets a single working_time.

  Raises `Ecto.NoResultsError` if the Working time does not exist.

  ## Examples

      iex> get_working_time!(123)
      %WorkingTime{}

      iex> get_working_time!(456)
      ** (Ecto.NoResultsError)

  """
  def get_working_time!(id), do: Repo.get!(WorkingTime, id)

  @doc """
  Creates a working_time.

  ## Examples

      iex> create_working_time(%{field: value})
      {:ok, %WorkingTime{}}

      iex> create_working_time(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_working_time(attrs) do
    %WorkingTime{}
    |> WorkingTime.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a working_time.

  ## Examples

      iex> update_working_time(working_time, %{field: new_value})
      {:ok, %WorkingTime{}}

      iex> update_working_time(working_time, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_working_time(%WorkingTime{} = working_time, attrs) do
    working_time
    |> WorkingTime.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a working_time.

  ## Examples

      iex> delete_working_time(working_time)
      {:ok, %WorkingTime{}}

      iex> delete_working_time(working_time)
      {:error, %Ecto.Changeset{}}

  """
  def delete_working_time(%WorkingTime{} = working_time) do
    Repo.delete(working_time)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking working_time changes.

  ## Examples

      iex> change_working_time(working_time)
      %Ecto.Changeset{data: %WorkingTime{}}

  """
  def change_working_time(%WorkingTime{} = working_time, attrs \\ %{}) do
    WorkingTime.changeset(working_time, attrs)
  end

def list_working_times_by_user(user_id, params \\ %{}) do
  WorkingTime
  |> where([w], w.user_id == ^user_id)
  |> filter_by_start(params)
  |> filter_by_end(params)
  |> Repo.all()
end

defp filter_by_start(query, %{"start" => start}) when start not in [nil, ""] do
  {:ok, start_dt, _} = DateTime.from_iso8601(start <> "Z")
  from w in query, where: w.start >= ^start_dt
end
defp filter_by_start(query, _params), do: query

defp filter_by_end(query, %{"end" => end_param}) when end_param not in [nil, ""] do
  {:ok, end_dt, _} = DateTime.from_iso8601(end_param <> "Z")
  from w in query, where: w.end <= ^end_dt
end
defp filter_by_end(query, _params), do: query

def get_working_time_for_user!(user_id, id) do
  Repo.get_by!(WorkingTime, id: id, user_id: user_id)
end

def create_working_time_for_user(user_id, attrs) do
  attrs = Map.put(attrs, "user_id", user_id)

  %WorkingTime{}
  |> WorkingTime.changeset(attrs)
  |> Repo.insert()
end
end
