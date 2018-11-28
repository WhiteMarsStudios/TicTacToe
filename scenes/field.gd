extends Control

# 0 - server
# 1 - client
const SERVER = 0
const CLIENT = 1
const SERVER_IP = 0
const SERVER_PORT = 0
var peer_type = SERVER
var turn = true
var peer
	
	
	
func current_player():
	if (turn):
		turn = not turn
		return 1
	else:
		turn = not turn
		return 2
	

func _on_Button_pressed():
	peer = NetworkedMultiplayerENet.new()
	peer.create_server(1, 2)
	get_tree().set_network_peer(peer)


func _on_Button2_pressed():
	peer = NetworkedMultiplayerENet.new()
	peer.create_client(SERVER_IP, SERVER_PORT)
	get_tree().set_network_peer(peer)
