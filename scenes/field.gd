extends Control

const DEFAULT_SERVER_IP = "127.0.0.1"
const SERVER_PORT = 3000

var my_id = -1
var turn = false
var second_player_id

sync func current_player():
	if (turn):
		turn = not turn
		return 1
	else:
		turn = not turn
		return 2

func _ready():
	var my_ip = IP.get_local_addresses()[0]
	$my_ip_info.text = str(my_ip)
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
	
func _player_connected(id):
	second_player_id = id
	print("Player connected: " + str(id))

func _player_disconnected(id):
	print("Played disconected: " + str(id))
	
func _connected_ok():
	# Only called on clients, not server. Send my ID and info to all the others peers
	my_id = get_tree().get_network_unique_id()
	rpc("register_player", my_id, "Hi from " + str(my_id) + "!")
	print("Connection success")
	
func _server_disconnected():
	print("Server disconected")

func _connected_fail():
	print("Connection fail")

	
# 	SERVER BUTTON
func _on_Button_pressed():
	var server = NetworkedMultiplayerENet.new()
	server.set_compression_mode(NetworkedMultiplayerENet.COMPRESS_RANGE_CODER)
	if server.create_server(SERVER_PORT, 2) != OK:
		print("Can't create server")
		return
		
	get_tree().set_network_peer(server)
	print("Server is created")

# 	CLIENT BUTTON
func _on_Button2_pressed():
	var client = NetworkedMultiplayerENet.new()
	client.set_compression_mode(NetworkedMultiplayerENet.COMPRESS_RANGE_CODER)
	client.create_client(DEFAULT_SERVER_IP, SERVER_PORT)
	get_tree().set_network_peer(client)
	print("Client is created")
	
remote func register_player(id, info):
	print(info)


func _on_shared_btn_pressed():
	if get_tree().is_network_server():
		rpc_id(second_player_id, "btn_is_pressed_on_server")
	else:
		rpc_id(1, "btn_is_pressed_on_client")
	
remote func btn_is_pressed_on_server():
	$shared_btn.pressed = not $shared_btn.pressed
	
remote func btn_is_pressed_on_client():
	$shared_btn.pressed = not $shared_btn.pressed