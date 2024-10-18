class_name Todo extends Resource


var item_instance: TodoItem
var key: int
var data: Dictionary
var timer: float
var started: bool
var paused: bool
var visible: bool

func _init(_item_instance, _key, _data, _timer, _started, _paused, _visible) -> void:
	item_instance = _item_instance
	key = _key
	data = _data
	timer = _timer
	started = _started
	paused = _paused
	visible = _visible

func update():
	var current_timer = timer
	if(!timer):
		current_timer = 0.0

	if(item_instance.time):
		item_instance.time.text = str(Time.get_time_string_from_unix_time(current_timer))
