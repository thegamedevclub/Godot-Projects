extends Node
onready var cam2d = $"Control/HBoxContainer/ViewportContainer2/Viewport2/character2d2/2d_camera3"
onready var cam3d = $"Control/HBoxContainer/ViewportContainer/Viewport/3d_camera"
onready var floor1 = $floor
onready var floor2 = $floor2
onready var character = $"Control/HBoxContainer/ViewportContainer2/Viewport2/character2d2"
onready var projection = $projection

#projection elements
onready var object1_proj = $obstacles/obstacle_1/obstacle1/proj/obstacle1
onready var object2_proj = $obstacles/obstacle_2/obstacle2/proj/obstacle2
onready var object3_proj = $obstacles/obstacle_3/obstacle3/proj/obstacle3
onready var object4_proj = $obstacles/obstacle_4/obstacle4/proj/obstacle4
onready var object5_proj = $obstacles/obstacle_5/obstacle5/proj/obstacle5
onready var object6_proj = $obstacles/obstacle_6/obstacle6/proj/obstacle6
onready var object7_proj = $obstacles/obstacle_7/obstacle7/proj/obstacle7

#real elements
onready var object1 = $obstacles/obstacle_1/obstacle1/Cylinder
onready var object2 = $obstacles/obstacle_2/obstacle2/Cylinder001
onready var object3 = $obstacles/obstacle_3/obstacle3/Cube
onready var object4 = $obstacles/obstacle_4/obstacle4/Cylinder002
onready var object5 = $obstacles/obstacle_5/obstacle5/Cube001
onready var object6 = $obstacles/obstacle_6/obstacle6/Cube002
onready var object7 = $obstacles/obstacle_7/obstacle7/Cylinder003

onready var area = $collision_detection
onready var button = $Control/Button; 

var new_parent = self; 
var obstacles 
var obstacles_size 
var arr = []; 



var place_mode = true; 

func _ready():
	obstacles = get_node("obstacles").get_children()
	obstacles.erase(obstacles[7])
	
	
func _process(delta):
	
	if place_mode == false:
		object1_proj.set_layer_mask(1); 
		object2_proj.set_layer_mask(1); 
		object3_proj.set_layer_mask(1);
		object4_proj.set_layer_mask(1);
		object5_proj.set_layer_mask(1);
		object6_proj.set_layer_mask(1);
		object7_proj.set_layer_mask(1);
		
		object1.visible = false
		object2.visible =false
		object3.visible = false
		object4.visible = false
		object5.visible = false
		object6.visible =false
		object7.visible = false
	
	cam3d.translation.x = character.translation.x + 1
	
	if Input.is_action_just_pressed("ui_space"):
		place_mode = false
		character.play_mode = true; 
		button.visible = false; 

	if place_mode == true: 
		var obstacles_size = obstacles.size()
		for i in range(0,obstacles_size):
			if Input.is_action_pressed("ui_left"):
				obstacles[i].translation.x +=3 * delta; 
			elif Input.is_action_pressed("ui_right"):
				obstacles[i].translation.x -= 3 *delta; 
			elif Input.is_action_pressed("W"):
				obstacles[i].translation.y += 3 * delta; 
			elif Input.is_action_pressed("S"):
				obstacles[i].translation.y -= 3 * delta; 
			elif Input.is_action_pressed("ui_down"):
				obstacles[i].translation.z += 3 * delta; 
			elif Input.is_action_pressed("ui_up"):
				obstacles[i].translation.z -= 3 * delta; 


func _on_collision_detection_body_entered(body):
	if body.is_in_group("obstacle"):
		var parent = body.get_parent(); 
		var node = get_node("obstacles/" +str(parent.name)+ "/"+ str(body.name) + "/proj")
		if node != null:
			node.visible = true; 
		arr = [body]; 


func _on_collision_detection_body_exited(body):
	if body.is_in_group("obstacle"): 
		var parent = body.get_parent(); 
		var out = get_node("obstacles/" +str(parent.name)+ "/"+ str(body.name) + "/proj")
		if out != null:
			out.visible = false; 
		arr = []; 


func _on_Button_button_down():
	var node = arr[0].get_parent(); 
	obstacles.erase(node)
	

