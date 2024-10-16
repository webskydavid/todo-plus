@tool
extends Control

var todos: Dictionary[int, Dictionary] = {
	1: {
		'name': 'Todo 1',
		'description': 'Description blabla',
		'started': '',
		'finished': '',
		'timeline':[1220]
	}
}

func _ready() -> void:
	prints('fjweofjweojo')
	prints(Time.get_time_string_from_system())

func _enter_tree() -> void:
	prints(212123)
