extends Spatial

var spectrum
var timer
var skel
var mouth_upper
var mouth_lower
var modifier
var mouth_distance = 0.0
var mouth_threshold = 0.18
export var mouth_speed = 0.1
export var mouth_limit = 0.18
export var sound_threshold = -70.0
var mouth_close = false

# Called when the node enters the scene tree for the first time.
func _ready():
	mouth_close = true
	spectrum = AudioServer.get_bus_effect_instance(0,0)
	timer = 0
	skel = get_node("Armature/Skeleton/")
	mouth_upper = skel.get_bone_pose(2)
	mouth_lower = skel.get_bone_pose(1)
	modifier = mouth_distance
	
func is_mic_volume_high( threshold ):
	var mag = spectrum.get_magnitude_for_frequency_range(80,140,1)
	mag = linear2db(mag.length())
	if mag < threshold:
		return false
	else:
		print(mag)
		return true

func move_mouth( mouth_distance ):
	mouth_upper = mouth_upper.rotated(Vector3(-1,0,0), mouth_distance)
	skel.set_bone_pose(2, mouth_upper)
	mouth_lower = mouth_lower.rotated(Vector3(1,0,0), mouth_distance)
	skel.set_bone_pose(1, mouth_lower)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer = timer + delta
	if is_mic_volume_high(sound_threshold):
		mouth_close = false
	else:
		mouth_close = true
	if mouth_close:
		if mouth_distance == 0.0:
			mouth_distance = mouth_threshold
			move_mouth(mouth_distance)
	else:
		if mouth_distance == mouth_threshold:
			mouth_distance = -mouth_threshold
			move_mouth(mouth_distance)
			mouth_distance = 0.0 
		


