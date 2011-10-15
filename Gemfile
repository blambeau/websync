source 'http://rubygems.org'

group :test do
  gem "rake", "~> 0.9.2"
  gem "rspec", "~> 2.6.0"
end

group :release do
  gem "rake", "~> 0.9.2"
  gem "rspec", "~> 2.6.0"
  gem "wlang", "~> 0.10.2"
end

group :runtime do
  #gem "grit", :git => "https://blambeau@github.com/blambeau/grit.git"
  gem "grit", :path => File.expand_path("../../grit", __FILE__)
end
