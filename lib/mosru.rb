# 
# COPYRIGHT LESTER COVEY,
#
# 2022

require_relative "mosru/version"
require_relative "mosru/auth"

module Mosru
	class UnexpectedResponseCodeError < StandardError
		def initialize(msg="Got unexpected response code. Check your credentials. The ceremony might have changed", exception_type="custom")
			@exception_type = exception_type
			super(msg)
		end
	end
	class RecurringRedirectsError < StandardError
		def initialize(msg="Too much redirects occurred. The ceremony might have changed", exception_type="custom")
			@exception_type = exception_type
			super(msg)
		end
	end
end
