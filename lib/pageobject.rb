#!/usr/bin/env ruby
# vim: tabstop=2 expandtab shiftwidth=2

require 'rubygems'
require 'capybara'
require 'capybara/dsl'

module Jenkins
  class PageObject
    include Capybara::DSL
    extend Capybara::DSL

    attr_accessor :name

    def initialize(base_url, name)
      @base_url = base_url
      @name = name
    end

    def self.random_name
      suffix = (rand() * 10_000_000).to_s[0 .. 20]
      return "rand_name_#{suffix}"
    end

    def ensure_config_page
      current_url.should == configure_url
    end

    def configure_url
      # Should be overridden by subclasses if they want to use the configure
      # block
      nil
    end

    def configure(&block)
      visit(configure_url)
      wait_until do # script has to fully load
        begin
          !find('DIV.behavior-loading').visible?
        rescue Capybara::ElementNotFound
          true # if there's no behavior-loading, that's fine, too
        end
       end

      unless block.nil?
        yield
        save
      end
    end

    def encode(text) # http://stackoverflow.com/a/8873922/12916
      if String.method_defined?(:encode)
        text.encode('UTF-8', 'UTF-8', :invalid => :replace)
      else
        require 'iconv'
        Iconv.new('UTF-8', 'UTF-8//IGNORE').iconv(text)
      end
    end

    def save
      click_button "Save"
      if encode(page.html) =~ /This page expects a form submission/

        raise "Job was not saved.\n" + page.html
      end
    end

    def json_api_url
      # Should be overridden by subclasses
      nil
    end

    def json
      url = json_api_url
      unless url.nil?
        uri = URI.parse(url)
        return JSON.parse(Net::HTTP.get_response(uri).body)
      end
      return nil
    end

    def wait_for(selector, opts={})
      timeout = opts[:timeout] || 30
      selector_kind = opts[:with] || :xpath
      start = Time.now.to_i
      begin
        find(selector_kind, selector)
      rescue Capybara::TimeoutError, Capybara::ElementNotFound => e
        retry unless (Time.now.to_i - start) >= timeout
        raise
      end
    end

    # Get the version of Jenkins under test
    def jenkins_version
      prefix = 'About Jenkins '
      visit @base_url + 'about'

      text = wait_for("//h1[starts-with(., '#{prefix}')]").text

      # Ignore the part after dash. Not supported by Gem::Version
      return Gem::Version.new(
          text.match("^#{prefix}([^-]*)")[1]
      )
    end
  end
end
