# Fakerをコンソールで試す場合はテスト環境で試す
# rails c -e test

# 管理者
User.create!(
  email: 'admin@gmail.com',
  password: 'password',
  admin: true,
  first_name: '太郎',
  last_name: '田中',
  available_time_start: '8:00',
  available_time_end: '17:00',
  available_days: 5,
  confirmed_at: Time.now
)

# 正社員・パートレベルの勤務時間、出勤日数
s_available_days = [4, 5]
15.times do |_|
  last_name = Faker::Name.last_name
  first_name = Faker::Name.first_name
  email = Faker::Internet.email

  User.create!(
    email: email,
    password: 'password',
    first_name: first_name,
    last_name: last_name,
    available_time_start: '8:00',
    available_time_end: '17:00',
    available_days: s_available_days.sample,
    confirmed_at: Time.now # deviseのメール認証を通過させるフィールド
  )
end

# 学生レベルの勤務時間
start_time_list = ['17:00', '18:00', '19:00']
end_time_list = ['21:00', '22:00', '23:00']
g_available_days = [2, 3, 4, 5]
15.times do |_|
  last_name = Faker::Name.last_name
  first_name = Faker::Name.first_name
  email = Faker::Internet.email

  User.create!(
    email: email,
    password: 'password',
    first_name: first_name,
    last_name: last_name,
    available_time_start: start_time_list.sample,
    available_time_end: end_time_list.sample,
    available_days: g_available_days.sample,
    confirmed_at: Time.now # deviseのメール認証を通過させるフィールド
  )
end