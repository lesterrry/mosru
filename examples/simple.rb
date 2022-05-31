# 
# COPYRIGHT LESTER COVEY,
#
# 2022

# TODO: replace with gem require
require_relative 'mosru/auth'

cookies = Mosru::Auth::perform("my_login", "my_password")  # Authorize in Mos.ru and return auth cookies
cookies.bury("cookies.bin")  # Save them for later
me = Mosru::Api::get_my_profile(cookies)  # Make call to Mos.ru api to retrieve basic profile data

puts "My name is #{me['first_name']}!"