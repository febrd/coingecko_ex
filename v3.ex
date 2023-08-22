defmodule Febrd.CoinGeckoApi do

  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://api.coingecko.com/api/v3/"
  @moduledoc """  plug Tesla.Middleware.Headers, [{"authorization", "Your  API TOKEN (Paid Version)"}] """
  plug Tesla.Middleware.JSON


   @moduledoc """
  Documentation for `CoinGeckoApi`.

  This interface is based on version 3 of the api.
  Base URL is "https://api.coingecko.com/api/v3/"

  """

  @cg_base_url "https://api.coingecko.com/api/v3/"
  @print_url false

  def get_api(api_path) do
    url = @cg_base_url <> api_path
    if @print_url, do: IO.puts url
    res = HTTPoison.get!(url)
    Poison.decode!(res.body)
  end

  def get_api_params(api_path,params \\%{}) do
    query_params = URI.encode_query(params)
    url = @cg_base_url <> api_path <> query_params
    if @print_url, do: IO.puts url
    res = HTTPoison.get!(url)
    Poison.decode!(res.body)
  end

  @doc """
  Ping API

  ## Examples

      iex(1)> CoinGeckoApi.ping
      %{"gecko_says" => "(V3) To the Moon!"}
  """
  def ping do
    get_api("ping")
  end

  @doc """
  Get the current price of any cryptocurrencies in any other supported currencies that you need.
  returns object like this:
  %{"bitcoin" => %{"usd" => 35861}}
  """

  def simple_price(params \\ %{"ids" => "bitcoin", "vs_currencies" => "usd", "include_market_cap" => "true", "include_24hr_vol" => "true", "include_24hr_change" => "true", "include_last_updated_at" => "true"}) do
    get_api_params("simple/price?", params)
  end

  @doc """
  Get current price of tokens (using contract addresses) for a given platform in any other currency that you need.
  returns object like this:
      %{
        "0xc00e94cb662c3520282e6f5717214004a7f26888" => %{
          "last_updated_at" => 1611109511,
          "usd" => 213.46,
          "usd_24h_change" => -6.384358204432436,
          "usd_24h_vol" => 87929838.57157373,
          "usd_market_cap" => 888756153.0997704
        }
      }
  """

  def simple_token_price(params \\ %{"contract_addresses" => "0xc00e94cb662c3520282e6f5717214004a7f26888", "vs_currencies" => "usd", "include_market_cap" => "true", "include_24hr_vol" => "true", "include_24hr_change" => "true", "include_last_updated_at" => "true"}) do
    get_api_params("simple/token_price/ethereum?", params)
  end

  @doc """
  Use this to obtain all the coins market data (price, market cap, volume)
  """

  def coins_markets(params \\ %{"vs_currency" => "usd", "ids" => "bitcoin", "order" => "market_cap_desc", "per_page" => "100", "sparkline" => "false"}) do
    get_api_params("coins/markets?", params)
  end

  @doc """
  Get current data (name, price, market, ... including exchange tickers) for a coin
  """
  def info_coin(nama_coin) do
    get_api_params("/coins/#{nama_coin}")
  end
  def coins(id \\ "bitcoin", params \\ %{"tickers" => "true", "market_data" => "true", "community_data" => "true", "developer_data" => "true", "sparkline" => "false"}) do
    get_api_params("coins/" <> id <> "?", params)
  end

  @doc """
  Get coin tickers (paginated to 100 items)
  """

  def coins_id_tickers(id \\ "bitcoin", params \\ %{}) do
    get_api_params("coins/" <> id <> "/tickers?", params)
  end

  @doc """
  Get historical data (name, price, market, stats) at a given date for a coin
  """

  def coins_id_history(id \\ "bitcoin", params \\ %{"date" => "01-01-2015"}) do
    get_api_params("coins/" <> id <> "/history?", params)
  end

  @doc """
  Get historical market data include price, market cap, and 24h volume (granularity auto)
  """

  def coins_id_market_chart(id \\ "bitcoin", params \\ %{"vs_currency" => "usd", "days" => "100"}) do
    get_api_params("coins/" <> id <> "/market_chart?", params)
  end

  @doc """
  Get historical market data include price, market cap, and 24h volume within a range of timestamp (granularity auto)
  """

  def coins_id_market_chart_range(id \\ "bitcoin", params \\ %{"vs_currency" => "usd", "from" => "1392577232", "to" => "1422577232"}) do
    get_api_params("coins/" <> id <> "/market_chart/range?", params)
  end

  @doc """
  Get status updates for a given coin (beta)
  """

  def coins_id_status_updates(id \\ "bitcoin", params \\ %{}) do
    get_api_params("coins/" <> id <> "/status_updates?", params)
  end

  @doc """
  Get coin's OHLC (beta)

  Candle’s body:

  1 - 2 days: 30 minutes
  3 - 30 days: 4 hours
  31 and before: 4 days
  """

  def coins_id_ohlc(id \\ "bitcoin", params \\ %{"vs_currency" => "usd", "days" => "90"}) do
    get_api_params("coins/" <> id <> "/ohlc?", params)
  end

  @doc """
  Get coin info from contract address
  """

  def coins_id_contract_contract_address(id \\ "ethereum", contract_address \\ "0xc00e94cb662c3520282e6f5717214004a7f26888") do
    get_api("coins/" <> id <> "/contract/" <> contract_address)
  end

  @doc """
  Get historical market data include price, market cap, and 24h volume (granularity auto) from a contract address
  """

  def coins_id_contract_contract_address_market_chart(id \\ "ethereum", contract_address \\ "0xc00e94cb662c3520282e6f5717214004a7f26888", params \\ %{"vs_currency" => "usd", "days" => "100"}) do
    get_api_params("coins/" <> id <> "/contract/" <> contract_address <> "/market_chart/?", params)
  end

  @doc """
  Get historical market data include price, market cap, and 24h volume (granularity auto) from a contract address
  """

  def coins_id_contract_contract_address_market_chart_range(id \\ "ethereum", contract_address \\ "0xc00e94cb662c3520282e6f5717214004a7f26888", params \\ %{"vs_currency" => "usd", "from" => "1392577232", "to" => "1422577232"}) do
    get_api_params("coins/" <> id <> "/contract/" <> contract_address <> "/market_chart/range?", params)
  end

  @doc """
  List all supported coins id, name and symbol (no pagination required)
  returns a list with objects like this:
  %{"id" => "1", "name" => "coin_name", "symbol" => "coin_symbol"}
  """

  def coins_list do
  url = "https://api.coingecko.com/api/v3/coins/list?include_platform=true"
  response = Tesla.get!(url, [])
  json = response.body |> Jason.decode!


  end

  def hot_coin do
    get_api("coins/")
    end
  @doc """
  Get list of supported_vs_currencies
  """

  def simple_supported_vs_currencies do
    get_api("simple/supported_vs_currencies")
  end

  @doc """
  List all exchanges
  """

  def exchanges do
    get_api("exchanges")
  end

  @doc """
  List all supported market id and name
  """

  def exchanges_list do
    get_api("exchanges")
  end

  @doc """
  get exchange volume in BTC and top 100 tickers only
  """

  def exchanges_id(id \\ "binance") do
    get_api("exchanges/" <> id)
  end

  @doc """
  get status updates for a given exchange (beta)
  """

  def exchanges_id_status_updates(id \\ "binance", params \\ %{}) do
    get_api_params("exchanges/" <> id <> "/status_updates", params)
  end

  @doc """
  Get volume_chart data for a given exchange (beta)
  """

  def exchanges_id_volume_chart(id \\ "binance", days \\ "100") do
    get_api("exchanges/" <> id <> "/volume_chart?days=" <> days)
  end

  @doc """
  List all finance platforms
  """

  def finance_platforms do
    get_api("finance_platforms")
  end

  @doc """
  List all finance products
  """



  @doc """
  Add NFTS beta version from coingecko
  """

  def nfts_list do
    get_api("nfts/list")

  end

  def detail_nfts(id_nfts \\ "akata-elite-club") do
    get_api("nfts/#{id_nfts}")

  end
def nfts_detail_collection(assets_platform_id \\ "ethereum", contract_address \\ "0xc3f733ca98e0dad0386979eb96fb1722a1a05e69") do
  get_api("nfts/#{assets_platform_id}/contract/#{contract_address}")
end

  def finance_products do
    get_api("finance_products")
  end

  @doc """
  List all market indexes
  """

  def indexes do
    get_api("indexes")
  end

  @doc """
  list market indexes id and name
  """

  def indexes_list do
    get_api("indexes/list")
  end

  @doc """
  List all derivative tickers
  """

  def derivatives do
    get_api("derivatives")
  end

  @doc """
  List all derivative exchanges
  """

  def derivatives_exchanges do
    get_api("derivatives/exchanges")
  end

  @doc """
  show derivative exchange data
  """

  def derivatives_exchanges_id(exchange_id \\ "bitmex") do
    get_api("derivatives/exchanges/" <> exchange_id)
  end

  @doc """
  List all derivative exchanges name and identifier
  """

  def derivatives_exchanges_list do
    get_api("derivatives/exchanges/list")
  end

  @doc """
  Get events, paginated by 100
  """

  def events(params \\ %{}) do
    get_api_params("events", params)
  end

  @doc """
  Get list of event countries
  """

  def events_countries do
    get_api("events/countries")
  end

  @doc """
  Get list of event types
  """

  def events_types do
    get_api("events/types")
  end

  @doc """
  get BTC-to-Currency exchange rates
  """

  def exchange_rates do
    get_api("exchange_rates")
  end

  @doc """
  Get trending search coins on coingecko from last 24 hours
  """
def search_assets(find_query \\ "") do
  get_api("search?query=#{find_query}")
end
  def search_trending do
    get_api("search/trending")
  end

  @doc """
  Get cryptocurrency global data
  """

  def global do
    get_api("global")
  end

  @doc """
  Get cryptocurrency global decentralized finance (defi_ data)
  """

  def global_decentralized_finance_defi do
    get_api("global/decentralized_finance_defi")
  end

end
