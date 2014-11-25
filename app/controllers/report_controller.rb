class ReportController < ApplicationController
  def daily
    @team         = Team.find_by_name(params[:team]) || Team.all
    @time_entries = @team
                    .time_entries
                    .where(date: get_date)
                    .select(:user_id, :hours)
                    .group_by(&:user)
    @total_hours  = @time_entries.map(&:hours).inject(0, :+).round(2)
  end

  def user
    fb_staff_id   = params[:fb_staff_id]
    @user         = User.find_by(fb_staff_id: fb_staff_id)
    @time_entries = TimeEntry.where(fb_staff_id: fb_staff_id,
                                    date: get_date)
    @total_hours  = @time_entries.pluck(:hours).inject(0, :+).round(2)
  end

  private

  def get_date
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
