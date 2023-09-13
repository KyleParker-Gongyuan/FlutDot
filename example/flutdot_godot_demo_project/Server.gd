extends Node

const PORT = 8080

var server
var clients = []

func _ready():
	server = NetworkedMultiplayerENet.new()
	server.create_server(PORT, clients.max_size())
	server.connect("connected", self, "_on_client_connected")
	server.connect("network_peer_disconnected", self, "_on_client_disconnected")
	server.connect("network_peer_packet", self, "_on_client_packet")

func _on_client_connected():
	print("Client connected: ")
	

func _on_client_disconnected():
	print("Client disconnected: ")
	

func _on_client_packet(id, data):
	# Handle incoming data from the client
	# Implement WebSocket handshake and message handling here
	# This is where you would parse and process WebSocket frames
	pass

func _process(delta):
	# Implement WebSocket server logic here
	pass
