require 'tinny/version'
require 'tinny/configuration'
require 'tinny/logger_helpers'
require 'logger'

module Tinny

  class << self
    attr_accessor :configuration, :logger
  end


  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.logger
    @logger ||= Logger.new($stdout).tap do |log|
      log.progname = self.name
    end
  end

end
