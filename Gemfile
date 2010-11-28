source "http://rubygems.org"

# Specify your gem's dependencies in virtuoso.gemspec
gem "virtuoso", :path => "."

# Use libvirt-rb straight from git, since Virtuoso dev requires
# the latest and greatest
gem "libvirt", :git => "git://github.com/mitchellh/libvirt-rb.git"

# Gems required for testing only.
group :test do
  gem "protest", "~> 0.4.0"
  gem "mocha", "~> 0.9.8"
end
