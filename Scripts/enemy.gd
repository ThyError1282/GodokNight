class_name Enemy extends CharacterBody2D

@export var health: int = 4
@export var damage: float = .25

func _process(delta: float) -> void:
	if health <= 0:
		queue_free()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Sword"):
		health -= 1
		if Globals.soul <= 1.0:
			Globals.soul += 0.25

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Globals.health -= damage
