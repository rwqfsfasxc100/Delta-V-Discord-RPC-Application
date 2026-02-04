extends Node

func _ready():
	get_tree().get_root().set_transparent_background(true)
#	update_activity()




#
#var activity_status_str = "DV RPC: %s on %s"
#
#func update_activity() -> void:
#	print(activity_status_str % ["started",self.name])
#	var activity = Discord.Activity.new()
#	activity.set_type(Discord.ActivityType.Playing)
#	activity.set_state("Excavating ore")
#	activity.set_details("In the rings")
#
#	var assets = activity.get_assets()
#	assets.set_large_image("k37")
#	assets.set_large_text("The rings")
#	assets.set_small_image("icon")
#	assets.set_small_text("ΔV: Rings of Saturn")
#
#	var timestamps = activity.get_timestamps()
#	timestamps.set_start(OS.get_unix_time() + 0)
##	timestamps.set_end(OS.get_unix_time() + 500)
#
#	var result = yield(Discord.activity_manager.update_activity(activity), "result").result
#	if result != Discord.Result.Ok:
#
#		push_error(activity_status_str % [str(result),self.name])
#	else:
#		print(activity_status_str % [str(result),self.name])
#





func _input(event):
	if move and event is InputEventMouseMotion:
		var pos = OS.get_window_position()
		var m = pos + event.relative
		OS.set_window_position(m)

func exit():
	OS.kill(OS.get_process_id())

var move = false
func down():
	move = true

func up():
	move = false
