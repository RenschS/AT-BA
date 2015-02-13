require 'logger'
require 'httparty'
require 'active_support/all'

class MegFlurryAnalytics
  class InvalidCredentials<StandardError; end
  attr_reader :api_access_code, :iphone_api_key,
              :ipad_api_key, :android_api_key,
              :logger

  def initialize(options)

    @api_access_code = options.fetch("flurry_api_access_code", get_access_code)
    @iphone_api_key  = options.fetch("flurry_iphone_api_key",  "")
    @ipad_api_key    = options.fetch("flurry_ipad_api_key",    "")
    @android_api_key = options.fetch("flurry_android_api_key", "")
    @title = options.fetch("title", "Flurry Analytics")
    @timestamp = options.fetch("timestamp", Time.now.to_s(:short))
    @logger = options.fetch("logger", Logger.new('/dev/null'))
    if defined?(Rails) && Rails.env.production?
      @retry_interval = 1
      @max_retries    = 10
    else
      @retry_interval = 0
      @max_retries    = 5
    end


    raise(InvalidCredentials.new("invalid api_access_code")) if @api_access_code.size != 20
  end

  def all(from=(Time.now-1.year+1.day).strftime("%Y-%m-%d"), to=Time.now.strftime("%Y-%m-%d"))
    [["iPhone", iphone(from, to)], ["Android", android(from, to)], {
        name: 'iPad',
        y: ipad(from, to),
        sliced: true,
        selected: true
    }].to_json
  end

  def iphone(from, to)
    @retries = 0
    @iphone_data ||= fetch_data(app_metrics_url(@iphone_api_key, from, to))
  end

  def ipad(from, to)
    @retries = 0
    @ipad_data ||= fetch_data(app_metrics_url(@ipad_api_key, from, to))
  end

  def android(from, to)
    @retries = 0
    @android_data ||= fetch_data(app_metrics_url(@android_api_key, from, to))
  end

  def subtitle
    "#{@title} (#{@timestamp})"
  end

  def series_name
    "Users - #{@title}"
  end

  private

  def fetch_data(url)
    begin
      if @retries > @max_retries
        @logger.warn("max retries #{@max_retries} reached, returning 0")
        return 0
      end

      @logger.info("fetching data from: '#{url}'")
      json = JSON.parse(HTTParty.get(url).body)

      result = json['day'].inject(0) { |sum, item| sum += item["@value"].to_i }
      @logger.info("parsing json data, found #{result}")
      result
    rescue JSON::ParserError
      @retries += 1
      @logger.warn("ParserError: retrying flurry api after #{@retry_interval} seconds. Retry #{@retries}/#{@max_retries}")
      sleep(@retry_interval)
      retry
    end
  end



  def app_metrics_url(api_key, action="NewUsers", from, to)
    "http://api.flurry.com/appMetrics/#{action}?apiAccessCode=#{@api_access_code}&apiKey=#{api_key}&startDate=#{from}&endDate=#{to}"
  end


  def get_access_code
    access_code = File.read('api_access.txt')
    access_code
  end

end
