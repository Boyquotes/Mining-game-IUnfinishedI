extends StaticBody3D

var place
var is_ready :bool = false
var timer : float
var Silo_upgrades : Dictionary = {"level":1,"speed":1,"storage":1} #pickup speed storage
#var Silo_func : Dictionary = {"max_ammount":(500 * Silo_upgrades["storage"])}
#var Silo_prices := [250 * Silo_upgrades["level"],250 * Silo_upgrades["speed"],250 * Silo_upgrades["storage"]]
#var Inv_Minerals := {"rock":0,"coal":0,"iron":0,"titanium":0,"gold":0,"diamond":0,"mosaic":0,"quantum":0}
#var Inv_Crystal := {"eletric":0,"radiation":0,"magma":0,"lava":0,"phosphor":0,"quantum":0}
#var Inventory := {"Minerals":Inv_Minerals,"Crystal":Inv_Crystal}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_ready == true:
		place.button_text = ["Level","Storage","pickup","Destroy"]
	#print(button_text)
	#button_text = ["Speed","Storage","Oil","Destroy"]

func _on_area_3d_body_entered(body):
	if body.is_in_group("place"):
		place = body
		is_ready = true
