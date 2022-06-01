# 
# COPYRIGHT LESTER COVEY,
#
# 2022

require_relative "lib/mosru/version"

Gem::Specification.new do |spec|
	spec.name = "mosru"
	spec.version = Mosru::VERSION
	spec.authors = ["Lester Covey"]
	spec.email = ["me@lestercovey.ml"]

	spec.summary = "OAuth wrapper for mos.ru"
	spec.description = "Provides methods for authentificating on mos.ru website using password "
	spec.homepage = "https://github.com/lesterrry/mosru"
	spec.required_ruby_version = ">= 2.6.0"

	spec.metadata["allowed_push_host"] = "https://rubygems.org"

	spec.metadata["homepage_uri"] = spec.homepage
	spec.metadata["source_code_uri"] = "https://github.com/lesterrry/mosru"

	# The `git ls-files -z` loads the files in the RubyGem that have been added into git.
	spec.files = Dir.chdir(File.expand_path(__dir__)) do
		`git ls-files -z`.split("\x0").reject do |f|
			(f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
		end
	end
	
	spec.require_paths = ["lib"]

	spec.add_runtime_dependency "json", ["= 2.6.2"]

	# For more information and examples about making a new gem, check out our
	# guide at: https://bundler.io/guides/creating_gem.html
end
