extends Spatial

onready var skeleton = $Armature/Skeleton; 
onready var timer = $Timer; 
onready var mesh = $MeshInstance; 
onready var anim = $AnimationPlayer; 

var bone 
var body1
var body2
var thighL
var thighR
var shinL
var shinR
var footL
var footR

var jump_power; 


func _ready():
	bone = skeleton.find_bone("bone");
	thighL= skeleton.find_bone("thigh_l"); 
	thighR = skeleton.find_bone("t_high_r"); 
	shinL= skeleton.find_bone("s_hin_l"); 
	shinR = skeleton.find_bone("shin_r"); 
	footL = skeleton.find_bone("f_oot_l"); 
	footR = skeleton.find_bone("foot_r"); 
	
	timer.start(); 
	

func _process(delta):

		if Input.is_action_pressed("ui_down"): 
			timer.start(); 
			anim.play("jump")
			
		jump_power  = 0.1*sin(6.3*timer.time_left-1.6)+0.8
		
		var jump_offset = (mesh.translation.y + jump_power - 0.8) * 50 * delta ; 
		
		mesh.translation.y = jump_offset; 
		

















