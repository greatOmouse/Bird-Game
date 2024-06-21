extends Camera2D

var shake = false
@onready var shakeTimer = $Timer
var shakeTime = 0.05
var count = 0
var shakeAmount = 2

func startShake():
	count = 0
	shakeTimer.start(shakeTime)


func _on_timer_timeout():
	count += 1
	if(count < 15):
		offset = Vector2(randf_range(-shakeAmount,shakeAmount/2),randf_range(-shakeAmount,shakeAmount/2))
		shakeTimer.start(shakeTime)
	else:
		offset = Vector2.ZERO
