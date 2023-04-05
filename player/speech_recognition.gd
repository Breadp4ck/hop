extends Node

@export var spell_caster: SpellCaster
@export var spells = {
	"fire": Globals.SpellType.FIRE,
	"death": Globals.SpellType.WATER,
	"meat": Globals.SpellType.WIND,
}

var effect: AudioEffect
var record: AudioStreamWAV

var path: String

func _ready() -> void:
	
	path = get_directory()
	
	var microphone_idx: int = AudioServer.get_bus_index("Microphone")
	effect = AudioServer.get_bus_effect(microphone_idx, 0)

func _input(event):
	if event.is_action_pressed("microphone"):
		effect.set_recording_active(true)
	
	elif event.is_action_released("microphone"):
		if effect.is_recording_active() == false:
			return
		
		effect.set_recording_active(false)
		record = effect.get_recording()
		record.save_to_wav("./speech_recognition/kek.wav")
		
		OS.execute(path + "sox/sox", ["./speech_recognition/kek.wav", "-r", "16000", "-c", "1", "-b", "16", "-e", "signed-integer", "./speech_recognition/lol.wav"])
		
		var output = []
		OS.execute(path + "pocketsphinx/pocketsphinx", ["single", "./speech_recognition/lol.wav", "-hmm", "./speech_recognition/en-us/en-us", "-lm", "./speech_recognition/en-us/en-us.lm.bin", "-dict", "./speech_recognition/spells.dict"], output, true)
		var json = JSON.parse_string(output[0])
		print("Recognized: " + json.t)
		
		if spells.keys().has(json.t):
			spell_caster.choose(spells[json.t])

func get_directory() -> String:
	var platform_name = OS.get_name()
	
	match platform_name:
		"Windows", "UWP":
			return "./speech_recognition/windows/"
		"Linux":
			return "./speech_recognition/linux/"
		_:
			return "XYZ"
