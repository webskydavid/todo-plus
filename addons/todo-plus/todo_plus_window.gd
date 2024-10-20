@tool
class_name TodoPlusWindow extends Control

signal has_started_item

@onready var add_new_todo: Button = %AddNewTodo
@onready var new_list = %NewList
@onready var done_list = %DoneList
@onready var deleted_list = %DeletedList
@onready var done_total_time = %DoneTotalTime

var todo_item: PackedScene
var counter: int = 0;

var new_array: Array[Todo] = []
var done_array: Array[Todo] = []
var deleted_array: Array[Todo] = []

var done_sum: Dictionary = {}

#region PUBLIC METHODS
func get_data() -> Dictionary:
	return {
		'new_array': _get_inner_data(new_array),
		'done_array': _get_inner_data(done_array),
		'deleted_array': _get_inner_data(deleted_array)
	}

func restore_data(data: Dictionary) -> void:
	_restore_data_for('new', new_list, data)
	_restore_data_for('done', done_list, data)
	_restore_data_for('deleted', deleted_list, data)
#endregion

#region PRIVATE METHODS
func _ready() -> void:
	todo_item = preload('todo_item.tscn')

func _process(delta: float) -> void:
	for item in new_array:
		item.update()

func _create_todo_instance(to_replace = null) -> TodoItem:
	var new_item = todo_item.instantiate() as TodoItem
	new_item.connect('delete_signal', _on_delete)
	new_item.connect('done_signal', _on_done)
	new_item.new_array = new_array
	var data = {
		'title': '',
		'description': '',
	}
	var todo = Todo.new(new_item, data, 0.0, false, false, false)
	if(to_replace != null):
		todo.from_dictionary(to_replace)

	new_item.item = todo
	return new_item

func _get_inner_data(array: Array) -> Dictionary:
	var dic = {}
	for i in array.size():
		dic[i] = array[i].to_dictionary()
	return dic

func _restore_data_for(array_type: String,list, data: Dictionary) -> void:
	var array_name = array_type + '_array'
	var list_name = array_name + '_list'
	if(data.has(array_name)):
		for key in data[array_name].keys():
			var new_item = _create_todo_instance(data[array_name][key])
			get(array_name).append(new_item.item)
			list.add_child(new_item)

		if(array_type == 'done'):
			done_total_time.text = _timer_sum(get(array_name))

		(get(array_name) as Array[Todo]).sort_custom(func(a, b): return b.timestamp > a.timestamp)

func _timer_sum(array: Array[Todo]) -> String:
	var sum = done_array.reduce(func(accum, item): return accum + item.timer, 0)
	return '(%s)' % Time.get_time_string_from_unix_time(sum)

#endregion

#region SIGNALS
func _on_add_new_todo_pressed() -> void:
	var todo_item = _create_todo_instance()
	new_array.append(todo_item.item)
	new_list.add_child(todo_item)

func _on_delete(todo_item: TodoItem) -> void:
	for i in new_array:
		if(i == todo_item.item):
			new_array.erase(i)
			new_list.remove_child(todo_item)
			deleted_array.push_front(i)
			deleted_list.add_child(todo_item)

func _on_done(todo_item: TodoItem) -> void:
	if(todo_item.item.is_done):
		for i in new_array:
			if(i == todo_item.item):
				new_array.erase(i)
				new_list.remove_child(todo_item)
				done_array.push_front(i)
				done_list.add_child(todo_item)
	else:
		for i in done_array:
			if(i == todo_item.item):
				done_array.erase(i)
				done_list.remove_child(todo_item)
				new_array.push_front(i)
				new_list.add_child(todo_item)

	done_total_time.text = _timer_sum(done_array)

#endregion
