extends StaticBody3D

var place
var player
var is_ready :bool = false
var timer : float
var Miner_upgrades : Dictionary = {"level":1,"storage":1}
var rng = RandomNumberGenerator.new()
var storage : int = 500
var give_coins : int = 0
var type := [] 
var amount : int = 0
var reset_active : bool = true

#remove_when singletons  -------------------------------------------------------
var sell_Minerals := {"rock":1,"coal":5,"iron":10,"titanium":15,"gold":20,"diamond":25,"mosaic":35,"quantum":50}
var sell_Crystal := {"eletric":5,"radiation":10,"magma":20,"lava":25,"phosphor":30,"quantum":50}
var Inventory := {"Minerals":sell_Minerals,"Crystal":sell_Crystal}
#   --------------------------------------------------------------------------------------------------------------

func _process(delta):
	if is_ready == true:
		if reset_active == true:
			place.button_active = [false,false,false]
			reset_active = false
		place.button_text = ["Level : " + str(Miner_upgrades["level"]),"Storage : " + str(Miner_upgrades["storage"]),"sell","Destroy"]
		if place.button_active[0]:
			level_upgrade()
		if place.button_active[1]:
			storage_upgrade()
		if place.button_active[2]:
			sell()
		if amount > storage:
			amount = storage
		print(amount)

func storage_upgrade():
	if Miner_upgrades["storage"] <= 5 and player.coins > 150* Miner_upgrades["storage"]:
		Miner_upgrades["storage"] += 1
		player.coins -= 150 * Miner_upgrades["storage"]
		storage = 500 * Miner_upgrades["storage"]
	place.button_active[1] = false

func level_upgrade():
	if Miner_upgrades["level"] <= 5 and player.coins > 150* Miner_upgrades["level"]:
		Miner_upgrades["level"] += 1
		player.coins -= 150 * Miner_upgrades["level"]
	place.button_active[0] = false

func sell():
	give_coins = Inventory["Minerals"]["rock"] * amount
	player.coins += give_coins
	give_coins = 0
	amount = 0 
	place.button_active[2] = false

func _on_area_3d_body_entered(body):
	if body.is_in_group("place"):
		place = body
	if body.is_in_group("Player"):
		player = body
	if player != null and place != null:
		is_ready = true


func _on_timer_timeout():
	amount += rng.randi_range(1 * Miner_upgrades["level"],3 * Miner_upgrades["level"])
	$Timer.start()
