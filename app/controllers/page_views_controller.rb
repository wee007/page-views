# frozen_string_literal: true

# Page view controller.
#
class PageViewsController < ApplicationController
  include Searchable

  def index
    @client.cluster.health

    request = {
      urls: [
        'http://www.news.com.au/travel/travel-updates/incidents/disruptive-passenger-grounds-flight-after-storming-cockpit/news-story/5949c1e9542df41fb89e6cdcdc16b615',
        'http://www.smh.com.au/sport/tennis/an-open-letter-from-martina-navratilova-to-margaret-court-arena-20170601-gwhuyx.html'
      ],
      before: Date.parse('2017-06-04').strftime('%Q'), # Convert date to milliseconds
      after: Date.parse('2017-05-31').strftime('%Q'), # Convert date to milliseconds
      interval: '10m'
    }

    interval = request[:interval]

    response = []
    request[:urls].each do |url|
      response << search({ page_url: url }, interval)
    end

    render json: response
  rescue => error
    render json: { error: error }
  end

end
