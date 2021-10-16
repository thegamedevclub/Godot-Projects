extends Skeleton2D
onready var LegR = $Hip/LegR
onready var ShinR = $Hip/LegR/ShinR
onready var FootR = $Hip/LegR/ShinR/FootR

onready var mesh = $MeshInstance2D

onready var LegL = $Hip/LegL
onready var ShinL = $Hip/LegL/ShinL
onready var FootL = $Hip/LegL/ShinL/FootL

onready var hip = $Hip
onready var head = $Hip/body/body2/neck/head

var max_offset = -16;  
var min_offset = -42; 

func _process(delta):
#	if Input.is_action_pressed("ui_up"):
#		if mesh.position.y > -42:
#			mesh.position.y -=2; 
#	elif Input.is_action_pressed("ui_down"):
#		if mesh.position.y < -16:
#			mesh.position.y+= 2; 
#
#	var offset_y = mesh.position.y; 
#
#	LegR.rotation_degrees = 0.9*(LegR.rotation +80+offset_y + offset_y); 
#	ShinR.rotation_degrees = 0.9*(ShinR.rotation -15-offset_y - offset_y); 
#	FootR.rotation_degrees = 0.9*(FootR.rotation -65 + offset_y/2); 
#
#	LegL.rotation_degrees = LegL.rotation +80+ offset_y+offset_y; 
#	ShinL.rotation_degrees = ShinL.rotation-15-offset_y-offset_y; 
#	FootL.rotation_degrees = FootL.rotation -65+ offset_y/2; 
#
#	hip.rotation_degrees = hip.rotation-offset_y/2
#	head.rotation_degrees = head.rotation +offset_y/2

	pass
