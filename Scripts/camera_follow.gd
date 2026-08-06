class_name CameraFollow extends Camera2D

@export var horizontal_dead_zone: int = 30
@export var vertical_dead_zone: int = 30
@export var follow_speed: float = 120.0

@onready var ground: TileMapLayer = $"../Ground"
@onready var player: PlayerController = $"../Player"

func _ready() -> void:
	setup_camera_limits()

func _physics_process(delta: float) -> void:
	update_camera_position(delta)

func setup_camera_limits() -> void:
	global_position = player.global_position
	var used_rect = ground.get_used_rect()
	var cell_size = ground.tile_set.tile_size
	var map_width = used_rect.size.x * cell_size.x
	var map_height = used_rect.size.y * cell_size.y
	
	limit_left = used_rect.position.x * cell_size.x
	limit_right = limit_left + map_width
	limit_top = used_rect.position.y * cell_size.y
	limit_bottom = limit_top + map_height

func update_camera_position(delta) -> void:
	if not player:
		return
	
	var player_pos = player.global_position
	var camera_pos = global_position
	var viewport_size = get_viewport_rect().size / zoom
	
	var target_pos = camera_pos
	
	if abs(player_pos.x - camera_pos.x) > horizontal_dead_zone:
		target_pos.x = player_pos.x
	
	if player_pos.y < camera_pos.y - vertical_dead_zone:
		target_pos.y = player_pos.y
	elif player_pos.y > camera_pos.y + vertical_dead_zone:
		target_pos.y = player_pos.y
	
	position.x = move_toward(position.x, target_pos.x, follow_speed * delta)
	
	if position.y > camera_pos.y:
		position.y = move_toward(position.y, target_pos.y, player.velocity.y * delta)
	else:
		position.y = move_toward(position.y, target_pos.y, follow_speed * delta)
