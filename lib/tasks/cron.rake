# 実行コマンド
# bundle exec rake cron:shift

namespace :cron do
  desc 'シフト作成処理'
  task :shift => :environment do
    regular_time_in = convert_to_utc('08:00:00')
    evening_time_in = convert_to_utc('17:00:00')
    midnight_time_in = convert_to_utc('21:00:00')

    regular_employees  = User.where(available_time_start: regular_time_in)
    evening_employees  = User.where(available_time_start: evening_time_in)
    midnight_employees = User.where(available_time_start: midnight_time_in)

    store = User.find_by(admin: true).store
    $weekly_worked_counter_list = [0] * (User.count + 1)

    days_in_next_month.times do |day|
      day += 1
      # 一日の従業員を抽出する
      random_regular_emp_list  = extract_employees(day, regular_employees)
      random_evening_emp_list  = extract_employees(day, evening_employees)
      random_midnight_emp_list = extract_employees(day, midnight_employees)

      # DB登録用の日付文字列を作成（来月の年と月の文字列を作成）
      working_days = Date.today.next_month.strftime('%Y-%m') + "-#{day}"

      random_emp_list = random_regular_emp_list + random_evening_emp_list + random_midnight_emp_list

      random_emp_list.each do |emp|
        emp.shifts.create!(working_days: working_days)
      end

      # 一週間経ったらリストをリセットする
      if (day % 7).zero?
        regular_employees  = User.where(available_time_start: regular_time_in)
        evening_employees  = User.where(available_time_start: evening_time_in)
        midnight_employees = User.where(available_time_start: midnight_time_in)
        $weekly_worked_counter_list = [0] * (User.count + 1)
      else
        regular_employees  = work_days_management(regular_employees, random_regular_emp_list)
        evening_employees  = work_days_management(evening_employees, random_evening_emp_list)
        midnight_employees = work_days_management(midnight_employees, random_midnight_emp_list)
      end
    end
  end

  # 出勤分布確認コード
  # @temp_list = Array.new(4) { Array.new(User.count + 1, 0) }

  # @temp_list.each_with_index do |week_list, i|
  #   i *= 7

  #   7.times do |j|
  #     day = i + j

  #     @x[day].each do |emp|
  #       week_list[emp.id] += 1
  #     end
  #   end
  # end

  # その日に働く従業員を抽出する処理
  def extract_employees(day, employees_list)
    store = User.find_by(admin: true).store
    emp_per_day_number = store.emp_per_day_number
    work_date = Date.today.next_month.strftime('%Y-%m') + "-#{day}"

    # day日の出勤希望日がある人を抽出
    hope_work_list = employees_list.select do |emp|
      emp.requests.where(possible: true, date: work_date).present?
    end

    go_to_work_list = hope_work_list.sample(emp_per_day_number)

    # 希望者が必要な人数より少なかった場合、ランダムで追加する
    if go_to_work_list.length < emp_per_day_number
      # day日の出勤希望がfalseの人を排除し、出勤可能な人のみを集める
      possible_list = employees_list.reject do |emp|
        emp.requests.where(possible: false, date: work_date).present?
      end

      diff_num = emp_per_day_number - go_to_work_list.length
      go_to_work_list.append(possible_list.sample(diff_num)).flatten!
    end

    go_to_work_list
  end

  # 出勤カウントを増やし、出勤した従業員が一週間で出勤できる日数を
  # 超えていた場合に従業員リストから除外する処理
  def work_days_management(employees_list, random_emp_list)
    delete_list = []
    # 抽出した従業員の出勤日数を1増やす
    random_emp_list.each do |emp|
      emp_id = emp.id
      $weekly_worked_counter_list[emp_id] += 1

      # 1増やした後の出勤日数が出勤可能日数と同じになった場合、
      # 削除すべき添字をdelete_listに記録する
      delete_list.append(emp_id) if $weekly_worked_counter_list[emp_id] == emp.available_days
    end
    # 従業員リストから除外する
    employees_list.reject { |emp| delete_list.include?(emp.id) }
  end

  # 来月の日数を取得
  def days_in_next_month
    next_date = Date.today.next_month
    Time.days_in_month(next_date.month, next_date.year)
  end

  def convert_to_utc(str)
    # 文字列をTokyoの時刻オブジェクトにした後、UTCに変更する
    # 一度TokyoにしないとUTC時刻になってしまうので注意
    str.in_time_zone('Tokyo').in_time_zone('UTC')
  end
end
