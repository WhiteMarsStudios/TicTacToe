extends Control

# 0 - server
# 1 - client
const SERVER = 0
const CLIENT = 1
var server_ip = null
var my_ip = null
const SERVER_PORT = 22
var peer_type = SERVER
var turn = true
var peer

func _ready():
	self.my_ip = IP.get_local_addresses()[1]
	print(self.my_ip)
	
	$my_ip_info.text = str(self.my_ip)
	
func current_player():
	if (turn):
		turn = not turn
		return 1
	else:
		turn = not turn
		return 2
	

func _on_Button_pressed():
	self.peer_type = SERVER
	peer = NetworkedMultiplayerENet.new()
	peer.create_server(22, 2)
	get_tree().set_network_peer(peer)


func _on_Button2_pressed():
	self.peer_type = CLIENT
	self.server_ip = $server_ip_input.text
	print(self.server_ip)
	#peer = NetworkedMultiplayerENet.new()
	#peer.create_client(server_ip, SERVER_PORT)
	#get_tree().set_network_peer(peer)
