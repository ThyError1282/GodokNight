class_name PlayerController extends CharacterBody2D

@export_category("Movement")
@export var move_speed: int = 120
@export var deceleration: float = 0.1
@export var gravity: float = 500.0

@export_category("Jumping")
@export var jump_speed: float = 230.0
@export var acceleration: float = 290.0
@export var jump_amount: int = 2

@export_category("Walls")
@export var wall_slide: float = 10.0
@export var wall_x_force: float = 200.0
@export var wall_y_force: float = -220.0

@export_category("Dashing")
@export var dash_speed: float = 400.0
@export var facing_right: bool = true
@export var dash_gravity: int = 0
@export var dash_number: int = 1

@onready var detection: RayCast2D = $Raycast/Detection
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var dash_key_pressed: int = 0
var is_dashing: bool = false
var is_wall_jumping: bool = false
var movement = Vector2()
var dash_timer = Timer

func _physics_process(delta: float) -> void:
	if is_dashing == false:
		velocity.y += gravity * delta
	elif is_dashing == true:
		velocity.y = dash_gravity
	
	horizontal_movement()
	jump_logic()
	wall_logic()
	
	set_animations()
	flip()
	
	move_and_slide()

func horizontal_movement() -> void:
	if is_wall_jumping == false and is_dashing == false:
		movement = Input.get_axis("ui_left", "ui_right")
		
		if movement:
			velocity.x = movement * move_speed
		else:
			velocity.x = move_toward(velocity.x, 0, move_speed * deceleration)
	if Input.is_action_just_pressed("ui_dash") and dash_key_pressed == 0 and dash_number >= 1:
		dash_key_pressed = 1
		dash_number -= 1
		dash()

func set_animations() -> void:
	if velocity.x != 0:
		animation_player.play("move")
	if velocity.x == 0:
		animation_player.play("idle")
	if velocity.y < 0:
		animation_player.play("jump")
	if velocity.y > 10:
		animation_player.play("fall")
	if is_on_wall_only():
		animation_player.play("fall")

func flip() -> void:
	if velocity.x > 0.0:
		facing_right = true
		scale.x = scale.y * 1
		wall_x_force = 200.0
	if velocity.x < 0.0:
		facing_right = false
		scale.x = scale.y * -1
		wall_x_force = -200.0

func jump_logic() -> void:
	if is_on_floor():
		dash_number = 1
		jump_amount = 2
		if Input.is_action_just_pressed("ui_accept"):
			jump_amount -= 1
			velocity.y -= lerp(jump_speed, acceleration, 0.1)
			
	if not is_on_floor():
		if jump_amount > 0:
			if Input.is_action_just_pressed("ui_accept"):
				jump_amount -= 1
				velocity.y -= lerp(jump_speed, acceleration, 1)
			
			if Input.is_action_just_released("ui_accept"):
				velocity.y = lerp(velocity.y, gravity, 0.2)
				velocity.y *= 0.3
	else:
		return

func wall_logic() -> void:
	if is_on_wall_only():
		velocity.y = 10
		if Input.is_action_just_pressed("ui_accept"):
			if detection.is_colliding():
				jump_amount = 2
				velocity = Vector2(-wall_x_force, wall_y_force)
				wall_jumping()

func wall_jumping() -> void:
	is_wall_jumping = true
	await(get_tree().create_timer(0.12).timeout)
	is_wall_jumping = false

func dash() -> void:
	if dash_key_pressed == 1:
		is_dashing = true
	else:
		is_dashing = false
	
	if facing_right == true:
		velocity.x = dash_speed
		dash_started()
	if facing_right == false:
		velocity.x = -dash_speed
		dash_started()

func dash_started() -> void:
	if is_dashing == true:
		dash_key_pressed = 1
		await(get_tree().create_timer(0.15).timeout)
		is_dashing = false
		dash_key_pressed = 0
	else:
		return
