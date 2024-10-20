class_name Todo extends Resource


var item_instance
@export var data: Dictionary
@export var timer: float
@export var started: bool
@export var paused: bool
@export var deleted: bool = false
@export var visible: bool
@export var is_done: bool = false
@export var priority: int = 0
@export var timestamp: float = 0.0

var current_prio = -1
var priority_colors = [Color.DARK_GRAY, Color.MEDIUM_SEA_GREEN, Color.YELLOW, Color(1, 0.3, 0.237)]

func _init(_item_instance, _data, _timer, _started, _paused, _visible) -> void:
	item_instance = _item_instance
	data = _data
	timer = _timer
	started = _started
	paused = _paused
	visible = _visible
	if(timestamp == 0.0):
		timestamp = Time.get_unix_time_from_system()

func update():
	var current_timer = timer
	if(!timer):
		current_timer = 0.0

	if(item_instance.time):
		item_instance.time.text = str(Time.get_time_string_from_unix_time(current_timer))

	var priority_node = item_instance.priority as OptionButton
	if(priority_node):
		if(current_prio < 0 or current_prio != priority):
			current_prio = priority
			priority_node.modulate = priority_colors[priority]

func to_dictionary() -> Dictionary:
	return {
		'data': data,
		'timer': timer,
		'started': started,
		'paused': true,
		'deleted': deleted,
		'visible': visible,
		'is_done': is_done,
		'priority': priority,
		'timestamp': timestamp
	}

func from_dictionary(dic) -> void:
	for key in dic.keys():
		set(key, dic[key])
