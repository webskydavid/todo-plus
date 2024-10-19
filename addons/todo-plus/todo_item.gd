@tool
class_name TodoItem extends VBoxContainer

signal delete_signal(todo: TodoItem)
signal done_signal(todo: TodoItem)

@onready var todo_bg: ColorRect = %TodoBackground
@onready var title: LineEdit = %Title
@onready var desc: TextEdit = %Description
@onready var done: CheckBox = %Done
@onready var start: TextureButton = %Start
@onready var stop: TextureButton = %Stop
@onready var pause: TextureButton = %Pause
@onready var delete: TextureButton = %Delete
@onready var time: Label = %Time
@onready var time_update: Timer = %TimeUpdate
@onready var confirm: ConfirmationDialog = %ConfirmationDialog

@export var item: Todo

func update_item_visibility() -> void:
	if(item.started and !item.paused): # Started
		start.visible = false
		stop.visible = true
		pause.visible = true
		time.visible = true
	elif(item.started and item.paused): # Paused
		start.visible = true
		stop.visible = true
		pause.visible = false
	elif(item.deleted):
		done.visible = false
		start.visible = false
		stop.visible = false
		pause.visible = false
		delete.visible = false

func _ready() -> void:
	title.text = item.data.title
	desc.text = item.data.description
	desc.visible = item.visible
	update_item_visibility()

func _on_toggle_description_pressed() -> void:
	var status = !desc.visible
	desc.visible = status

func _on_start_button_up() -> void:
	item.started = true
	item.paused = false
	time_update.start()
	update_item_visibility()

func _on_stop_pressed() -> void:
	item.timer = 0.0
	item.started = false
	item.paused = false

	start.visible = true
	stop.visible = false
	pause.visible = false
	time.visible = false

	time_update.stop()

func _on_pause_pressed() -> void:
	item.paused = true
	start.visible = true
	stop.visible = true
	pause.visible = false
	time_update.stop()

func _on_delete_pressed() -> void:
	confirm.visible = true

func _on_time_update_timeout() -> void:
	item.timer += 1

func _on_title_text_submitted(new_text: String) -> void:
	item.data.title = new_text

func _on_description_text_changed() -> void:
	item.data.description = desc.text

func _on_confirmation_dialog_confirmed() -> void:
	self.modulate = Color(Color.WHITE, 0.5)
	time_update.stop()
	item.deleted = true
	done.visible = false
	start.visible = false
	stop.visible = false
	pause.visible = false
	delete.visible = false
	delete_signal.emit(self)

func _on_check_box_toggled(toggled_on: bool) -> void:
	item.is_done = toggled_on
	time_update.stop()
	if(toggled_on):
		todo_bg.color = Color(0.373, 0.668, 0.331, 0.3)
		start.visible = false
		stop.visible = false
		pause.visible = false
		delete.visible = false
	else:
		todo_bg.color = Color(0.242, 0.449, 0.297, 0.0)
		start.visible = true
		delete.visible = true
	done_signal.emit(self)
