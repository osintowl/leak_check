defmodule LeakCheck.Filter do
  @moduledoc """
  Provides filtering functions for leak entries.

  This module allows you to filter leak entries based on properties found in their `"source"` maps.
  It includes functions to:

    - Filter entries by the recency of their breach date (provided in `"YYYY-MM"` format).
      The recency is computed by subtracting a specified number of years from the current UTC date.
      By default, a 2-year threshold is used, but you can customize it using the `:years` option.

    - Filter entries based on whether they contain a password update.
      In this context, a `"passwordless"` field with a value of `0` indicates that the leak includes a
      password update.
  """

  @doc """
  Filters a list of leak entries to include only those with a valid `"source"` map
  containing a `"breach_date"` (formatted as `"YYYY-MM"`) that is within the allowed recency.

  The recency is determined by subtracting a number of years (from the current UTC date) as specified
  via the `:years` option. If no option is provided, a default of 2 years is used.

  ## Options

    - `:years` - The number of years (relative to the current UTC date) that define the allowed recency.
      Defaults to `2`.

  ## Examples

      iex> # Using the default threshold of 2 years:
      iex> LeakCheck.Filter.filter_recent(entries)
      # Returns entries filtered with a 2-year threshold
      
      iex> # Overriding the default threshold to 3 years:
      iex> LeakCheck.Filter.filter_recent(entries, years: 3)
      # Returns entries filtered with a 3-year threshold

  For these examples, ensure that `entries` is a list of leak entries where each entry's `"source"`
  map includes a `"breach_date"` in the `"YYYY-MM"` format.
  """
  def filter_recent(entries, opts \\ []) do
    # Retrieve the recency threshold from options, defaulting to 2 years.
    recency_years = Keyword.get(opts, :years, 2)

    # Get the current UTC date and subtract the recency (approximated as years * 365 days)
    current_date = DateTime.utc_now() |> DateTime.to_date()
    threshold_date = Date.add(current_date, -recency_years * 365)

    Enum.filter(entries, fn
      # Match entries with a valid "source" containing a non-nil, binary "breach_date"
      %{"source" => %{"breach_date" => date_str}} when is_binary(date_str) ->
        # Build a complete ISO8601 date string by appending "-01" to the provided "YYYY-MM" value.
        complete_date_str = date_str <> "-01"

        case Date.from_iso8601(complete_date_str) do
          {:ok, breach_date} ->
            # Keep the entry if its breach_date is newer than or equal to the threshold_date.
            Date.compare(breach_date, threshold_date) != :lt

          {:error, _reason} ->
            false
        end

      # Reject any entry that doesn't have the expected structure.
      _ -> false
    end)
  end

  @doc """
  Filters a list of leak entries to retain only those that include a password update.

  Within each leak entry, a `"passwordless"` value of `0` (inside the `"source"` map)
  signifies that the leak includes a password update. Any other value (or absence of the field)
  indicates that the leak does not have this characteristic.

  ## Examples

      iex> # Given a list of entries, only those with a "passwordless" value of 0 are retained:
      iex> LeakCheck.Filter.filter_passwordless(entries)
      # Returns entries that have "passwordless" equal to 0 in their "source" map.
  """
  def filter_passwordless(entries) do
    Enum.filter(entries, fn
      %{"source" => %{"passwordless" => passwordless}} when is_integer(passwordless) ->
        # A "passwordless" value of 0 indicates that the leak includes a password update.
        passwordless == 0

      _ ->
        false
    end)
  end
end
