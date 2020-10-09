# 勤務可能時間が正社員レベルの人とバイトレベルの人を分ける
# DB内部ではタイムゾーンがUTCのため、普通の時刻で検索すると出てこないので、Tokyo→UTCに変更する必要がある
regular_employee_time_in = convert_to_utc('08:00:00')
evening_time_in = convert_to_utc('17:00:00')
midnight_time_in = convert_to_utc('21:00:00')

regular_employees  = User.where(available_time_start: regular_employee_time_in)
evening_employees  = User.where(available_time_start: evening_time_in)
midnight_employees = User.where(available_time_start: midnight_time_in)

store = User.find_by(admin: true).store
emp_per_day_number = store.emp_per_day_number

shift_list = []

# 上のリストからランダムに5人ずつ取得してタイムテーブルを作成する
days_in_next_month.times do |day|
  # 一日の従業員をランダムに抽出する
  shift_list.append(regular_employees.sample(emp_per_day_number))
            .append(evening_employees.sample(emp_per_day_number))
            .append(midnight_employees.sample(emp_per_day_number))
            .flatten
  # DB登録用の日付文字列を作成（来月の年と月の文字列を作成）
  working_days = Date.today.next_month.strftime('%Y-%m') + "-#{day + 1}"

  shift_list.each do |emp|
    Shift.create!(working_days: working_days, user: emp)
  end
end

# 来月の日数を取得
def days_in_next_month
  today = Date.today
  next_date = today.next_month
  Time.days_in_month(next_date.month, next_date.year)
end

def convert_to_utc(str)
  # 文字列をTokyoの時刻オブジェクトにした後、UTCに変更する
  # 一度TokyoにしないとUTCの文字列時刻になってしまう
  str.in_time_zone('Tokyo').in_time_zone('UTC')
end