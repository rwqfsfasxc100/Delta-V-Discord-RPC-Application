extends Node

const DEFAULT_IP = "127.0.0.1"
const DEFAULT_PORT = 28041
const MAX_CONNECTIONS = 128

var current_sensors = {}
var current_visuals = {}


func _ready():
	
	create_server()
	get_tree().connect("network_peer_disconnected",self,"_disconnected")

func _disconnected():
	ActivityController.set_icon("unknown")
	ActivityController.set_state("Disconnected")
	ActivityController.set_details("Waiting on game response...")
	ActivityController.update_rpc()
	

func create_server():
	
	var peer = NetworkedMultiplayerENet.new()
	peer.set_bind_ip(DEFAULT_IP)
	yield(get_tree(),"idle_frame")
	peer.create_server(DEFAULT_PORT,MAX_CONNECTIONS)
	get_tree().set_network_peer(peer)

remote func set_icon(ship,do_update = false):
	ActivityController.set_icon(ship,do_update)

remote func set_icon_text(text,do_update = false):
	ActivityController.set_icon_text(text,do_update)

remote func set_small_icon_text(text,do_update = false):
	ActivityController.set_small_icon_text(text,do_update)

remote func set_small_icon(how,do_update = false):
	ActivityController.set_small_icon(how,do_update)

remote func set_start_timer(time = OS.get_unix_time(),do_update = false):
	ActivityController.set_start_timer(time,do_update)

remote func set_end_timer(time = 0,do_update = false):
	ActivityController.set_end_timer(time,do_update)

remote func set_state(text,do_update = false):
	ActivityController.set_state(text,do_update)

remote func set_details(text,do_update = false):
	ActivityController.set_details(text,do_update)

remote func update_rpc():
	ActivityController.update_rpc()
