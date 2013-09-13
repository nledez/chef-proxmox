# A sample Gemfile
source "https://rubygems.org"

gem "foodcritic"
gem "chefspec"

group :developement do
	gem "guard"
	gem "guard-rspec"

	if RUBY_PLATFORM =~ /darwin/i
	  gem 'rb-fsevent', '~> 0.9.1'
	  gem 'growl'
	end
end
