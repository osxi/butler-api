class ReportController < ApplicationController
  def daily
    @team         = Team.includes(:users).find_by(name: params[:team])
    @total_hours  = total_daily_hours
    @time_entries = daily_time_entries.group_by(&:user)
  end

  def user
    fb_staff_id   = params[:fb_staff_id]
    @user         = User.find_by(fb_staff_id: fb_staff_id)
    @time_entries = TimeEntry.where(fb_staff_id: fb_staff_id,
                                    date: params_date_range)
    @total_hours  = sum_hours @time_entries
  end

  private

  def total_daily_hours
    sum_hours daily_time_entries
  end

  def daily_time_entries
    @daily_entries ||= if @team
                         @team.time_entries
                       else
                         TimeEntry.includes(:user).all
                       end.where(date: params_date_range).select(:user_id,
                                                                 :hours)
  end

  def sum_hours(time_entries)
    time_entries.pluck(:hours).sum.round(2)
  end

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
