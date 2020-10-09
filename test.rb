# 勤務可能時間が正社員レベルの人とバイトレベルの人を分ける
# DB内部ではタイムゾーンがUTCのため、普通の時刻で検索すると出てこないので、Tokyo→UTCに変更する必要がある
regular_employee_time_in = convert_to_utc('08:00:00')
evening_time_in = convert_to_utc('17:00:00')
midnight_time_in = convert_to_utc('21:00:00')

regular_employees  = User.where(available_time_start: regular_employee_time_in).to_a
evening_employees  = User.where(available_time_start: evening_time_in).to_a
midnight_employees = User.where(available_time_start: midnight_time_in).to_a

store = User.find_by(admin: true).store
emp_per_day_number = store.emp_per_day_number

shift_list = []
worked_counter_list = [0] * (User.count + 1)

# 上のリストからランダムに5人ずつ取得してタイムテーブルを作成する
###
# TODO:定休日を抜かす
##
days_in_next_month.times do |day|
  # 一日の従業員をランダムに抽出する
  random_emp_list = []
  random_emp_list.append(regular_employees.sample(emp_per_day_number))
                 .append(evening_employees.sample(emp_per_day_number))
                 .append(midnight_employees.sample(emp_per_day_number))
                 .flatten
  shift_list.append(random_emp_list)

  # DB登録用の日付文字列を作成（来月の年と月の文字列を作成）
  working_days = Date.today.next_month.strftime('%Y-%m') + "-#{day + 1}"

  shift_list.each do |emp|
    Shift.create!(working_days: working_days, user: emp)
  end

  regular_employees  = work_days_management(regular_employees)
  evening_employees  = work_days_management(evening_employees)
  midnight_employees = work_days_management(midnight_employees)

  # 一週間経ったらカウントリストをリセットする
end

def work_days_management(employees_list)
  index_list = []
  # 抽出した従業員の出勤日数を1増やす
  employees_list.each_with_index do |emp, i|
    worked_counter_list[emp.id] += 1

    # 1増やした後の出勤日数が出勤可能日数と同じになった場合、
    # 削除すべき添字をindex_listに記録する
    index_list.append(i) if worked_counter_list[emp.id] == emp.available_days
  end
  # 従業員リストから削除する
  index_list.each do |i|
    employees_list.delete_at(i)
  end

  employees_list
end

# 来月の日数を取得
def days_in_next_month
  today = Date.today
  next_date = today.next_month
  Time.days_in_month(next_date.month, next_date.year)
end

def convert_to_utc(str)
  # 文字列をTokyoの時刻オブジェクトにした後、UTCに変更する
  # 一度TokyoにしないとUTC時刻になってしまうので注意
  str.in_time_zone('Tokyo').in_time_zone('UTC')
end