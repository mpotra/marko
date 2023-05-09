defmodule Marko.Config do
  @moduledoc """
  Module that provides configuration variables out of .env files
  and system environment variables, using Vapor.

  The loading order from .env files is explained at
  https://hexdocs.pm/vapor/Vapor.Provider.Dotenv.html#module-file-hierarchy

  If there is a system environment variable defined, loading it from
  any .env files will not override it.

  All variables loaded via Vapor.Provider.Dotenv are available
  as system environment variables, using System.get_env or System.fetch_env
  """

  @doc """
  Load environment variables from .env files and system environment.
  Bindings without a default defined will raise an exception, if the variable
  is missing from both the .env files and the system environment.
  """
  def load!() do
    config =
      Vapor.load!([
        %Vapor.Provider.Dotenv{},
        %Vapor.Provider.Env{
          bindings: [
            # Database/Repo bindings
            {:db_url, "DATABASE_URL", map: &parse_database_url/1},
            {:db_pool_size, "DATABASE_POOL_SIZE", default: 10, map: &String.to_integer/1},
            {:db_ssl, "DATABASE_SSL", required: false, map: &to_boolean/1},
            {:ecto_ipv6, "ECTO_IPV6", default: false, required: false, map: &to_boolean/1},

            # Endpoint configs
            {:ip, "IP", default: "127.0.0.1", required: false},
            {:port, "PORT", required: true, map: &String.to_integer/1},
            {:host, "PHX_HOST", default: "localhost", required: false},
            {:server, "PHX_SERVER", required: false},
            {:secret_key_base, "SECRET_KEY_BASE"},
            {:cookie_domain, "COOKIE_DOMAIN", required: false},

            # Mailgun
            {:mailgun_api_key, "MAILGUN_API_KEY"}
          ]
        }
      ])

    maybe_ipv6 = if Map.get(config, :ecto_ipv6) == true, do: [:inet6], else: []

    repo_config =
      [
        url: Map.get(config, :db_url),
        pool_size: Map.get(config, :db_pool_size),
        socket_options: maybe_ipv6
      ]
      |> keyword_put_unless(:ssl, {config, :db_ssl}, nil)

    session_config = [
      domain: Map.get(config, :cookie_domain)
    ]

    endpoint_http =
      case get_ip!(config, :ip) do
        nil -> []
        ip -> [ip: ip]
      end

    endpoint_http =
      if Map.get(config, :port) do
        Keyword.put(endpoint_http, :port, Map.get(config, :port))
      else
        endpoint_http
      end

    endpoint_config = [
      secret_key_base: Map.get(config, :secret_key_base),
      session: session_config,
      url: [host: Map.get(config, :host)],
      http: endpoint_http
    ]

    endpoint_config =
      if Map.get(config, :server) do
        Keyword.put(endpoint_config, :server, true)
      else
        endpoint_config
      end

    config
    |> Map.drop([:db_url, :db_pool_size, :db_ssl, :ecto_ipv6])
    |> Map.put(:repo, repo_config)
    |> Map.drop([:secret_key_base])
    |> Map.put(:endpoint, endpoint_config)
  end

  defp get_ip!(source, key) do
    ip = Map.get(source, key)

    source
    |> Map.get(key)
    |> case do
      nil -> {:ok, nil}
      ip -> :inet.parse_address(ip)
    end

    if ip do
      parse_ip!(ip)
    else
      nil
    end
  end

  defp parse_ip!(ip) when is_binary(ip) do
    ip
    |> String.to_charlist()
    |> :inet.parse_address()
    |> case do
      {:ok, value} -> value
      {:error, _} -> raise "Invalid IP address #{ip}"
    end
  end

  defp keyword_put_unless(keywords, key, {source, source_key}, unless_value, default_value \\ nil)
       when is_map(source) do
    case Map.get(source, source_key, default_value) do
      ^unless_value -> keywords
      value -> Keyword.put(keywords, key, value)
    end
  end

  # Mapping function that allows replacing the `#{MIX_TEST_PARTITION} keyword
  # with the MIX_TEST_PARTITION variable set in either the .env files or
  # the system environment
  defp parse_database_url(value) do
    partition = System.get_env("MIX_TEST_PARTITION", "")
    String.replace(value, "\#{MIX_TEST_PARTITION}", partition)
  end

  defp to_boolean(value) when is_boolean(value) do
    value
  end

  # Converts a string boolean value into a boolean.
  defp to_boolean(value) when is_binary(value) do
    value
    |> String.downcase()
    |> case do
      "true" -> true
      "false" -> false
      _ -> false
    end
  end
end
