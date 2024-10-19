@tool
extends Control


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


func _ready() -> void:
	todo_item = preload('todo_item.tscn')

func _process(delta: float) -> void:
	for item in new_array:
		item.update()

func _on_add_new_todo_pressed() -> void:
	var i = todo_item.instantiate()
	i.connect('delete_signal', _on_delete)
	i.connect('done_signal', _on_done)
	var data = {
		'title': '',
		'description': '',
	}
	var todo = Todo.new(i, 1, data, 0.0, false, false, false)
	i.item = todo
	new_array.append(todo)
	new_list.add_child(i)

func _on_delete(todo_item: TodoItem) -> void:
	for i in new_array:
		if(i == todo_item.item):
			new_list.remove_child(todo_item)
			deleted_array.append(i)
			deleted_list.add_child(todo_item)

func _on_done(todo_item: TodoItem) -> void:
	if(todo_item.item.is_done):
		for i in new_array:
			if(i == todo_item.item):
				new_array.erase(i)
				new_list.remove_child(todo_item)
				done_array.append(i)
				done_list.add_child(todo_item)
	else:
		for i in done_array:
			if(i == todo_item.item):
				done_array.erase(i)
				done_list.remove_child(todo_item)
				new_array.append(i)
				new_list.add_child(todo_item)

	var sum = done_array.reduce(func(accum, item): return accum + item.timer, 0)
	done_total_time.text = '(%s)' % Time.get_time_string_from_unix_time(sum)
