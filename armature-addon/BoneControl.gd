tool
extends Spatial

class_name BoneControl

var bone_editor
var skeleton:Skeleton = null
var bone_id:int = -1
var bone_name:String = ""
var original_rest:Transform
var enabled:bool = true


var pose:Transform

func _ready( ):
	if self.skeleton == null or self.bone_id == -1:
		return
		
	self.original_rest = self.skeleton.get_bone_rest( self.bone_id )
	self.transform = original_rest; 
	

func _process( delta:float ):
	if self.enabled:
		if skeleton:
			self.skeleton.set_bone_rest( self.bone_id, transform)


