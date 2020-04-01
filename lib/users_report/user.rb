module UsersReport
  class User
    attr_reader :id, :first_name, :last_name, :age, :sessions

    def initialize(id:, first_name:, last_name:, age:)
      @id = id.to_i
      @first_name = first_name
      @last_name = last_name
      @age = age.to_i
      @sessions = []
    end

    def add_session(session)
      @sessions.push(session)
    end

    def user_key
      [first_name, last_name].join(' ')
    end

    def browsers
      @browsers ||= sessions.map(&:browser)
    end

    def sessions_times
      @sessions_times ||= sessions.map(&:time)
    end

    def used_ie?
      browsers.any? { |b| b =~ /INTERNET EXPLORER/ }
    end

    def always_used_chrome?
      browsers.all? { |b| b =~ /CHROME/ }
    end

    def as_json
      {
        'sessionsCount' => sessions.count,
        'totalTime' => sessions_times.sum.to_s + ' min.',
        'longestSession' => sessions_times.max.to_s + ' min.',
        'browsers' => browsers.sort.join(', '),
        'usedIE' => used_ie?,
        'alwaysUsedChrome' => always_used_chrome?,
        'dates' => sessions.map(&:date).sort.reverse
      }
    end
  end
end