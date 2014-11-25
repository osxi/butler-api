class ReportController < ApplicationController
  def daily
    @team         = Team.find_by_name(params[:team])
    @time_entries = (@team.try(:time_entries) || TimeEntry.all)
                    .where(date: params_date_range)
                    .select(:user_id, :hours)
                    .group_by(&:user)
    @total_hours  = @time_entries.map { |_user, time_entries| time_entries.map(&:hours) }
                    .first.try(:inject, :+).try(:round, 2) || 0.0
  end

  def user
    fb_staff_id   = params[:fb_staff_id]
    @user         = User.find_by(fb_staff_id: fb_staff_id)
    @time_entries = TimeEntry.where(fb_staff_id: fb_staff_id,
                                    date: params_date_range)
    @total_hours  = @time_entries.pluck(:hours).inject(:+).try(:round, 2) || 0.0
  end

  private

  def params_date_range
    if params[:date].present?
      day   = Date.strptime(params[:date], '%m/%d/%Y')
      to    = day.beginning_of_day
      from  = day.end_of_day
      @date_range = to..from
    else
      @date_range = Time.now.beginning_of_day..Time.now.end_of_day
    end
  end
end
