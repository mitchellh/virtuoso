source "http://rubygems.org"

# Specify your gem's dependencies in virtuoso.gemspec
gem "virtuoso", :path => "."

# Use libvirt-rb straight from git, since Virtuoso dev requires
# the latest and greatest
gem "libvirt", :git => "git://github.com/mitchellh/libvirt-rb.git"

# Gems required for testing only.
group :development do
  gem "protest", "~> 0.4.0"
  gem "mocha", "~> 0.9.8"

  # Not JRuby, which doesn't like bluecloth
  platforms :ruby, :mri do
    gem "yard", "~> 0.6.1"
    gem "bluecloth", "~> 2.0.9"
  end
end
