# 
# COPYRIGHT LESTER COVEY,
#
# 2022

require 'net/http'
require 'uri'

# I have no idea how to fetch these values so let's hope they will remain the same
OXXFGH_COOKIE = "oxxfgh=6e982c55-81a4-4885-9fab-fba7ee3317df#5#2592000000#5000#600000#81540"
OYYSTART_COOKIE = "oyystart=6e982c55-81a4-4885-9fab-fba7ee3317df_4"
BFP = "af5f017d3f2a1fc9494e2e74b444c3df"

module Mosru

	class Auth
		def self.perform(login, password, verbose=false)
			# First call
			r = Ceremony.default_request("https://www.mos.ru/api/acs/v1/login?back_url=https://www.mos.ru/")
			puts r.code if verbose
			if r.code != '307' then raise UnexpectedResponseCodeError end
			c = CookieJar.new(r.get_fields('set-cookie'))
			# Further redirects
			i = 0
			loop do
				i += 1
				r['location'] = "https://login.mos.ru" + r['location'] if r['location'][0] == '/'
				r = Ceremony.default_request(r["location"], true, c)
				puts r.code if verbose
				c.append(r.get_fields('set-cookie'))
				if i > 2 then raise RecurringRedirectsError end
				break if r.code != '303'
			end
			# Credentials introduction
			r = Ceremony.login_post_request(login, password, c)
			puts r.code if verbose
			c.append(r.get_fields('set-cookie'))
			File.open("cache.html",'w') { |file| file.write(r.body) }
			if r.code != '302' then raise UnexpectedResponseCodeError end
			# Additional redirects
			i = 0
			loop do
				i += 1
				r = Ceremony.default_request(r["location"], false, c)
				puts r.code if verbose
				c.append(r.get_fields('set-cookie'))
				if i > 3 then raise RecurringRedirectsError end
				break if r.code == '200'
			end
			puts "SUCCESS" if verbose
			return c
		end

		class Ceremony
			def self.default_request(uri, advanced_headers=false, cookie_jar=nil)
				uri = URI.parse(uri)
				request = Net::HTTP::Get.new(uri)
				if advanced_headers then  # Additional 
					request["Host"] = "login.mos.ru"
					request["Accept-Language"] = "ru"
					request["Accept-Encoding"] = "gzip, deflate, br"
					request["Connection"] = "keep-alive"
				end
				unless cookie_jar.nil? then
					request["Cookie"] = cookie_jar.plain
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
			def self.login_post_request(login, password, cookie_jar)
				uri = URI.parse("https://login.mos.ru/sps/login/methods/password?bo=/sps/oauth/ae?scope=profile+openid+contacts+usr_grps&response_type=code&redirect_uri=https://www.mos.ru/api/acs/v1/login/satisfy&client_id=mos.ru")
				request = Net::HTTP::Post.new(uri)
				request["Origin"] = "https://login.mos.ru"
				request["Content-Type"] = "application/x-www-form-urlencoded"
				request["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
				request["User-Agent"] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.5 Safari/605.1.15"
				request["Referer"] = "https://login.mos.ru/sps/login/methods/password?bo=/sps/oauth/ae?scope=profile+openid+contacts+usr_grps&response_type=code&redirect_uri=https://www.mos.ru/api/acs/v1/login/satisfy&client_id=mos.ru"
				request["Cookie"] = cookie_jar.plain + "; #{OXXFGH_COOKIE}; #{OYYSTART_COOKIE};"
				request.set_form_data(
					"isDelayed" => "false",
					"login" => login,
					"password" => password,
					"bfp" => BFP
				)
				req_options = { use_ssl: uri.scheme == "https" }
				response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
					http.request(request)
				end
				return response
			end
		end

		class CookieJar
			def initialize(c)
				@cookies = parse(c)
			end
			def plain
				return @cookies.map{ |k, v| "#{k}=#{v}" }.join('; ')
			end
			def raw
				return @cookies
			end
			def append(c)
				return if c.nil?
				@cookies.merge!(parse(c))
			end
			def clear
				@cookies = Hash.new
			end
			def parse(c)
				c_hash = Hash.new
				c.each do |i|
					element = i.split('; ')[0]
					values = element.split('=')
					c_hash[values[0]] = values[1]
				end
				return c_hash
			end
			def bury(f)
				File.open(f, 'wb') do |f|
					f.write(Marshal.dump(@cookies))
				end
			end
			def restore(f)
				file_data = File.read(f)
				@cookies = Marshal.load(file_data)
			end
		end
		
	end

end