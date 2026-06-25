extends Node

# Задаем константу пути, куда будем сохранять. 
# Используем user:// чтобы игра могла писать файлы после компиляции в EXE.
const SAVE_PATH = "user://azart_save.json"

# Это наш "виртуальный" файл сохранения. 
# Пока игра запущена, мы работаем с этой переменной, а не дергаем жесткий диск.
# Сразу задаем значения по умолчанию (если игрок зашел в первый раз).
var save_data : Dictionary = {
	"max_unlocked_level": 1
}

# Функция для сохранения данных на диск
func save_game():
	# Открываем файл в режиме ЗАПИСИ (WRITE). 
	# Если файла нет - он создастся. Если есть - полностью перезапишется.
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	
	# Превращаем наш словарь из RAM в строку формата JSON
	var json_string = JSON.stringify(save_data)
	
	# Записываем эту строку в файл
	file.store_string(json_string)

# Функция для загрузки данных с диска
func load_game():
	# Если файла на диске еще нет (игрок запустил игру первый раз) - ничего не делаем, 
	# будут использоваться дефолтные значения из переменной save_data
	if not FileAccess.file_exists(SAVE_PATH):
		return
	
	# Превращаем текст формата JSON обратно в структуру данных (словарь)
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	
	# Читаем весь текст из файла
	var json_string = file.get_as_text()
	
	# Превращаем текст формата JSON обратно в структуру данных (словарь)
	var parsed_data = JSON.parse_string(json_string)
	
	
	if typeof(parsed_data) == TYPE_DICTIONARY:
		# Функция merge объединяет дефолтный словарь с загруженным.
		# Это круто тем, что если в будущем с обновлением игры добавлю новые настройки,
		# они не удалятся старым сохранением игрока.
		save_data.merge(parsed_data, true)

# Вызывается один раз при самом старте игры
func _ready() -> void:
	# При запуске игры сразу пытаемся загрузить прогресс
	load_game()
