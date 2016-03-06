Date::DATE_FORMATS[:friendly] = lambda { |date| date.strftime("%B #{date.day.ordinalize} %Y") }
Date::DATE_FORMATS[:short_friendly] = lambda { |date| date.strftime("%b #{date.day}") }
Date::DATE_FORMATS[:humanly] = lambda { |date| date.strftime("%B #{date.day}, %Y") }

Time::DATE_FORMATS[:humanly] = lambda { |time| time.strftime("%B #{time.day}, %Y") }