extends CanvasLayer

const HEART_ROW_SIZE: int = 8
const HEART_OFFSET: int = 16

@onready var heart: Sprite2D = $Heart
@onready var soul_bar: Sprite2D = $SoulBar

func _ready() -> void:
	for i in Globals.health:
		var new_heart = Sprite2D.new()
		new_heart.texture = heart.texture
		new_heart.hframes = heart.hframes
		heart.add_child(new_heart)

func _process(delta: float) -> void:
	soul_regeneration()
	
	for heart_amount in heart.get_children():
		var index = heart_amount.get_index()
		var x = (index % HEART_ROW_SIZE) * HEART_OFFSET
		var y = (index / HEART_ROW_SIZE) * HEART_OFFSET
		heart_amount.position = Vector2(x,y)
		
		var last_heart = floor(Globals.health)
		if index > last_heart:
			heart_amount.frame = 0
		if index == last_heart:
			heart_amount.frame = (Globals.health - last_heart) * 4
		if index < last_heart:
			heart_amount.frame = 4

func soul_regeneration() -> void:
	if Globals.soul == 1.0:
		soul_bar.frame = 0
	if Globals.soul == 0.75:
		soul_bar.frame = 1
	if Globals.soul == 0.50:
		soul_bar.frame = 2
	if Globals.soul == 0.25:
		soul_bar.frame = 3
	if Globals.soul == 0.0:
		soul_bar.frame = 4
