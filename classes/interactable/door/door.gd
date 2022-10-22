class_name Door
extends Area2D

const ENTER_LENGTH = 60

const TRANSITION_SPEED_IN = 15
const TRANSITION_SPEED_OUT = 15

export var target_pos: Vector2
export var move_to_scene = false
export var scene_path : String

var timer = 0
var entering = false
var can_warp = false
var target = null
var store_state = 0

onready var sweep_effect = $"/root/Singleton/WindowWarp"

func _physics_process(_delta):
	if entering:
		# Do entering animation
		pass
	
	if can_warp:
		# Begin entering door if up is pressed (while grounded + standing still)
		if Input.is_action_pressed("up") and store_state == target.S.NEUTRAL and target.is_on_floor():
			target.locked = true
			$DoorSprite.play("opening")
			entering = true
		
	# Tick the animation timer
	if entering == true:
		timer += 1
		
	# When the timer rings, warp Mario
	if timer == ENTER_LENGTH:
		if move_to_scene == true:
			sweep_effect.warp(target_pos, scene_path, TRANSITION_SPEED_IN, TRANSITION_SPEED_OUT)
		else:
			# teleport Mario within the level
			target.position = target_pos
			
			# reset Mario to normal
			target.locked = false
			
			# Reset door to normal
			entering = false


func _on_mario_touch(body):
	if body.state == body.S.NEUTRAL:
		can_warp = true
		target = body


func _on_mario_off(_body):
	can_warp = false # Or else he won't
	target = null
