extends KinematicBody2D

func _ready():
	
	pass


func _input(event):
	if event is InputEventMouseButton:
		position = event.position
		#var ref_a = get_tree().current_scene.get_node("Spatial")
		
		#send_data("poglux")
		print("curPos==:",event.position)
		
		get_parent().sendPos({"x":position.x,"y":position.y})
		print(event.position)
	pass



