source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Уставнока глобальных переменных среды — должно быть вначале
gem 'dotenv-rails', require: 'dotenv/rails-now'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.4'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 4.3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 3.0' # для продакшена нужна конкретная версия ~> 3
gem 'redis-rails'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# ##########################

# Формирование ответа
gem 'active_model_serializers'
gem 'oj'
gem 'oj_mimic_json'
gem 'responders'

# Качество кода
gem 'rubocop', require: false

# Перевод
gem 'rails-i18n', '~> 5.0.0'

# Верстка
gem 'bootstrap', '~> 4.0.0.beta'
gem 'cocoon'
gem 'font-awesome-rails'
gem 'gon'
gem 'jquery-rails'
gem 'js-routes'
gem 'simple_form'
gem 'skim'
gem 'slim-rails'

# Изображения
gem 'carrierwave', '~> 1.0'
gem 'remotipart', '~> 1.3'

# Авторизация
gem 'devise'
gem 'devise-i18n'
gem 'doorkeeper'
gem 'doorkeeper-i18n'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'omniauth-vkontakte'
gem 'pundit'

# Фоновые задачи
gem 'sidekiq'
gem 'sidekiq-cron'
gem 'sinatra', '>= 1.3.0', require: nil
gem 'whenever'

# Полнотекстовый поиск
gem 'mysql2'
gem 'thinking-sphinx', '3.3.0'

# middleware
gem 'unicorn'

group :production do
  # Для компиляции ассетов
  gem 'therubyracer'
end

group :development do
  # Деплоймент
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-nvm', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'capistrano-yarn', require: false
  gem 'capistrano3-unicorn', require: false
end

# Разработка и Тестирование
group :development, :test do
  gem 'factory_bot_rails'
  gem 'letter_opener'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rails-controller-testing'
  gem 'rspec-rails', '~> 3.6'
end
group :test do
  gem 'capybara'
  gem 'capybara-email'
  gem 'database_cleaner'
  gem 'json_spec'
  gem 'launchy'
  gem 'poltergeist'
  gem 'shoulda-matchers', '~> 3.1'
end
