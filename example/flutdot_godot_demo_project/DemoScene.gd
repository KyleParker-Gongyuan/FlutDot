"""extends Node

# The URL we will connect to.
export var websocket_url = "ws://localhost:1996"


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


	# Initiate connection to the given URL.
	var err = _client.connect_to_url(websocket_url)
	if err != OK:
		print("Unable to connect")
		set_process(false)



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
	_client.get_peer(1).put_packet("Test packet".to_utf8())
	send_data("sending shiii")
	


func _on_data():
	# Print the received packet, you MUST always use get_peer(1).get_packet
	# to receive data from server, and not get_packet directly when not
	# using the MultiplayerAPI.
	print("Got data from server: ", _client.get_peer(1).get_packet().get_string_from_utf8()) 
	#! _client.get_peer(1).get_packet().get_string_from_utf8() #? we want to export this info
	
	var v = get_node("Label")
	v.text = "we got data "+ str(cur)
	cur+= 1
	#? when this is called then the output == switchstatement (match in godot)
	#! we get a string then we have it goto a switch statment

func send_data(packet = ""):
	
	_client.get_peer(1).put_packet(str(packet).to_utf8())

func _process(_delta):
	# Call this in _process or _physics_process. Data transfer, and signals
	# emission will only happen when calling this function.
	_client.poll()


func _exit_tree():
	_client.disconnect_from_host()


#! we want to send a message to flutter as well

"""

"""
extends Spatial

var url = "ws://127.0.0.1:5000"
var ws = null # empty var for WebSocketClient
var myID = "null" # 
var Clients = {} # empty clients dict
#var othClient = preload("res://Player/otherPlayer.tscn") # load the other client scene
#onready var chat = $UI/Chat # link to chat
func _ready(): 
	#$UI/Menu.show() # show the name and color menu on ready
	print("start")
func _connect():
	ws = WebSocketClient.new() # Init WebSocket
	ws.connect("connection_established", self, "_connection_established") # connect Callbacks
	ws.connect("connection_closed", self, "_connection_closed") # connect Callbacks
	ws.connect("connection_error", self, "_connection_error") # Connect Callbacks
	ws.connect_to_url(url) # Do the connection 

func _connection_established(protocol): # Called on succesful connection to server
	## Just hides the connection related stuff and shows the other controls
	print("Connection established with protocol: ", protocol)
	ws.get_peer(1).put_packet(to_json({"command":"ping"}).to_utf8()) 
	#$UI/Menu.hide() 

func _connection_closed(m): # called on server closed
	## Shows connection related stuff, Hides the other stuff, Prints error to Label
	get_tree().reload_current_scene()
	print(m)

func _connection_error(): # called when client disconnects abruptly
	## Shows connection related stuff, Hides the other stuff, Prints error to Label
	#$UI/Menu/Label.text = "Disconnected from server"
	#$UI/Menu.show()
	pass

func _process(_delta): # Process is the main loop, delta is time time last frame in ms
	#print("wtf is with ws? : ",ws)
	#if ws == null: # why does this say its null???
		## ws has not been initialised
		## do nothing
	#	return
	#else:
		#if ws.get_connection_status() == ws.CONNECTION_CONNECTING || ws.get_connection_status() == ws.CONNECTION_CONNECTED:
			## if we are connecting or connected poll the server
		#	ws.poll()
		#if ws.get_peer(1).is_connected_to_host():
			## if we are connected check for messages
		#	if ws.get_peer(1).get_available_packet_count() > 0 :
				## if there are packets waiting get the next one
		#		var test = ws.get_peer(1).get_packet()
				#print('recieve %s' % test.get_string_from_ascii ())
				## put it through the parser
		#		parser(parse_json(test.get_string_from_ascii()))
	print("")

func sendPos(pos): ## sends the player posintion to the server
	#if ws == null:# or myID == null: # its ok for us not 2 have an id ## for it too be we either never connected or never got an ID
	#	print("0 ws...")
	#	return # die
	#if ws.get_peer(1).is_connected_to_host(): ## we are connected 
		
		## This is less complex than it looks
		ws.get_peer(1).put_packet(to_json({"command":"pos","val":pos}).to_utf8()) 
	#else:
	#	print("not connected")
	#	return
		
		

 ## sends chat message
#! we dont care
func sendChat(message): ## send a chat message to the server
	if ws == null or myID == null:
		return
	if ws.get_peer(1).is_connected_to_host():
		ws.get_peer(1).put_packet(to_json({"command":"chat","id":myID,"val":{"user":$UI/Menu/LineEdit.text,"message":message}}).to_utf8())
	else:
		return
		#print("not connected")
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

"""
func _on_Button_pressed():
	if $UI/Menu/LineEdit.text == "":
		$UI/Menu/Error.text = "You must enter a name"
		return
	else:
		_connect() 
	pass # Replace with function body.
"""


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

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass





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
	#if ws == null:# or myID == null: # its ok for us not 2 have an id ## for it too be we either never connected or never got an ID
	#	print("0 ws...")
	#	return # die
	#if ws.get_peer(1).is_connected_to_host(): ## we are connected 
		
		## This is less complex than it looks
		
		#_client.get_peer(1).put_packet(to_json({"command":"pos","val":pos}))
		
		
		#_client.get_peer(1).put_packet(to_json({"command":"ping", "val":"name"}).to_utf8())  #!WTF AINT THIS WORKING
		
		var message = "command:ping, val:name"
		var packet: PoolByteArray = JSON.print(message).to_utf8()
		print("Sending packet ", packet.get_string_from_utf8())
		
		
		_client.get_peer(1).put_packet(packet)
		
		#_client.get_peer(1).put_packet("just a string")

		
		
		
		
		
		var v = get_node("Label")
		v.text = str(pos)
	#else:
	#	print("not connected")
	#	return

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
			print("bitch pinged us")
			var v = get_node("Label")
			v.text = "s"
			# If health == 1, run this block of code
		_:
			print("dad")
		
			# If nothing matches, run this block of code




"""
#! making a better client
func _ready():
	# Connect base signals to get notified of connection open, close, and errors.
	_client.connect("connection_closed", self, "_closed")
	_client.connect("connection_error", self, "_closed")
	_client.connect("connection_established", self, "_connected")

	_client.connect("data_received", self, "_on_data")
	
	var err = _client.connect_to_url(websocket_url)
	if err != OK:
		print("Unable to connect")
		set_process(false)


func _process(delta):
	_client.poll()


func _connected(proto = ""):
	print("connected with protocol: ", proto)


func _closed(was_clean = false):
	print("closed, clean! ", was clean )


func _on_data():
	var payload = JSON.parse(_client.get_peer(1).get_packet().get_string_from_utf8()).result
	print("received data: " payload)


func sendData():
	_client.get_peer().put_packet(JSON.print({"test":"Test"}).to_utf8())
	
"""
	
