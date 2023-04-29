extends CharacterBody3D
class_name Ore

@export var health : float
@export var type : String 
@export var Ore_name : String
@export var drop_min : int
@export var drop_max : int

var rng = RandomNumberGenerator.new()
var _body 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if health <= 0 :
		die()

func take_damage(damage):
	health -= damage
	_body.ore_ui(Ore_name," : ",round(health))

func die():
	_body.get_ore(type,Ore_name,rng.randi_range(drop_min,drop_max))
	_body.ore_ui("","","")
	queue_free()


func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		_body = body


func _on_area_3d_body_exited(body):
	if body.is_in_group("Player"):
		body.ore_ui("","","")
