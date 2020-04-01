module UsersReport
  class Report
    attr_reader :file_name, :users, :current_user, :report

    def initialize(file_name)
      @file_name = file_name
      @users = []
      @report = {}
    end

    def generate!
      CSV.foreach(file_name) { |row| parse_row(row) }

      prepare_report
    end

    def parse_row(row)
      if row[0] == 'user'
        @current_user = User.new(parse_user(row))
        @users.push(@current_user)
      end

      if row[0] == 'session'
        session = Session.new(parse_session(row))
        @current_user.add_session(session)
      end
    end

    def parse_user(row)
      {
        id: row[1],
        first_name: row[2],
        last_name: row[3],
        age: row[4]
      }
    end

    def parse_session(row)
      {
        user_id: row[1],
        session_id: row[2],
        browser: row[3],
        time: row[4],
        date: row[5]
      }
    end

    def all_browsers
      @all_browsers ||= users.flat_map(&:browsers).uniq.sort
    end

    def prepare_report
      @report['totalUsers'] = users.count
      @report['uniqueBrowsersCount'] = all_browsers.count
      @report['totalSessions'] = users.sum { |u| u.sessions.count }
      @report['allBrowsers'] = all_browsers.join(',')
      @report['usersStats'] = {}

      users.each do |user|
        @report['usersStats'][user.user_key] = user.as_json
      end
    end

    def to_json
      report.to_json
    end
  end
end