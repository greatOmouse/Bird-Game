extends CharacterBody2D

@export var jump: AudioStream
@export var plop: AudioStream
@export var fall: AudioStream
@export var max: AudioStream
@onready var sound = $Sound


@onready var anim = $sprite
@onready var timer = $deadTimer
@export var camera : Camera2D

@onready var dust = $landingDust

var dir = 1

const SPEED = 85.0
const JUMP_VELOCITY = 200.0

var dead = false
var deadTime = 0.45
var currentJumpForce = 0.0
var rate = 200.0

var loading = false
var maxxed = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 500

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if !dead:
		movement(delta)
	move_and_slide()
	
	handleAnims()

func movement(delta):
	if is_on_floor():
		velocity.x = 0
		var result = Input.get_axis("left", "right")
		if(result != 0):
			dir = result
			
	# Handle Jump.
	if is_on_floor():
		if Input.is_action_just_released("jump"):
			#add to jump force
			sound.stream = jump
			sound.pitch_scale = randf_range(0.8,1.2)
			sound.play()
			loading = false
			maxxed = false
			velocity.y = -currentJumpForce
			velocity.x = dir * SPEED
			currentJumpForce = 0
		
		if Input.is_action_pressed("jump"):
			loading = true
			currentJumpForce += rate * delta
			currentJumpForce = clamp(currentJumpForce, 0,JUMP_VELOCITY)
			if(currentJumpForce >= JUMP_VELOCITY && !maxxed):
				maxxed = true;
				sound.stream = max
				sound.pitch_scale = randf_range(0.8,1.2)
				sound.play()
			
		if !timer.is_stopped():
			timer.stop()
	else:
		if timer.is_stopped() and velocity.y > 0 and !dead:
			timer.start(deadTime)
			print("timer started init")
			pass
	



func handleAnims():
	if not is_on_floor():
		if velocity.y < 0:
			anim.play("jump")
		else: 
			anim.play("fall")
	else:
		if(dead and velocity == Vector2.ZERO):
			if anim.animation != "die":
				anim.play("die")
				dust.emitting = true
				#camera shake
				sound.stream = fall
				sound.pitch_scale = 1
				sound.play()
				camera.call("startShake")
			else:
				if(timer.is_stopped()):
					timer.start(1.5)
				pass
		else:
			if anim.animation != "dead":
				if(loading):
					if(currentJumpForce >= JUMP_VELOCITY):
						anim.play("max")
					else:
						anim.play("load")
				else:
					anim.play("idle")
			if sound.stream != plop && !maxxed:
				sound.stream = plop
				sound.pitch_scale = 1
				sound.play()

	anim.flip_h = dir < 0
	
	pass


func _on_dead_timer_timeout():
	if not is_on_floor():
		dead = true
		timer.stop()
		print("dead")
	else:
		print("not dead")
		dead = false
		timer.stop()
		pass
	pass # Replace with function body.
