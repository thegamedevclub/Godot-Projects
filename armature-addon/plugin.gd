tool
extends EditorPlugin

#preload BoneDock (visual) 
#const BoneDock = preload( "BoneDock.tscn" )
#
#var bone_dock_instance
var bone_editor

#_enter_tree() build-in method -> if node is used as child 
func _enter_tree( ):
	#create new BoneDock Instance and add to Editor 
#	self.bone_dock_instance = BoneDock.instance( )
#	self.add_control_to_container( CONTAINER_SPATIAL_EDITOR_MENU, self.bone_dock_instance )
	self.add_custom_type( "ArmatureEditor", "Spatial", preload("ArmatureEditor.gd"), preload("icon.png") )

#_exit_tree() build-in method -> if node is not used as child 
func _exit_tree( ):
	#remove BoneDock Node to clean Editor 
	self.remove_custom_type( "ArmatureEditor" )
#	self.remove_control_from_container( CONTAINER_SPATIAL_EDITOR_MENU, self.bone_dock_instance )
#	self.bone_dock_instance.queue_free( )

#handles( obj ) Build-in function -> bool if plugin edits specific obj 
#func handles( obj ):
#	if obj is preload("ArmatureEditor.gd"):
#		self.bone_editor = obj
#		if self.bone_dock_instance != null:
#			self.bone_dock_instance.bone_editor = obj
#			self.bone_dock_instance.visible = true
#		return true
#	elif obj is preload("BoneControl.gd"):
#		self.bone_editor = obj.bone_editor
#		if self.bone_dock_instance != null:
#			self.bone_dock_instance.bone_editor = obj.bone_editor
#			self.bone_dock_instance.visible = true
#		return true
#
#	self.bone_editor = null
#	if self.bone_dock_instance != null:
#		self.bone_dock_instance.bone_editor = null
#		self.bone_dock_instance.visible = false
#
#	return false

#to set plugin name 
func get_plugin_name( ):
	return "Armature Editor"
