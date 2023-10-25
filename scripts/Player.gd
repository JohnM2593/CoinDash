extends Area2D
@export var speed = 350
var velocity = Vector2.ZERO
var screensize = Vector2(480, 720)

signal pickup
signal hurt

func start():
	set_process(true)
	position = screensize / 2
	
func _process(delta):
	velocity = Input.get_vector("left", "right", "up", "down")
	position += velocity * speed * delta
	
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)

	if velocity.length() > 0:
		$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("idle")
		
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0

func _on_area_entered(area):
	if area.is_in_group("coins"):
		area.pickup()
		pickup.emit("coin")
	if area.is_in_group("powerups"):
		area.pickup()
		pickup.emit("powerup")
	if area.is_in_group("obstacles"):
		hurt.emit()
		die()

func die():
	$AnimatedSprite2D.play("hurt")
	set_process(false)
