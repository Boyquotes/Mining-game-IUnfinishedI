extends CharacterBody3D
class_name  Player

@export var max_walk_speed : float = 10.0 
@export var max_run_speed : float = 15.0 
@export var jump_velocity : float = 4.5 
@export var health : float = 100
@export var max_stamina : float = 250

var speed : float = 0.0
var gravity : int = 10
var max_speed : float = 10.0 
var stamina : float = 300
var running : bool = false
var coins : int
var last_direction : Vector3

@onready var head := $head
@onready var camera := $head/Camera3D
@onready var coll := $CollisionShape3D

#UI
@onready var health_UI := $UI/base_ui/health
@onready var stamina_UI := $UI/base_ui/stamina
@onready var coins_UI := $UI/base_ui/coins
@onready var ore_health := $UI/ore_health/Label
@onready var sub_viewport_container := $head/Camera3D/SubViewportContainer
@onready var sub_viewport := $head/Camera3D/SubViewportContainer/SubViewport
@onready var drill_camera := $head/Camera3D/SubViewportContainer/SubViewport/Drill_Camera
@onready var prompt = $UI/prompt

#Drill
@onready var anim_play := $head/Camera3D/SubViewportContainer/SubViewport/Drill_Camera/Drill/AnimationPlayer
@onready var raycast = $head/Camera3D/RayCast3D
@export var damage : float = 0.1

#Inventory 
var Inv_Max_ore : int = 100
var ore_inv : int
var ore_amount : int
var Inv_Minerals := {"rock":0,"coal":0,"iron":0,"titanium":0,"gold":0,"diamond":0,"mosaic":0,"quantum":0}
var Inv_Crystal := {"eletric":0,"radiation":0,"magma":0,"lava":0,"phosphor":0,"quantum":0}
var Inventory := {"Minerals":Inv_Minerals,"Crystal":Inv_Crystal}


func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif event.is_action_pressed("exit"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			$".".rotate_y(-event.relative.x * 0.005)
			camera.rotate_x(-event.relative.y * 0.005)
			camera.rotation.x = clamp(camera.rotation.x,deg_to_rad(-90),deg_to_rad(90))

func _ready():
	sub_viewport.size = DisplayServer.window_get_size()

func _physics_process(delta):
	animations()
	stamina_functions(delta)
	movement(delta)
	move_and_slide()
	UI()
	mining()
	sell(Inv_Minerals,Inv_Crystal)
	place()

func movement(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	var input_dir = Input.get_vector("walk_left", "walk_right", "walk_foward", "walk_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		speed += delta * 15
		if speed >= max_speed or speed <= -max_speed:
			if speed < 0: speed = -max_speed
			else : speed = max_speed
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		last_direction = direction
	else:
		if speed != 0:
			if speed < 0 : speed += delta * 35
			else  : speed -= delta * 35
			if speed < 1 and speed > -1: speed = 0
		velocity.x = last_direction.x * speed
		velocity.z = last_direction.z * speed

func UI():
	drill_camera.global_position = camera.global_position
	drill_camera.rotation = rotation
	drill_camera.rotation.x = camera.rotation.x
	health_UI.text = "health : " + str(health)
	stamina_UI.text = "stamina : " + str(round(stamina))
	coins_UI.text = "coins : " + str(coins)
	Inventory_UI()

func stamina_functions(delta):
	if Input.is_action_just_pressed("jump") and is_on_floor() == false and stamina >= 100:
		velocity.y = jump_velocity * 1.5
		stamina -= 100
	elif Input.is_action_pressed("run") and stamina > 0 :
		max_speed = max_run_speed
		stamina -= delta * 20
		running = true
	else :
		max_speed = max_walk_speed
		running = false
	if running == false :
		await get_tree().create_timer(0.5).timeout
		if stamina >= max_stamina:
			stamina = max_stamina
		stamina += delta * 5

func animations():
	if Input.is_action_pressed("Drill"):
		anim_play.play("Drill | Drilling")
	elif velocity != Vector3.ZERO and max_speed == max_walk_speed:
		anim_play.play("Drill | Walk ")
	elif velocity != Vector3.ZERO and max_speed == max_run_speed:
		anim_play.play("Drill | Run")

func mining():
	if Input.is_action_pressed("Drill"):
		if raycast.is_colliding():
			if raycast.get_collider().is_in_group("Ore") and raycast.get_collider() != null:
				raycast.get_collider().take_damage(damage)

func get_ore(type:String,ore:String,amount:int):
	ore_amount = 0
	for i in Inventory:
		for x in Inventory[i]:
			ore_amount += Inventory[i][x]
	if (ore_amount + amount) > Inv_Max_ore:
		amount -= (ore_amount + amount) - Inv_Max_ore
	ore_inv += amount
	Inventory[type][ore] += amount

func ore_ui(type:String,beetween:String,health_ore):
	ore_health.text = type + beetween + str(health_ore)

func Inventory_UI():
	var Minerals = []
	var Crystal = []
	Minerals.append_array($UI/Inventory/Minerals.get_children())
	Crystal.append_array($UI/Inventory/Crystal.get_children())
	if Input.is_action_pressed("Inventory"):
		var indicie := 0 
		for i in Inv_Minerals:
			Minerals[indicie].text = i +" : "+str(Inv_Minerals[i])
			indicie += 1
		indicie = 0
		for i in Inv_Crystal:
			Crystal[indicie].text = i +" : "+str(Inv_Crystal[i])
			indicie += 1
		$UI/Inventory/Label3.text = str(Inv_Max_ore) +"/"+ str(ore_inv)
		$UI/Inventory.show()
	else:
		$UI/Inventory.hide()

func sell(Minerals,Crystal):
	if (raycast.is_colliding() == false) or (raycast.get_collider().is_in_group("sell") == false) : 
		prompt.text = ""
	elif raycast.is_colliding():
		if raycast.get_collider().is_in_group("sell"):
			prompt.text = raycast.get_collider().prompt  
			if Input.is_action_just_pressed("interact"):  
				raycast.get_collider().pressed = true
				raycast.get_collider().Inv_Minerals = Minerals
				raycast.get_collider().Inv_Crystal = Crystal

func place():
	if raycast.is_colliding():
		if raycast.get_collider().is_in_group("place"):
				prompt.text = raycast.get_collider().prompt 
