extends OmniLight

onready var spectrum = AudioServer.get_bus_effect_instance(0,0)

var flicker_speed = 0.1
var timer = 0.0
var e = 0.25
var increment = 0.0
export var high=0.4
export var low = 0.3

# Called when the node enters the scene tree for the first time.
func _ready():
	flicker_speed = rand_range(0.01,0.1)
	increment = (rand_range(high,low) - e)/flicker_speed 
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	timer = timer + delta
	var mag = spectrum.get_magnitude_for_frequency_range(100,120,1)
	print(mag)
	mag = 78 + linear2db(mag.length())
	print(mag)
	light_energy = mag
	print(light_energy)
	if light_energy < 0.0:
	#	light_energy = 0.0
		light_energy = e + increment
		if( timer > flicker_speed ):
			flicker_speed = rand_range(0.01,0.4)
			increment = (rand_range(high,low) - e)/flicker_speed
			timer = 0.0
