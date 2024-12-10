defmodule LeakCheck do
  @base_url "https://leakcheck.io/api/v2"

  @doc """
  Performs a query to the LeakCheck API and returns the raw JSON response as a map.

  Options:
    * :type - Search type (optional): "auto", "email", "domain", "keyword", etc.
    * :limit - Maximum number of results (optional, max 1000)
    * :offset - Results offset (optional, max 2500)
  """
  def query(search_term, api_key, opts \\ []) do
    type = Keyword.get(opts, :type, "auto")
    limit = Keyword.get(opts, :limit)
    offset = Keyword.get(opts, :offset)

    query_params = build_query_params(type, limit, offset)

    Req.new(
      base_url: @base_url,
      headers: [
        {"accept", "application/json"},
        {"x-api-key", api_key}
      ]
    )
    |> Req.get(
      url: "/query/#{URI.encode(search_term)}",
      params: query_params
    )
    |> handle_response()
  end

  defp handle_response({:ok, %Req.Response{status: 200, body: body}}) do
    IO.inspect(body, label: "Decoded API Response")
    {:ok, body}
  end

  defp handle_response({:ok, %Req.Response{status: status, body: body}}) do
    {:error, "Request failed with status code: #{status}, body: #{inspect(body)}"}
  end

  defp handle_response({:error, exception}) do
    {:error, "Request failed: #{Exception.message(exception)}"}
  end

  defp build_query_params(type, limit, offset) do
    %{}
    |> maybe_add_param("type", type)
    |> maybe_add_param("limit", limit)
    |> maybe_add_param("offset", offset)
  end

  defp maybe_add_param(params, _key, nil), do: params
  defp maybe_add_param(params, key, value), do: Map.put(params, key, value)
end

