tool
extends Spatial

#set get function (export var) -> anim_player and Skeleton can be selected in Editor 
export(NodePath) var control_skeleton:NodePath setget set_control_skeleton


export(bool) var enabled:bool = true

#define skeleton and set to null by default 
var skeleton:Skeleton = null


var first_call:bool = true
var bone_control_nodes:Array = []

#---------------------------------------------------------------------------------------------------

#setget function and use parameter "path" selected in Editor as control_skeleton
func set_control_skeleton( path:NodePath ):
	control_skeleton = path

	if self.first_call:
		return
	
	#check if selected Node (by user in Editor) is of class Skeleton
	var node:Node = self.get_node( control_skeleton )
	if node is Skeleton:
		#if true assign node to var skeleton
		self.skeleton = node
	else:
		#if not display error
		self.skeleton = null
		push_error( str(path) + " does not Skeleton!" )

	self._generate_bone_handles( )
	
#---------------------------------------------------------------------------------------------------



func _generate_bone_handles( ):
	#first remove all existing children
	for child in self.get_children( ):
		self.remove_child( child )

	#return if skeleton isnt valid 
	if self.skeleton == null:
		return
	
	#set array of bone_handle_nodes to empty array
	self.bone_control_nodes = []
	var bone_control: = preload( "BoneControl.tscn" )
	#loop through skeleton and set (var) bone_name to "bone name" and create BoneControl
	for bone_id in range( self.skeleton.get_bone_count( ) ):
		var bone_name:String = self.skeleton.get_bone_name( bone_id )
		var bone_control_node:BoneControl = bone_control.instance( ) 
		
		#assign bone specific data to instance's vars
		bone_control_node.bone_editor = self
		bone_control_node.name = bone_name
		bone_control_node.skeleton = self.skeleton
		bone_control_node.bone_id = bone_id
		bone_control_node.bone_name = bone_name


		#get parent of specific bone (by bone_id) 
		var parent_bone_id:int = self.skeleton.get_bone_parent( bone_id )
		#check if bone has a parent
		if parent_bone_id == -1:
			#->bone does not have a parent -> just add the Instance under Editor node 
			self.add_child( bone_control_node )
		else:
			#->bone has got a parent -> find parent bone in array (ordered by id and looped by id
			# -> so parent bone has already been added to array) and add as its child 
			self.bone_control_nodes[parent_bone_id].add_child( bone_control_node )

		#add Instances to the scene not just in running scene but also in Editor 
		if Engine.editor_hint == true:
			var tree:SceneTree = self.get_tree( )
			if tree != null:
				if tree.edited_scene_root != null:
					bone_control_node.set_owner( tree.edited_scene_root )

		#add ControlBone Instance to Array of ControlBone Instances 
		self.bone_control_nodes.append( bone_control_node )
		
#---------------------------------------------------------------------------------------------------

func _process( delta:float ):
	#just set skeleton and AnimPlayer once at _ready()
	if self.first_call:
		self.first_call = false
		self.set_control_skeleton( self.control_skeleton )
	
	#loop through Array of ControlBones and set them to "enabled = true"
	for control_bone in self.bone_control_nodes:
		control_bone.enabled = self.enabled
		
