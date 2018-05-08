# frozen_string_literal: true

# Allows the app to query the Elasticsearch cluster.
#
module Searchable
  extend ActiveSupport::Concern

  included do
    before_action :initialize
  end

  private

    def initialize
      @client = Elasticsearch::Client.new \
        hosts: [{
          host: ENV['elasticsearch_host'],
          port: ENV['elasticsearch_port'],
          user: ENV['elasticsearch_user'],
          password: ENV['elasticsearch_password'],
          scheme: ENV['scheme']
        }],
        log: true,
        reload_connections: true,
        retry_on_failure: 3
    end

    def search keyword, interval
      @client.search \
        index: 'events',
        body: {
          query: {
            match: keyword
          },
          aggregations: {
            count_over_time: {
              date_histogram: {
                field: 'derived_tstamp',
                format: 'hh:mm',
                interval: interval
              }
            },
            url: {
              terms: {
                field: 'page_url'
              }
            }
          }
        }
    end
end
