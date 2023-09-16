extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#onready var player = get_tree().get_root().find_node("Spatial",true,false)
# The URL we will connect to.
export var websocket_url = "ws://127.0.0.1:5000"


# Our WebSocketClient instance.
var _client = WebSocketClient.new()
var cur = 0

func _ready():
	# Connect base signals to get notified of connection open, close, and errors.
	_client.connect("connection_closed", self, "_closed")
	_client.connect("connection_error", self, "_closed")
	_client.connect("connection_established", self, "_connected")

	# This signal is emitted when not using the Multiplayer API every time
	# a full packet is received.
	# Alternatively, you could check get_peer(1).get_available_packets() in a loop.
	_client.connect("data_received", self, "_on_data")
	#_client.connect()
	var v = get_node("Label")
	v.text = "started server"
	
	


	# Initiate connection to the given URL.
	var err = _client.connect_to_url(websocket_url)
	if err != OK:
		print("Unable to connect")
		set_process(false)

func _on_data():
	# Print the received packet, you MUST always use get_peer(1).get_packet
	# to receive data from server, and not get_packet directly when not
	# using the MultiplayerAPI.
	var v = get_node("Label")
	v.text = "getting data"
	var z = _client.get_peer(1).get_packet().get_string_from_utf8()
	
	print("Got data from server: ", str(z)) 
	#! _client.get_peer(1).get_packet().get_string_from_utf8() #? we want to export this info
	
	
	v.text = "we fr got the data "+ str(z)
	cur+= 1
	#? when this is called then the output == switchstatement (match in godot)
	#! we get a string then we have it goto a switch statment

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


func sendPos(pos): ## sends the player posintion to the server
	
	var message = '{"command":"ping", "val":"name"}'
	var packet: PoolByteArray = JSON.print(message).to_utf8()
	print("Sending packet ", packet.get_string_from_utf8())

	
	_client.get_peer(1).put_packet(packet)
	
	var v = get_node("Label")
	v.text = str(pos)

"""

func parser(packet): # parses JSON received from server
	# check packet is actually JSON
	if typeof(packet) != 18:
		# exit if not
		print("Wrong data type")
		return
	# get ping reply
	if packet.command == "ping": ## The server wants to check we are alive
		if ws == null:# or myID == null:
			return
		if ws.get_peer(1).is_connected_to_host():
			ws.get_peer(1).put_packet(to_json({"command":"pong","id":myID}).to_utf8())
		else:
			return
	if packet.command == "pong": ## the server replied when we checked it was alive
		# we just get the timestamp we send back, so just sub that from the current time
		var diff = (OS.get_unix_time() - int(packet.val))
		print("Ping took "+str(diff)+" secs")
	# get own ID
	elif packet.command == "getID": # we got our intial ID from the server
		print("GOT ID "+packet.val)
		myID = packet.val 
		Clients[myID] = {}
		var col = $UI/Menu/ColorPicker.getColour()
		$Room/Player.setMod({"r":col.r,"g":col.g,"b":col.b})
		if ws == null or myID == null:
			return
		if ws.get_peer(1).is_connected_to_host():
			ws.get_peer(1).put_packet(to_json({"command":"reg","id":myID,"user":$UI/Menu/LineEdit.text,"col":{"r":col.r,"g":col.g,"b":col.b}}).to_utf8())
		else:
			return 
	# get chat 
	elif packet.command == "chat": 
		$UI/Chat.doChat(packet.val)
	# get the clients list from server (and everything else)

"""
func parserv2(packet):
	var packettype: String = packet.command
	match packettype:
		"ping":
			print("server pinged us")
			var v = get_node("Label")
			v.text = "s"
			# If health == 1, run this block of code
		_:
			print("dad")
		
			# If nothing matches, run this block of code
