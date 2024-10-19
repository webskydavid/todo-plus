@tool
extends EditorPlugin

const FILE_PATH = "res://todo_plus.json"

var window: TodoPlusWindow

func _enter_tree() -> void:
	window = preload('todo_plus_window.tscn').instantiate()
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_UL, window)
	load_data()

func _exit_tree() -> void:
	remove_control_from_docks(window)
	window.free()

func _save_external_data() -> void:
	save_data()

func save_data() -> void:
	var data: Dictionary = window.get_data()
	var file = FileAccess.open(FILE_PATH, FileAccess.WRITE)
	var error = FileAccess.get_open_error()
	if(error != OK):
		printerr("Can't open file todo_plus.json!")
		return

	var string_to_store = JSON.stringify(data, "	")
	file.store_string(string_to_store)

	error = file.get_error()
	if(error != OK):
		printerr("Can't save file!")

	file.close()

func load_data() -> void:
	if(!FileAccess.file_exists(FILE_PATH)):
		printerr("File at path: %s does not exist!" % FILE_PATH)

	var file = FileAccess.open(FILE_PATH, FileAccess.READ)
	var error = FileAccess.get_open_error()
	if (error != OK):
		printerr("Failed to open file '" + FILE_PATH + "' for reading: Error code " + str(error))
		return

	var json = JSON.new()
	var parse_result = json.parse_string(file.get_as_text())
	var parse_error = json.get_error_message()
	if (parse_error != ""):
		printerr("Failed to parse tracked sections: Error code " + parse_error)
	else:
		window.restore_data(parse_result)

	file.close()
