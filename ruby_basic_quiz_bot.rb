require 'telegram/bot'

# Отримуємо токен бота з аргументів командного рядка або з оточення
token = '6008529928:AAHo4DiN2bSeazpy2PS6E8p30XVZQTfukFI'
raise 'Токен бота не знайдено. Запустіть програму з аргументом командного рядка або встановіть змінну оточення TELEGRAM_BOT_TOKEN.' if token.nil?

questions = [
  {
    question: 'Які основні типи даних підтримуються в мові Ruby?',
    answers: ['Всі вище згадані', 'Масиви, хеші, символи', 'Числа, рядки, булеві значення', 'Об\'єкти, класи, модулі'],
    correct_answer: 0
  },
  {
    question: 'Яким методом можна зчитати введені користувачем дані з консолі в мові Ruby?',
    answers: ['gets()', 'input()', 'read()', 'console_input()'],
    correct_answer: 0
  },
  {
    question: 'Оберіть правильну відповідь. Основними властивостями мови Ruby є…',
    answers: ['Об\'єктно-орієнтованість, динамічна типізація, автоматичне управління пам\'яттю',
       'Статична типізація, функціональність, компіляція в байт-код',
        'Паралельне виконання, низькорівневі операції, гнучкість синтаксису',
         'Анонімні функції, строга типізація, вбудована підтримка SQL'],
    correct_answer: 0
  },
  {
    question: 'Оберіть неправильну відповідь. Основною ідею мови Ruby є…',
    answers: ['Простота та елегантність',
       'Розширюваність та модульність',
        'Швидкодія та низькорівневість',
         'Зручність та задоволення від програмування'],
    correct_answer: 2
  },
  {
    question: 'Оберіть правильну відповідь. Базовий синтаксис мови Ruby не включає…',
    answers: ['Умовний оператор if',
       'Цикл for',
        'Об\'єктно-орієнтовані класи',
         'Оператор присвоєння ='],
    correct_answer: 1
  },
  {
    question: 'Зарезервованим словом мови Ruby не є…',
    answers: ['class', 'def', 'var', 'module'],
    correct_answer: 2
  },
  {
    question: 'Коментарі в мові Ruby позначають символом…',
    answers: ['//', '##', '/*', '\''],
    correct_answer: 1
  },
  {
    question: 'У мові Ruby не можна створити змінну з назвою…',
    answers: ['my_variable', '_variable', '123variable', '$variable'],
    correct_answer: 2
  },
  {
    question: 'У мові Ruby не еквівалентним є вираз…',
    answers: ['x += 1', 'x = x + 1', 'x =+ 1', 'x = 1 + x'],
    correct_answer: 2
  },
  {
    question: 'Числовим літералом шістнадцятково числа є…',
    answers: ['0xFF', '0b1010', '123', '3.14'],
    correct_answer: 0
  },
  {
    question: 'Основою класів в мові Ruby не є…',
    answers: ['Об\'єкти', 'Методи', 'Модулі', 'Змінні'],
    correct_answer: 3
  },
  {
    question: 'Прикладом сінглтону в мові Ruby є…',
    answers: ['Class.new', 'self.method_name', 'include ModuleName', 'attr_accessor :property'],
    correct_answer: 1
  },
  {
    question: 'Які основні типи даних підтримуються в мові Ruby?',
    answers: ['Числа, рядки, булеві значення', 'Масиви, хеші, символи', 'Об\'єкти, класи, модулі', 'Всі вище згадані'],
    correct_answer: 3
  },
  {
    question: 'Що таке блок коду в мові Ruby і як його використовувати?',
    answers: ['Це функція з параметрами, яку можна викликати в коді.',
      'Це умовна конструкція для перевірки виразу.',
       'Це секція коду, яку можна передати до методу для виконання.',
       'Блок коду в мові Ruby використовується для створення коментарів.'],
    correct_answer: 2
  },
  {
    question: 'Що таке ітерація (повторення) в мові Ruby? Який метод часто використовується для ітерації?',
    answers: ['Це процес виконання певного коду кілька разів',
      'Це спосіб виконання умовної конструкції безпосередньо в коді.',
      'Це зміна значення змінної в процесі виконання програми.',
       'Метод each часто використовується для ітерації.'],
    correct_answer: 0
  },
  {
    question: 'Що таке модуль в мові Ruby і для чого він використовується?',
    answers: ['Це тип даних, що зберігає послідовність символів.',
       'Це контейнер для зберігання об\'єктів різних типів.',
        'Це блок коду, який можна викликати в програмі.',
         'Модуль використовується для групування методів та констант, які можна включити в класи для розширення їх функціональності.'],
    correct_answer: 3
  },
]

class QuizBot
  def initialize(questions)
    @questions = questions
    @current_question_index = 0
    @correct_answers = 0
    @stopped = false
  end

  def start(bot, message)
    send_question(bot, message.chat.id)
  end

  def answer(bot, message)
    return if @stopped || message.text.nil? || @current_question_index >= @questions.length

    answer_index = %w[a b c d].index(message.text.downcase)
    if answer_index && (answer_index + 1) == @questions[@current_question_index][:correct_answer]
      @correct_answers += 1
      bot.api.send_message(chat_id: message.chat.id, text: 'Правильно!')
    else
      correct_answer = @questions[@current_question_index][:answers][@questions[@current_question_index][:correct_answer] - 1]
      bot.api.send_message(chat_id: message.chat.id, text: "Не правильно. Правильна відповідь: #{correct_answer}")
    end

    @current_question_index += 1
    send_question(bot, message.chat.id)
  end

  def stop(bot, message)
    @stopped = true
    bot.api.send_message(chat_id: message.chat.id, text: 'Гра завершена. Дякую за участь!')
  end

  private

  def send_question(bot, chat_id)
    return if @stopped || @current_question_index >= @questions.length

    question = @questions[@current_question_index]
    answer_buttons = question[:answers].map { |answer| Telegram::Bot::Types::KeyboardButton.new(text: answer) }
    markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: answer_buttons.each_slice(2).to_a)

    bot.api.send_message(chat_id: chat_id, text: question[:question], reply_markup: markup)
  end
end

Telegram::Bot::Client.run(token) do |bot|
  quiz_bot = QuizBot.new(questions)

  bot.listen do |message|
    case message.text
    when '/start'
      quiz_bot.start(bot, message)
    when '/stop'
      quiz_bot.stop(bot, message)
    else
      quiz_bot.answer(bot, message)
    end
  end
end
