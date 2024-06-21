extends Area2D

@onready var confetti = $CPUParticles2D
@onready var toot = $AudioStreamPlayer2D
@onready var song = $song
@export var bird : CharacterBody2D

func _on_body_entered(body):
	if body == bird and confetti.emitting == false:
		toot.play()
		song.play()
		confetti.emitting = true;
