class_name Enemy extends CharacterBody2D

signal dead()

@export var health: int = 10
@export var damage: float = 1

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _process(delta: float) -> void:
	if health <= 0:
		dead.emit()
		animation_player.play("death")
		await(get_tree().create_timer(1.0).timeout)
		queue_free()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Sword"):
		health -= 1
		if Globals.soul <= 1.0:
			Globals.soul += 0.25

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Globals.health -= damage
