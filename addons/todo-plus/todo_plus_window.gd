@tool
extends Control


@onready var add_new_todo: Button = %AddNewTodo
@onready var list = %List
var todo_item: PackedScene
var counter: int = 0;

var items: Array[Todo] = []
var finished_items: Array[Todo] = []
var deleted_items: Array[Todo] = []


func _ready() -> void:
	todo_item = preload('todo_item.tscn')

func _process(delta: float) -> void:
	for item in items:
		item.update()

func _on_add_new_todo_pressed() -> void:
	var i = todo_item.instantiate()
	i.connect('delete', _on_delete)
	var data = {
		'title': '',
		'description': '',
	}
	var todo = Todo.new(i, 1, data, 0.0, false, false, false)
	i.item = todo
	items.append(todo)
	list.add_child(i)

func _on_delete(item: Todo) -> void:
	for i in items:
		if(i == item):
			i.item_instance.queue_free()
			deleted_items.append(i)
