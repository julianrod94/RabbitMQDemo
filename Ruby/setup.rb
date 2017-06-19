require 'rubygems'
require 'rubygems/gem_runner'
require 'rubygems/exceptions'

def install(lib)
  begin
    Gem::GemRunner.new.run ['install', lib]
  rescue Gem::SystemExitException => e
  end
end

puts "Installing required dependencies"

install 'bunny'

puts "Checking dependencies"
require 'bunny'