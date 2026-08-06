extends TextureRect

@export var bullet_count := 20

var bullet_textures := [
	preload("res://pictures/1bullet.webp"),
	preload("res://pictures/2.webp"),
	preload("res://pictures/3.webp"),
	preload("res://pictures/4.webp"),
	preload("res://pictures/5.webp"),
	preload("res://pictures/6.webp"),
	preload("res://pictures/7.webp"),
	preload("res://pictures/8.webp"),
	preload("res://pictures/9.webp"),
	preload("res://pictures/10.webp"),
	preload("res://pictures/11.webp"),
	preload("res://pictures/12.webp"),
	preload("res://pictures/13.webp"),
	preload("res://pictures/14.webp"),
	preload("res://pictures/15.webp"),
	preload("res://pictures/16.webp"),
	preload("res://pictures/17.webp"),
	preload("res://pictures/18 (2).webp"),
	preload("res://pictures/18.webp"),
	preload("res://pictures/18bullet.webp"),
	preload("res://pictures/19.webp"),
	preload("res://pictures/20.webp")
]

func _ready():
	update_bullet_display()

func update_bullet_display():
	bullet_count = clamp(bullet_count, 1, bullet_textures.size())
	texture = bullet_textures[bullet_count - 1]
