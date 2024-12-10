# LeakCheck

An unofficial Elixir client for the [LeakCheck.io](https://leakcheck.io) API v2. Search for leaked credentials and data breaches efficiently and securely.

## Disclaimer

This is an **unofficial** client library for LeakCheck.io. It is not created, maintained, or endorsed by LeakCheck. For the official API documentation and support, please visit [LeakCheck.io](https://leakcheck.io).

## Attribution

This client library interfaces with LeakCheck.io's API service. LeakCheck.io is a powerful data breach search engine that provides comprehensive credential monitoring services. Visit their website at [LeakCheck.io](https://leakcheck.io) for more information about their services.

## Installation

Add `leak_check` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:leak_check, "~> 0.1.0"}
  ]
end

Authentication
Obtain your API key from LeakCheck account settings. The key should be passed in the "X-API-Key" header, which this client handles automatically.
Usage
Basic Query
elixir

# Automatic type detection
{:ok, results} = LeakCheck.query("example@example.com", "your_api_key")

# With specific type
{:ok, results} = LeakCheck.query("example.com", "your_api_key", type: "domain")

# With pagination
{:ok, results} = LeakCheck.query("example", "your_api_key",
  type: "keyword",
  limit: 100,
  offset: 0
)

Search Types
Type	Example	Description
auto	example@example.com	Automatically detects email, username, phone number, or hash
email	example@example.com	Search by email address
domain	gmail.com	Search by domain name
keyword	example	Search by keyword
username	example	Search by username
phone	12063428631	Search by phone number
hash	31c5543c1734d25c7206f5fd	SHA256 hash of lower-cased email (can be truncated to 24 chars)
phash*	31c5543c1734d25c7206f5fd	SHA256 hash of password (Enterprise only)
origin*	example.com	Search by origin (Enterprise only)
password*	example	Search by password (Enterprise only)
*Enterprise features
Response Format
Successful response:
elixir

{:ok, %{
  "success" => true,
  "found" => 1,
  "quota" => 400,
  "result" => [
    %{
      "email" => "example@example.com",
      "source" => %{
        "name" => "BreachedWebsite.net",
        "breach_date" => "2019-07",
        "unverified" => 0,
        "passwordless" => 0,
        "compilation" => 0
      },
      "first_name" => "Example",
      "last_name" => "Example",
      "username" => "leakcheck",
      "fields" => ["first_name", "last_name", "username"]
    }
  ]
}}

Empty response:
elixir

{:ok, %{
  "success" => true,
  "found" => 0,
  "quota" => 400,
  "result" => []
}}

Error Handling
The client returns {:error, reason} for various error cases:
Error	Status Code
Missing API Key	401
Invalid API Key	400
Invalid Type	400
Invalid Email	400
Invalid Query	400
Invalid Domain	400
Too Short Query	400
Invalid Characters	400
Too Many Requests	429
Active Plan Required	403
Limit Reached	403
Cannot Determine Type	422
Limitations

    Default rate limit: 3 requests per second (adjustable in settings)
    Maximum limit per query: 1000 results
    Maximum offset: 2500 results
    Minimum query length: 3 characters
```

## Legal

- This is an unofficial client library and is not affiliated with LeakCheck.io
- LeakCheck is a trademark of LeakCheck.io
- All rights to the LeakCheck API and service belong to LeakCheck.io



