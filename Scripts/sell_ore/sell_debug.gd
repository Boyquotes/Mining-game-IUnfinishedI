extends CharacterBody3D

var prompt : String = "press E to sell"
var pressed : bool = false

var sell_Minerals := {"rock":1,"coal":5,"iron":10,"titanium":15,"gold":20,"diamond":25,"mosaic":35,"quantum":50}
var sell_Crystal := {"eletric":5,"radiation":10,"magma":20,"lava":25,"phosphor":30,"quantum":50}

var Inv_Minerals := {"rock":0,"coal":0,"iron":0,"titanium":0,"gold":0,"diamond":0,"mosaic":0,"quantum":0}
var Inv_Crystal := {"eletric":0,"radiation":0,"magma":0,"lava":0,"phosphor":0,"quantum":0}

var give_coins = 0
var player
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if pressed == true:
		for i in Inv_Minerals:
			give_coins += Inv_Minerals[i] * sell_Minerals[i]
		for i in Inv_Crystal:
			give_coins += Inv_Crystal[i] * sell_Crystal[i]
		player.coins = give_coins
		for i in player.Inventory:
			for x in player.Inventory[i]:
					player.Inventory[i][x] = 0
		player.ore_inv = 0
		pressed = false


func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		player = body
