require 'erb'
require 'tempfile'
require 'logger'
require './meg_flurry_analytics'

def render_template
  template = IO.read("analytics.html.erb")
  html = ERB.new(template).result(binding)
  html_file = Tempfile.new(["analytics", ".html"])
  IO.write(html_file, html)
  html_file.path
end

def run
  options = {
    "flurry_iphone_api_key"  => "XSMCZBGXSJ65MRX5FB3R",
    "flurry_ipad_api_key"    => "RPWD3RSWYXH53G85JH63",
    "flurry_android_api_key" => "VKS3TYTXTWYHBPFW5P6Z",
    "title"                  => "Mexcon 2013",
    "logger" => Logger.new(STDOUT)
  }

  @analytics = MegFlurryAnalytics.new(options)
  file = render_template
  puts "File saved as: '#{file}'"
end

run
