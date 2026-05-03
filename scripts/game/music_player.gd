extends AudioStreamPlayer

var _saved_position: float = 0.0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func stop_music() -> void:
	_saved_position = get_playback_position()
	stop()

func resume() -> void:
	play(_saved_position)

func play_music(stream: AudioStream) -> void:
	if self.stream == stream:
		return
	self.stream = stream
	play()

func set_volume(value: float) -> void:
	volume_db = linear_to_db(clamp(value, 0.0, 1.0))
	
