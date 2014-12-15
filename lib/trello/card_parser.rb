module Trello
  class CardParser < Struct.new(:name)
    SPLIT_HOURS_REGEX = /(.*\[)([\d\.]+)(\].*)\s?\z/
    ACTUAL_REGEX      = /\[([\d\.]+)\]\s?\z/
    ESTIMATE_REGEX    = /\A\(([\d\.]+)\)/

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

    def get_actual
      first_match_or(matches: name.match(ACTUAL_REGEX),
                     default: 0.0).to_f
    end

    def get_estimate
      first_match_or(matches: name.match(ESTIMATE_REGEX),
                     default: 0.0).to_f
    end

    def first_match_or(matches:, default:)
      if matches && matches.length
        matches[1]
      else
        default
      end
    end
  end
end
