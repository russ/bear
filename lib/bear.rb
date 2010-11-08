$:.unshift(File.dirname(__FILE__) + '/../lib') unless $:.include?(File.dirname(__FILE__) + '/../lib')
require 'bear/version'
require 'bear/cli'

module Bear
end
