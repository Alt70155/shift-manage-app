days_in_next_month = days_in_next_month()

# 勤務可能時間が正社員レベルの人とバイトレベルの人を分ける
# DB内部ではタイムゾーンがUTCのため、普通の時刻で検索すると出てこないので、Tokyo→UTCに変更する必要がある
regular_employee_time_in = convert_to_utc('08:00:00')
evening_time_in = convert_to_utc('17:00:00')
midnight_time_in = convert_to_utc('21:00:00')

regular_employee  = User.where(available_time_start: regular_employee_time_in)
evening_employee  = User.where(available_time_start: evening_time_in)
midnight_employee = User.where(available_time_start: midnight_time_in)

# 上のリストからランダムに5人ずつ取得してタイムテーブルを作成する

# 来月の日数を取得
def days_in_next_month
  now = Time.current
  next_date = now.next_month
  Time.days_in_month(next_date.month, next_date.year)
end

def convert_to_utc(str)
  str.in_time_zone('Tokyo').in_time_zone('UTC')
end