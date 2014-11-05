module Trello
  class CardParser < Struct.new(:name)
    SPLIT_HOURS_REGEX = /\(([\w]{8})\)/
    SPLIT_HOURS_REGEX = /(.*\[)([\d\.]+)(\].*)\s?\z/

    def update_hours_in_name(total_hours)
      split_name = name.to_s.split(SPLIT_HOURS_REGEX)

      if split_name && split_name.length == 4
        split_name.shift
        split_name[1] = total_hours.round(2)
        split_name.join
      else
        "#{name} [#{total_hours.round(2)}]"
      end
    end
  end
end
