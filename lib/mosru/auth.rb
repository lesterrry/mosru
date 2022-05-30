# 
# COPYRIGHT LESTER COVEY,
#
# 2022

require 'net/http'
require 'uri'

module Mosru
	class Auth
		def self.perform
			# First redirect
			puts "https://www.mos.ru/api/acs/v1/login?back_url=https://www.mos.ru/"
			r = Ceremony.default_request("https://www.mos.ru/api/acs/v1/login?back_url=https://www.mos.ru/", 0)
			if r.code != '307' then raise UnexpectedResponseCodeError end
			c = CookieJar.new(r.get_fields('set-cookie'))
			# Further redirects
			i = 0
			loop do
				i += 1
				r['location'] = "https://login.mos.ru" + r['location'] if r['location'][0] == '/'
				puts r["location"]
				r = Ceremony.default_request(r["location"], 1, c)
				c.append(r.get_fields('set-cookie'))
				puts r.code
				#puts c.cookies
				break if r.code != '303' || i > 4
			end
		end
		class Ceremony
			def self.default_request(uri, headers_order=0, cookie_jar=nil)
				uri = URI.parse(uri)
				request = Net::HTTP::Get.new(uri)
				if headers_order == 1 then  # Preloading 
					request["Host"] = "login.mos.ru"
					request["Accept-Language"] = "ru"
					request["Accept-Encoding"] = "gzip, deflate, br"
					request["Connection"] = "keep-alive"
				elsif headers_order == 2 then  # Signing in (1)
					request["Origin"] = "https://login.mos.ru"
				end
				if headers_order == 2 || 3 then  # Signing in (2)
					request["Content-Type"] = "application/x-www-form-urlencoded"
				end
				unless cookie_jar.nil? then
					request["Cookie"] = cookie_jar.cookies
				end
				request["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
				request["User-Agent"] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.5 Safari/605.1.15"
				request["Referer"] = "https://www.mos.ru/"
				req_options = { use_ssl: uri.scheme == "https" }
				response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
					http.request(request)
				end
				return response
			end
		end
		class CookieJar
			attr_reader :cookies
			def initialize(c)
				@cookies = parse(c)
			end
			def append(c)
				@cookies += ";#{parse(c)}"
			end
			def parse(c)
				c_array = Array.new
				c.each do |i|
					c_array.push(i.split('; ')[0])
				end
				c_array.uniq!
				return c_array.join('; ')
			end
		end
	end
end