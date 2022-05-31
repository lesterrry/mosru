# 
# COPYRIGHT LESTER COVEY,
#
# 2022

require 'net/http'
require 'uri'
require 'json'

module Mosru

	class Api
		def self.get_my_profile(cookie_jar)
			r = default_request("https://www.mos.ru/api/acs/v2/profile", cookie_jar)
			if r.code != '200' then raise UnexpectedResponseCodeError end
			parsed = JSON.parse(r.body)
			return parsed["data"]
		end
		def self.default_request(uri, cookie_jar=nil)
			uri = URI.parse(uri)
			request = Net::HTTP::Get.new(uri)
			request["Accept"] = "*/*"
			request["Host"] = "www.mos.ru"
			request["User-Agent"] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.5 Safari/605.1.15"
			request["Referer"] = "https://www.mos.ru/"
			request["Accept-Language"] = "ru"
			request["Connection"] = "keep-alive"
			request["X-Caller-Id"] = "acs::lib"
			unless cookie_jar.nil? then
				request["Cookie"] = cookie_jar.plain
			end
			req_options = { use_ssl: uri.scheme == "https" }

			response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
				http.request(request)
			end
			return response
		end
	end

end