require 'rubygems'
require 'sinatra'
require 'net/http'
require 'json'
require 'pry'
require 'csv'

require 'zip/zip'
require 'simple_xlsx'



#general api codes
set :api_access_code, 'GNJQNKF6VJ8VGGBD6975'
set :sleep_seconds, 1


#app specific api codes
@@api_keys = {
	"iPhone"	=> "9WWF6XTBZSWF9B5TWSMJ", 
	"iPad" 		=> "XMD9Q5R85G79N2NKQW4J", 
	"Android"	=> "53W7XYDDFB6TNSJYSWFT"
}

#urls
@@api_urls = {
	"appMetrics"	=> "http://api.flurry.com/appMetrics/%urlType%?apiAccessCode=#{settings.api_access_code}&apiKey=%apiKey%&startDate=%startDate%&endDate=%endDate%",
	"Summary" 		=> "http://api.flurry.com/eventMetrics/Summary?apiAccessCode=#{settings.api_access_code}&apiKey=%apiKey%&startDate=%startDate%&endDate=%endDate%",
	"Event" 		=> "http://api.flurry.com/eventMetrics/Event?apiAccessCode=#{settings.api_access_code}&apiKey=%apiKey%&startDate=%startDate%&endDate=%endDate%&eventName=%eventName%"
}

#path for dwonloaded csv's
@@path_downloads = "tmp/downloads/"


#binding.pry


helpers do
	#perform the URI call
	def doAPICall(apiCallURL)
		response = Net::HTTP.get_response(URI(URI::encode(apiCallURL)))
		out = JSON.parse(response.body)
		sleep(settings.sleep_seconds)	
		return out	
	end	

	#app specific data
	def doAPICallAppMetrics(url_type, device)
	
		uri = @@api_urls["appMetrics"]
		apiCallURL = uri.gsub(/%startDate%/, @@analytics_from).gsub(/%endDate%/, @@analytics_to).gsub(/%apiKey%/, @@api_keys[device]).gsub(/%urlType%/, url_type)
		out = doAPICall(apiCallURL)
		dnloads_device = 0
		@csv_lines = ""
		out["day"].each do |d|
			@csv_lines += d['@date']+";"+d['@value']+","
			dnloads_device += d['@value'].to_i
		end

		#binding.pry
		@csv_array = @csv_lines.split(",")
		CSV.open(@@path_downloads+"#{url_type}_#{device}.csv", "w") do |csv|
			@csv_array.each do |line|	
		    	csv << [line]
			end
		end	

		return dnloads_device
	end

	#event specific data
	def doAPICallEventMetrics(device)

		#get names of events
		uri = @@api_urls['Summary']
		apiCallURL = uri.gsub(/%startDate%/, @@analytics_from).gsub(/%endDate%/, @@analytics_to).gsub(/%apiKey%/, @@api_keys[device])
		out = doAPICall(apiCallURL)

		@event_names = Array.new
		out["event"].each do |d|

			@event_names << d['@eventName']
		end

		#run per name of a event
		# @event_names = "received_message,saved_note,removed_from_favorites,...."
		@eventLogsArray = Hash.new(0)
		@event_names.each do |event_name|
			@eventLogsArray[event_name] = Array.new
			uri = @@api_urls['Event']
			apiCallURL = uri.gsub(/%startDate%/, @@analytics_from).gsub(/%endDate%/, @@analytics_to).gsub(/%apiKey%/, @@api_keys[device]).gsub(/%eventName%/,event_name)

			out = doAPICall(apiCallURL)	
				

			if !out["parameters"].nil?
				out["parameters"]["key"].each do |parameter|					
					if parameter["@name"] == "target"
						parameter["value"].each do |item|
							if item.class != Array 
								@eventLogsArray[event_name] << item["@name"]+";"+item["@totalCount"]
							end
						end


					end				
				end				
			end
		end

		return @eventLogsArray
	end
	def compress(path)

		require 'zip'
		
		path.sub!(%r[/$],'')
		archive = File.join(path,File.basename(path))+'.zip'
		FileUtils.rm archive, :force=>true

		Zip::File.open(archive, 'w') do |zipfile|
			Dir["#{path}/**/**"].reject{|f|f==archive}.each do |file|
			  zipfile.add(file.sub(path+'/',''),file)
			end
		end
		send_file archive, :type=>"application/zip" 
	end

end

configure do
	@dnloads_iPhone 	= 0
	@dnloads_iPad 		= 0
	@dnloads_Android 	= 0
	@sessions_iPhone 	= 0
	@sessions_iPad 		= 0
	@sessions_Android 	= 0

	@@analytics_from 	= ""
	@@analytics_to 		= ""
end


#first responder
get '/' do
	erb :index
end

#responder of the sumbit button
post '/form' do
	@@analytics_from 	= params['analytics_from']
	@@analytics_to 		= params['analytics_to']

	@dnloads_iPhone 	= doAPICallAppMetrics("NewUsers", "iPhone")
	@dnloads_iPad 		= doAPICallAppMetrics("NewUsers", "iPad")
	@dnloads_Android 	= doAPICallAppMetrics("NewUsers", "Android")


	@sessions_iPhone 	= doAPICallAppMetrics("Sessions", "iPhone")
	@sessions_iPad 		= doAPICallAppMetrics("Sessions", "iPad")
	@sessions_Android 	= doAPICallAppMetrics("Sessions", "Android")	 

	erb :index

end


#responder of the downlaod link
get '/form/download' do 
	#begin - download AppMetrics
	@@analytics_from	= params['analytics_from']
	@@analytics_to 		= params['analytics_to']

	doAPICallAppMetrics("ActiveUsers", "iPhone")
	doAPICallAppMetrics("ActiveUsers", "iPad")
	doAPICallAppMetrics("ActiveUsers", "Android")	 	
	#end - download AppMetrics

	#begin - EventMetrics
	`rm #{@@path_downloads}/test.xlsx`
	SimpleXlsx::Serializer.new(@@path_downloads+"eventLogs.xlsx") do |doc|
		eventLogsArray_iPhone	= doAPICallEventMetrics("iPhone")
		eventLogsArray_iPad 	= doAPICallEventMetrics("iPad")
		eventLogsArray_Android 	= doAPICallEventMetrics("Android")

		eventLogsArray = eventLogsArray_iPhone.merge(eventLogsArray_iPad).merge(eventLogsArray_Android)
		#eventLogsArray = eventLogsArray_Android

		eventLogsArray.each do  |key, values|
			if values.count > 0
				doc.add_sheet(key) do |sheet|
				  values.each do |value|
				  	temp_a = value.split(';')
					sheet.add_row([temp_a[0],temp_a[1]])
				  end
				end
			end			
		end
	end	

	compress('downloads')

	erb :index
end


get '/test/:name' do
	@@analytics_from = "2014-10-10"
	@@analytics_to = "2014-10-11"
	#binding.pry
	body ""
end
