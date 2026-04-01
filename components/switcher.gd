extends Node
## A switcher encapsulates the logic for navigating through a sequence of items in both directions.
##
## It exposes two operations: left and right. The left operation decrements the current index by one,
## while right increments it by one. When the infinite option is enabled, the index wraps around—moving
## left from the first item jumps to the last, and moving right from the last item returns to the first.
class_name Switcher

@export var content: Array = []
## Index selected by default.
@export var idx: int 
## If true, the index will jump from the last element to the first in case there are no more elements.
@export var infinite: bool = false



func right():
	if idx+1 < len(content):
		idx += 1
	elif infinite:
		idx = 0
		
func left():
	if idx - 1 >= 0:
		idx -= 1
	elif infinite:
		idx = len(content) - 1

func custom_select_idx(new_idx:int):
	if content.get(new_idx):
		idx = new_idx
	else:
		push_warning("Tried to select a value that did not exists.")

func custom_select_item(element):
	if element in content:
		idx = content.find(element)
	else:
		push_warning("Tried to select an item that did not exists.")

func get_item():
	return content[idx]
