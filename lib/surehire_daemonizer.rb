require 'net/http'
require 'json'

module SurehireDaemonizer

  LIST_OF_CALLS = {
    :alcohol => "http://surewire.surehire.ca/alcohol-listing/",
    :vision => "http://surewire.surehire.ca/vision-listing/",
    :spirometry => "http://surewire.surehire.ca/spirometry-listing/",
    :private_consent => "http://surewire.surehire.ca/private-consent-listing/",
    :drug => "http://surewire.surehire.ca/drug-listing/",
    :audiometric => "http://surewire.surehire.ca/audio-listing/",
    :quantitative => "http://surewire.surehire.ca/quantitative-maskfit-listing/",
    :qualitative => "http://surewire.surehire.ca/qualitative-maskfit-listing/"
  }

  class << self

    def poll_for_cutoff
      url = "#{$configured[:host]}/notifications/cutoff/"
      begin
        response = Net::HTTP.get_response(URI.parse(url))
        puts "Response: #{response.code}"
        raise unless response.code == "200"
      rescue Exception => e
        raise e
      else
        true
      end
    end

    def track_jobs
      url = "#{$configured[:host]}/notifications/track/"
      begin
        response = Net::HTTP.get_response(URI.parse(url))
        puts "Response: #{response.code}"
        raise unless response.code == "200"
      rescue Exception => e
        raise e
      else
        true
      end
    end

    def sync
      url = "http://surewireu.surehire.ca/sync-databases/"
      begin
        response = Net::HTTP.get_response(URI.parse(url))
        puts "Response: #{response.code}"
        raise unless response.code == "200"
      rescue Exception => e
        raise
      else
        return JSON.parse(response.body)
      end
    end
    # Make a Net::HTTP call
    # => Return parsed JSON
    def make_a_call(url)
      begin
        response = Net::HTTP.get_response(URI.parse(url))
        return false unless response.code == "200"
      rescue Exception => e
        return false
      else
        return JSON.parse(response.body)
      end
    end

    # Get Updates from all remote calls #
    # => Return {:alcohol => {...}, :drug => {...}, ...}
    def get_updates
      result = Hash.new
      LIST_OF_CALLS.each do |identifier,url|
        result["#{identifier}"] = make_a_call(url)
      end
      result
    end

    # Create/Update the local Database unless false is returned as a response #
    def update_from_wire
      url = "#{$configured[:host]}/notifications/wire_updates/"
      begin
        response = Net::HTTP.get_response(URI.parse(url))
        puts "Response: #{response.code}"
        raise unless response.code == "200"
      rescue Exception => e
        raise e
      else
        true
      end
    end
  end

end
