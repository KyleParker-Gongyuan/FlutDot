extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#onready var player = get_tree().get_root().find_node("Spatial",true,false)
# The URL we will connect to.
export var websocket_url = "ws://localhost:5000"


# Our WebSocketClient instance.
var _client = WebSocketClient.new()
var cur = 0

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _input(event):
	if event is InputEventMouseButton:
		position = event.position
		#var ref_a = get_tree().current_scene.get_node("Spatial")
		
		#send_data("poglux")
		print("curPos==:",event.position)
		
		get_parent().sendPos({"x":position.x,"y":position.y})
		print(event.position)
	pass





func _ready():
	# Connect base signals to get notified of connection open, close, and errors.
	"""
	_client.connect("connection_closed", self, "_closed")
	_client.connect("connection_error", self, "_closed")
	_client.connect("connection_established", self, "_connected")

	# This signal is emitted when not using the Multiplayer API every time
	# a full packet is received.
	# Alternatively, you could check get_peer(1).get_available_packets() in a loop.
	_client.connect("data_received", self, "_on_data")
	#_client.connect()


	# Initiate connection to the given URL.
	var err = _client.connect_to_url(websocket_url)
	if err != OK:
		print("Unable to connect")
		set_process(false)
		"""
	pass



func _closed(was_clean = false):
	# was_clean will tell you if the disconnection was correctly notified
	# by the remote peer before closing the socket.
	print("Closed, clean: ", was_clean)
	set_process(false)


func _connected(proto = ""):
	# This is called on connection, "proto" will be the selected WebSocket
	# sub-protocol (which is optional)
	print("Connected with protocol: ", proto)
	# You MUST always use get_peer(1).put_packet to send data to server,
	# and not put_packet directly when not using the MultiplayerAPI.
	#_client.get_peer(1).put_packet("Test packet".to_utf8())
	_client.get_peer(1).put_packet(to_json({"command":"ping", "val":"name"}).to_utf8()) 
	#send_data("sending shiii")
	

func send_data(packet = ""):
	
	_client.get_peer(1).put_packet(str(packet).to_utf8())

func _process(_delta):
	# Call this in _process or _physics_process. Data transfer, and signals
	# emission will only happen when calling this function.
	_client.poll()

