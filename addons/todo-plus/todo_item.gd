@tool
class_name TodoItem extends VBoxContainer

signal delete(key)

@onready var title: LineEdit = %Title
@onready var desc: TextEdit = %Description
@onready var start: TextureButton = %Start
@onready var stop: TextureButton = %Stop
@onready var pause: TextureButton = %Pause
@onready var time: Label = %Time
@onready var time_update: Timer = %TimeUpdate
@onready var confirm: ConfirmationDialog = %ConfirmationDialog

@export var item: Todo

func update_item() -> void:
	if(item.started and !item.paused): # Started
		start.visible = false
		stop.visible = true
		pause.visible = true
		time.visible = true

	elif(item.started and item.paused): # Paused
		start.visible = true
		stop.visible = true
		pause.visible = false

func _ready() -> void:
	title.text = item.data.title
	desc.text = item.data.description
	desc.visible = item.visible
	update_item()

func _on_toggle_description_pressed() -> void:
	var status = !desc.visible
	desc.visible = status

func _on_start_button_up() -> void:
	item.started = true
	item.paused = false
	time_update.start()
	update_item()

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
	time_update.stop()
	update_item()

func _on_delete_pressed() -> void:
	confirm.visible = true


func _on_time_update_timeout() -> void:
	item.timer += 1


func _on_title_text_submitted(new_text: String) -> void:
	item.data.title = new_text


func _on_description_text_changed() -> void:
	item.data.description = desc.text


func _on_confirmation_dialog_confirmed() -> void:
	delete.emit(item)
