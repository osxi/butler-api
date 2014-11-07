namespace :trello do
  desc "date format [2014-10-12,2014-10-13]"
  task :update_card_actuals, [:from_day, :to_day] => [:environment] do |t, args|
    from = (args[:from_day] && args[:from_day].to_date) || nil
    to   = (args[:to_day]   && args[:to_day].to_date)   || nil

    card_ids = TimeEntry.where.not(trello_card_id: nil)
                        .where('date >= ? AND date <= ?', from, to)
                        .pluck(:trello_card_id).uniq

    trello_client = TrelloApi.new(ENV['TRELLO_KEY'], ENV['TRELLO_TOKEN'])
    card_updater  = Trello::CardActualsUpdater.new(trello_client)

    card_updater.update_cards(*card_ids)

    puts "Updated cards: #{card_ids}"
  end
end
