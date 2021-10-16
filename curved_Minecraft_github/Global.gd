extends Node
const DIMENSION = Vector3(1,3,1)
const TEXTURE_ATLAS_SIZE = Vector2(13,1)
const GRASS_TEXTURE_ATLAS_SIZE = Vector2(13,1)

enum {
	TOP,
	BOTTOM,
	SIDE1,
	SIDE2,
	SIDE3,
	SIDE4,
	SIDE5,
	SOLID,
	LEAF,
	LEAF1,
	LEAF2,
	LEAF3,
	LEAF4,
	LEAF5,
	LEAF6,
	LEAF7,
}

enum {
	AIR,
	DIRT,
	GRASS,
	STONE,
	PLANT,
}

const types = {
	AIR:{
		SOLID:false
	},
	DIRT:{
		TOP:Vector2(1, 1), BOTTOM:Vector2(1, 1), SIDE1:Vector2(9,1),
		SIDE2:Vector2(10,1), SIDE3:Vector2(11,1), SIDE4:Vector2(12,1),SIDE5: Vector2(13,1), 
		LEAF1: Vector2(2,1), LEAF2: Vector2(3,1),LEAF3: Vector2(4,1), 
		LEAF4: Vector2(5,1), LEAF5: Vector2(6,1), LEAF6: Vector2(7,1), LEAF7:Vector2(8,1), 
		SOLID:true,
	},
	GRASS:{
		TOP:Vector2(1, 1), BOTTOM:Vector2(1, 1), SIDE1:Vector2(9,1),
		SIDE2:Vector2(10,1), SIDE3:Vector2(11,1), SIDE4:Vector2(12,1),SIDE5: Vector2(13,1), 
		LEAF1: Vector2(2,1), LEAF2: Vector2(3,1),LEAF3: Vector2(4,1), 
		LEAF4: Vector2(5,1), LEAF5: Vector2(6,1), LEAF6: Vector2(7,1), LEAF7:Vector2(8,1), 
		SOLID:true,
	},
	STONE:{
		TOP:Vector2(1, 1), BOTTOM:Vector2(1, 1), SIDE1:Vector2(9,1),
		SIDE2:Vector2(10,1), SIDE3:Vector2(11,1), SIDE4:Vector2(12,1),SIDE5: Vector2(13,1), 
		LEAF1: Vector2(2,1), LEAF2: Vector2(3,1),LEAF3: Vector2(4,1), 
		LEAF4: Vector2(5,1), LEAF5: Vector2(6,1), LEAF6: Vector2(7,1), LEAF7:Vector2(8,1), 
		SOLID:true,
	},
}

