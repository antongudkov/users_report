module Helpers
  def load_fixture(name)
    CSV.read("spec/fixtures/#{name}.txt").shift
  end

  def load_session
    row = load_fixture('session')

    {
      user_id: row[1],
      session_id: row[2],
      browser: row[3],
      time: row[4],
      date: row[5]
    }
  end

  def load_user
    row = load_fixture('user')

    {
      id: row[1],
      first_name: row[2],
      last_name: row[3],
      age: row[4]
    }
  end

  def load_result
    result = File.read('spec/fixtures/result.json')
    JSON.parse(result)
  end
end