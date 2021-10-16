extends KinematicBody

onready var timer = $Timer; 

var speed = 10; 
var movement = Vector3(); 
var jump_power = 70; 
var falling_speed = -70; 
var gravity = 0.98; 

var Vector_UP = Vector2(0,-1); 

#0.1*sin(6.3 x-1.6)+0.8

func _ready(): 
	timer.wait_time = 1; 
	timer.one_shot = true; 
	
	
func _process(delta):
	jump_power  = 0.1*sin(6.3*timer.time_left-1.6)+0.8
	#print("jump_power__" + str(jump_power)); 
	
	var scale_par = jump_power;  
	scale.y =  1.7 - scale_par; 
		
	if Input.is_action_just_pressed("ui_up") && Input.is_action_pressed("ui_down"):
		jump_power = 30; 
		movement.y = jump_power; 
		jump_power = 70; 
		
	elif Input.is_action_just_pressed("ui_up") && is_on_floor():
		#print("jump_power--" + str(jump_power))
		movement.y = jump_power*100; 
		jump_power = 70; 
		
	elif Input.is_action_just_pressed("ui_down"): 
		if is_on_floor(): 
			timer.start(); 
		else: 
			movement.y = falling_speed; 
	
		
	else:
		
		if is_on_floor() == false: 
			movement.y -= gravity; 
		else: 
			movement.y = -0.01; 
		
	
		
	move_and_slide(movement * delta *speed, Vector_UP); 


func _on_Timer_timeout():
	pass
