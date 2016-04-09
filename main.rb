require "cuba"
require "cuba/safe"
require 'oga'
require 'net/http'
require 'json'
require 'pry'
require './scrape'

# Cuba.use Rack::Session::Cookie, :secret => "__a_very_long_string__"
# Cuba.plugin Cuba::Safe

Cuba.define do
  on get do
    on "search" do
      on param("timberMark"), param("from"), param("to") do |timberMark, from, to|
        scrape = Scrape.new(timberMark, from, to)
        res.write scrape.to_json
      end
    end

    on root do
      res.redirect "/search"
    end
  end
end
