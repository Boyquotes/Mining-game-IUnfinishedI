extends StaticBody3D
class_name Place

var prompt : String = "change building"
var in_UI : bool = false
var player 
var place_type : Dictionary = {"Silo":false,"Refinery":false,"Miner":false}

@onready var button := $Control/CanvasLayer/VBoxContainer/Button
@onready var button_1 := $Control/CanvasLayer/VBoxContainer/Button2
@onready var button_2 := $Control/CanvasLayer/VBoxContainer/Button3
@onready var button_3 := $Control/CanvasLayer/VBoxContainer/Button4

var button_text := ["Miner","Refinery","Silo","Destroy"]

var Silo := preload("res://Actors/place/Silo/silo.tscn")
var Refinery := preload("res://Actors/place/Refinery/refinery.tscn")

#Refinery
var Refinery_upgrades : Dictionary = {"level":1,"speed":1,"storage":1}

#Miner
var Miner_upgrades : Dictionary = {"level":1,"speed":1,"storage":1}

var places := []

func _process(delta):
	button.text = "Miner"#button_text[0]
	button_1.text = "Refinery"#button_text[1]
	button_2.text = "Silo"#button_text[2]
	button_3.text = "Destroy"#button_text[3]
	if in_UI == true:
		$Control.show()
		$Control/CanvasLayer.show()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		$Control/CanvasLayer/VBoxContainer.mouse_filter = 0
	else : 
		$Control/CanvasLayer.hide()
		$Control.hide()
	
	print(place_type)

func checks():
	for i in place_type:
		if place_type[i] == true:
			#button_text[3] = "Destroy"
			button_3.show()
		

func place_building(price,type,type_str):
	var no_build := 0
	for i in place_type:
		if place_type[i] == false:
			no_build += 1
		if no_build == 3:
			if player.coins >= price:
				player.coins -= price
				$building.add_child(type)
				place_type[type_str] = true
				places.append($building.get_child(0))
				checks()

func _on_area_3d_body_entered(body):
	player = body



func _on_button_button_up():
	pass # Replace with function body.


func _on_button_2_button_up():
	var Refinery_inst = Refinery.instantiate()
	place_building(300,Refinery_inst,"Refinery")

func _on_button_3_button_up():
	var Silo_inst = Silo.instantiate()
	place_building(300,Silo_inst,"Silo")


func _on_button_4_button_up():
	for i in places:
		get_tree().queue_delete(i)
	for i in place_type:
		place_type[i] = false
	button_text = ["Miner","Refinery","Silo","Destroy"]
	button_3.hide()


func _on_area_3d_body_exited(body):
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	in_UI = false
