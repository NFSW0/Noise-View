extends Control

var noise: FastNoiseLite = null
var noise_texture: Texture2D = null
var noise_sprite:Sprite2D = null
var noise_image: Image = null

var sprite_width: int = 500
var sprite_height: int = 500

@onready var cellular_distance_function = %CellularDistanceFunction
@onready var cellular_jitter = %CellularJitter
@onready var cellular_return_type = %CellularReturnType
@onready var domain_warp_enabled = %DomainWarpEnabled
@onready var domain_warp_type = %DomainWarpType
@onready var domain_warp_frequency = %DomainWarpFrequency
@onready var domain_warp_amplitude = %DomainWarpAmplitude
@onready var domain_warp_fractal_type = %DomainWarpFractalType
@onready var domain_warp_fractal_gain = %DomainWarpFractalGain
@onready var domain_warp_fractal_lacunarity = %DomainWarpFractalLacunarity
@onready var domain_warp_fractal_octaves = %DomainWarpFractalOctaves
@onready var fractal_type = %FractalType
@onready var fractal_octaves = %FractalOctaves
@onready var fractal_lacunarity = %FractalLacunarity
@onready var fractal_gain = %FractalGain
@onready var fractal_ping_pong_strength = %FractalPingPongStrength
@onready var fractal_weighted_strength = %FractalWeightedStrength
@onready var noise_type = %NoiseType
@onready var frequency = %Frequency
@onready var offset_x = %OffsetX
@onready var offset_y = %OffsetY
@onready var offset_z = %OffsetZ
@onready var my_seed = %Seed

func save_image():
	var save_dialog = FileDialog.new()
	save_dialog.access = 2
	save_dialog.use_native_dialog = true
	save_dialog.set_filters(PackedStringArray(["*.png ; PNG Images"]))
	save_dialog.connect("file_selected",func(path):
		noise_image.save_png(path)
		)
	add_child(save_dialog)
	save_dialog.popup_centered()

func save_noise():
	var save_dialog = FileDialog.new()
	save_dialog.access = 2
	save_dialog.use_native_dialog = true
	save_dialog.set_filters(PackedStringArray(["*.tres ; Resource Files"]))
	save_dialog.connect("file_selected",func(path):
		ResourceSaver.save(noise, path)
		)
	add_child(save_dialog)
	save_dialog.popup_centered()

func _ready():
	noise = FastNoiseLite.new()
	noise_sprite = Sprite2D.new()
	_update_noise()
	noise_texture = ImageTexture.create_from_image(noise_image)
	noise_sprite.texture = noise_texture
	noise_sprite.position = Vector2(sprite_width / 2.0, sprite_height / 2.0)
	add_child(noise_sprite)
	move_child(noise_sprite, 0)
	cellular_distance_function.connect("item_selected", _update_noise)
	cellular_jitter.connect("value_changed", _update_noise)
	cellular_return_type.connect("item_selected", _update_noise)
	domain_warp_enabled.connect("toggled", _update_noise)
	domain_warp_type.connect("item_selected", _update_noise)
	domain_warp_frequency.connect("value_changed", _update_noise)
	domain_warp_amplitude.connect("value_changed", _update_noise)
	domain_warp_fractal_type.connect("item_selected", _update_noise)
	domain_warp_fractal_gain.connect("value_changed", _update_noise)
	domain_warp_fractal_lacunarity.connect("value_changed", _update_noise)
	domain_warp_fractal_octaves.connect("value_changed", _update_noise)
	fractal_type.connect("item_selected", _update_noise)
	fractal_octaves.connect("value_changed", _update_noise)
	fractal_lacunarity.connect("value_changed", _update_noise)
	fractal_gain.connect("value_changed", _update_noise)
	fractal_ping_pong_strength.connect("value_changed", _update_noise)
	fractal_weighted_strength.connect("value_changed", _update_noise)
	noise_type.connect("item_selected", _update_noise)
	frequency.connect("value_changed", _update_noise)
	offset_x.connect("value_changed", _update_noise)
	offset_y.connect("value_changed", _update_noise)
	offset_z.connect("value_changed", _update_noise)
	my_seed.connect("value_changed", _update_noise)

func _update_noise(_data = null):
	noise.set_cellular_distance_function(cellular_distance_function.get_selected_id())
	noise.set_cellular_jitter(cellular_jitter.value)
	noise.set_cellular_return_type(cellular_return_type.get_selected_id())
	noise.set_domain_warp_enabled(domain_warp_enabled.is_pressed())
	noise.set_domain_warp_type(domain_warp_type.get_selected_id())
	noise.set_domain_warp_frequency(domain_warp_frequency.value)
	noise.set_domain_warp_amplitude(domain_warp_amplitude.value)
	noise.set_domain_warp_fractal_type(domain_warp_fractal_type.get_selected_id())
	noise.set_domain_warp_fractal_gain(domain_warp_fractal_gain.value)
	noise.set_domain_warp_fractal_lacunarity(domain_warp_fractal_lacunarity.value)
	noise.set_domain_warp_fractal_octaves(domain_warp_fractal_octaves.value)
	noise.set_fractal_type(fractal_type.get_selected_id())
	noise.set_fractal_octaves(fractal_octaves.value)
	noise.set_fractal_lacunarity(fractal_lacunarity.value)
	noise.set_fractal_gain(fractal_gain.value)
	noise.set_fractal_ping_pong_strength(fractal_ping_pong_strength.value)
	noise.set_fractal_weighted_strength(fractal_weighted_strength.value)
	noise.set_noise_type(noise_type.get_selected_id())
	noise.set_frequency(frequency.value)
	noise.set_offset(Vector3(offset_x.value, offset_y.value, offset_z.value))
	noise.set_seed(my_seed.value)
	noise_image = _generate_noise_image()
	noise_texture = ImageTexture.create_from_image(noise_image)
	noise_sprite.texture = noise_texture

func _generate_noise_image() -> Image:
	var image = Image.create(sprite_width, sprite_height, false, Image.FORMAT_RGBA8)
	for y in range(sprite_height):
		for x in range(sprite_width):
			var noise_value = noise.get_noise_3d(x, y, 0)
			var color = Color(noise_value, noise_value, noise_value)
			image.set_pixel(x, y, color)
	return image

func _on_save_image_pressed():
	save_image()

func _on_save_noise_pressed():
	save_noise()
