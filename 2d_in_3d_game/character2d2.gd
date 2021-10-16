extends KinematicBody

onready var timer = $Timer; 
onready var anim = $AnimationPlayer; 
onready var arm = $Armature; 
onready var atree = $AnimationTree; 
onready var state_machine = $AnimationTree.get("parameters/playback"); 

var speed = 10; 
var movement = Vector3(); 
var jump_power = 70; 
var falling_speed = -70; 
var gravity = 0.98; 

var play_mode = false; 


func _ready(): 
	timer.wait_time = 1; 
	timer.one_shot = true; 
	atree.active = true; 
	
	
func _process(delta):
	if play_mode == true:
		jump_power  = (0.3*sin(6.3*timer.time_left-1.6)+0.8)/2
		
		if movement.x < 0:
			arm.scale.x = 1
			anim.play("run"); 
		elif movement.x> 0:
			arm.scale.x = -1
			anim.play("run"); 
		else:
			anim.play("idle");
		
		var scale_par = jump_power;  
		
			
		if Input.is_action_just_pressed("ui_up") && Input.is_action_pressed("ui_down"):
			atree.active = false; 
			jump_power = 30; 
			movement.y = jump_power; 
			jump_power = 70; 
			
		elif Input.is_action_just_pressed("ui_up") && is_on_floor():
			atree.active = false; 
			state_machine.travel("run"); 
			movement.y = jump_power*100; 
			jump_power = 70; 
			
		elif Input.is_action_just_pressed("ui_down"): 
			
			if is_on_floor(): 
				timer.start(); 
				state_machine.travel("jump"); 
			else: 
				movement.y = falling_speed; 
				
		elif Input.is_action_pressed("ui_left") && is_on_floor() == true: 
			state_machine.travel("run"); 
			movement.x = speed; 
			
		elif Input.is_action_pressed("ui_right") && is_on_floor() == true:
			movement.x = -speed; 
			state_machine.travel("run"); 
			
		elif Input.is_action_just_pressed("ui_left") && is_on_floor() == false:
			movement.x =speed; 
		
		elif Input.is_action_just_pressed("ui_right") && is_on_floor() == false:
			movement.x =- speed; 
			
		else:
			
			if is_on_floor() == false: 
				movement.y -= gravity; 
			else: 
				movement.y = -0.01; 
			if is_on_floor() == true: 
				atree.active = true; 
				movement.x = 0; 
				state_machine.travel("idle"); 
			 
			
		
			
		move_and_slide(movement * delta *speed, Vector3.UP); 


func _on_Timer_timeout():
	atree.active = true;
