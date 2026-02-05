extends Node

var icons = {
	"ships":{
		"SHIP_TRTL":"k37",
		"SHIP_AT225":"k225",
		"SHIP_COTHON":"cothon",
		"SHIP_PROSPECTOR_BALD":"bald_eagle",
		"SHIP_PROSPECTOR":"prospector",
		"SHIP_EIME":"model_e",
		"SHIP_KITSUNE":"kitsune",
		"SHIP_OCP209":"ocp",
	},
	"icon":"icon",
	"empty":"empty",
	"ep":"enceladus_prime",
	"unknown":"unknown"
}

onready var activity = Discord.Activity.new()

var current_state = "Disconnected"
var current_details = "Waiting on game response..."
var current_large_icon = icons["unknown"]
var current_large_text = ""
var current_small_icon = icons["icon"]
var current_small_text = "ΔV: Rings of Saturn"

var start_timer = 0
var end_timer = 0



var fallback_icon = icons["empty"]
var unknown_icon = icons["unknown"]





func set_icon(ship,force_this_icon = false,do_update = false):
	var icon = ""
	if force_this_icon:
		icon = ship
	else:
		var list = icons["ships"]
		if ship in list:
			icon = list[ship]
		else:
			match ship.to_lower():
				"icon":
					icon = "icon"
				"empty":
					icon = "empty"
				"ep","enceladus","enceladus_prime":
					icon = "enceladus_prime"
				"unknown":
					icon = "unknown"
	current_large_icon = icon
	
	if do_update:
		emit_signal("update_activity")

func set_icon_text(text,do_update = false):
	current_large_text = text
	
	if do_update:
		emit_signal("update_activity")
	

func set_small_icon_text(text,do_update = false):
	current_small_text = text
	
	if do_update:
		emit_signal("update_activity")

func set_small_icon(how,do_update = false):
	var icon = "None"
	if how:
		icon = icons["icon"]
	current_small_icon = icon
	
	if do_update:
		emit_signal("update_activity")

func set_start_timer(time = OS.get_unix_time(),do_update = false):
	start_timer = time
	
	if do_update:
		emit_signal("update_activity")

func set_end_timer(time = 0,do_update = false):
	end_timer = time
	
	if do_update:
		emit_signal("update_activity")

func set_state(text,do_update = false):
	current_state = text
	
	if do_update:
		emit_signal("update_activity")

func set_details(text,do_update = false):
	current_details = text
	
	if do_update:
		emit_signal("update_activity")

func update_rpc():
	emit_signal("update_activity")

















signal update_activity()

func _ready():
	print(activity_status_str % ["started",self.name])
	connect("update_activity",self,"update_activity")
	emit_signal("update_activity")



var activity_status_str = "DV RPC: %s on %s"

func update_activity() -> void:
	activity.set_type(Discord.ActivityType.Playing)
	activity.set_state(current_state)
	activity.set_details(current_details)

	var assets = activity.get_assets()
	assets.set_large_image(current_large_icon)
	assets.set_large_text(current_large_text)
	assets.set_small_image(current_small_icon)
	assets.set_small_text(current_small_text)
	var timestamps = activity.get_timestamps()
	if start_timer > 0:
		timestamps.set_start(start_timer)
	if end_timer > 0:
		timestamps.set_end(end_timer)
	
	var result = yield(Discord.activity_manager.update_activity(activity), "result").result
	if result != Discord.Result.Ok:
	
		push_error(activity_status_str % [str(result),self.name])
	else:
		print(activity_status_str % [str(result),self.name])

