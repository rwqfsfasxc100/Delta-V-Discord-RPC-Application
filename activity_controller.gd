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


var changed = false


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
	if icon != current_large_icon:
		print("Changing large icon text from %s to %s" % [current_large_text,icon])
		current_large_icon = icon
		changed = true
		if do_update:
			emit_signal("update_activity")

func set_icon_text(text,do_update = false):
	if text != current_large_text:
		print("Changing large icon from %s to %s" % [current_large_icon,text])
		current_large_text = text
		changed = true
		if do_update:
			emit_signal("update_activity")
	

func set_small_icon_text(text,do_update = false):
	if text != current_small_text:
		print("Changing small icon text from %s to %s" % [current_small_text,text])
		current_small_text = text
		changed = true
		if do_update:
			emit_signal("update_activity")

func set_small_icon(how,force_this_icon = false,do_update = false):
	var icon = "None"
	if force_this_icon:
		icon = how
	else:
		if how:
			icon = icons["icon"]
	if icon != current_small_icon:
		print("Changing small icon from %s to %s" % [current_small_icon,icon])
		current_small_icon = icon
		changed = true
		if do_update:
			emit_signal("update_activity")

func set_start_timer(time = OS.get_unix_time(),do_update = false):
	if time != start_timer:
		print("Changing start time from %s to %s" % [str(end_timer),str(time)])
		start_timer = time
		changed = true
		if do_update:
			emit_signal("update_activity")

func set_end_timer(time = 0,do_update = false):
	if time != end_timer:
		print("Changing end time from %s to %s" % [str(end_timer),str(time)])
		end_timer = time
		changed = true
		if do_update:
			emit_signal("update_activity")

func set_state(text,do_update = false):
	if text != current_state:
		print("Changing state from %s to %s" % [current_state,text])
		current_state = text
		changed = true
		if do_update:
			emit_signal("update_activity")

func set_details(text,do_update = false):
	if text != current_details:
		print("Changing details from %s to %s" % [current_details,text])
		current_details = text
		changed = true
		if do_update:
			emit_signal("update_activity")

func update_rpc():
	if changed:
		print("Updating RPC due to unsent changes")
		emit_signal("update_activity")
		changed = false
		

















signal update_activity()

func _ready():
	print(activity_status_str % ["started",self.name])
	connect("update_activity",self,"update_activity")
	emit_signal("update_activity")



var activity_status_str = "DV RPC: %s on %s"

func update_activity() -> void:
	var st = current_state
	var dt = current_details
	if st == dt:
		st = ""
	activity.set_type(Discord.ActivityType.Playing)
	activity.set_state(st)
	activity.set_details(dt)

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

