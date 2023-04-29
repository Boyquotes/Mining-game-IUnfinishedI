extends StaticBody3D

var prompt : String = "change building"
var in_UI : bool = false

var place_type : Dictionary = {"Silo":true,"Refinery":false,"Miner":false}

@onready var button = $Control/VBoxContainer/Button
@onready var button_2 = $Control/VBoxContainer/Button2
@onready var button_3 = $Control/VBoxContainer/Button3


#Silo
var Silo_upgrades : Dictionary = {"level":1,"storage":1,"oil":1}
var Silo_func : Dictionary = {"max_ammount":(500 * Silo_upgrades["storage"])}
var Inv_Minerals := {"rock":0,"coal":0,"iron":0,"titanium":0,"gold":0,"diamond":0,"mosaic":0,"quantum":0}
var Inv_Crystal := {"eletric":0,"radiation":0,"magma":0,"lava":0,"phosphor":0,"quantum":0}
var Inventory := {"Minerals":Inv_Minerals,"Crystal":Inv_Crystal}

#Refinery
var Refinery_upgrades : Dictionary = {"level":1,"speed":1,"storage":1}

#Miner
var Miner_upgrades : Dictionary = {"level":1,"speed":1,"storage":1}

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if place_type["Miner"]:
		Miner()
	elif place_type["Refinery"]:
		Refinery()
	elif  place_type["Silo"]:
		Silo()
	else:
		None()
	
	if in_UI == true:
		$Control.show()
	else : 
		$Control.hide()

 
func Silo():
	pass

func Refinery():
	pass

func Miner():
	pass

func None():
	pass


func _on_button_pressed():
	pass # Replace with function body.


func _on_button_2_pressed():
	pass # Replace with function body.


func _on_button_3_pressed():
	pass # Replace with function body.


func _on_area_3d_body_exited(body):
	if body.is_in_group("Player"):
		in_UI = false
