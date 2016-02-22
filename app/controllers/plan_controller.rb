require 'google-maps'

class PlanController < ApplicationController
  API_KEY = 'AIzaSyCLhamSZNhPdNcjDJifzHVReu3wRSBtQ5g'
  TIME_ZONE = 'Pacific Time (US & Canada)'

  def index
  end

  def travel_times
    @travel_times ||= departure_times.map do |time|
      find_distance(time)
    end
  end
  helper_method :travel_times

  def departure_times
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9].map do |future_hour|
      (leave_date + future_hour.hours)
    end
  end
  helper_method :departure_times

  def find_distance(time)
    if params[:location]
      Google::Maps.route(params[:location][:start], params[:location][:end], departure_time: time.strftime('%s'), key: API_KEY).duration_in_traffic.text
    end
  end

  def leave_date
    if params[:location][:departure].present?
      leave_time = DateTime.parse("#{params[:location][:departure]} #{ActiveSupport::TimeZone.new('America/Los_Angeles')}")
      if leave_time.future?
        return leave_time
      else
        flash[:notice] = "Departure time must be in the future"
      end
    end

    DateTime.now.in_time_zone(TIME_ZONE)
  end
end
