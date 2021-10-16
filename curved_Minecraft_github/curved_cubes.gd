extends StaticBody
tool

const grass_vertices = [
	Vector3(1,1,0.15),        #0
	Vector3(0.7, 1, 0.15),     #1
	Vector3(1, 1.15, 0.15),    #2
	Vector3(0.7,1.15, 0.15),    #3
	Vector3(0.95, 1, 0.25),    #4
	Vector3(0.95,1.15, 0.25),    #5
	Vector3(0.75, 1, 0.05),    #6
	Vector3(0.75, 1.15, 0.05),    #7
	Vector3(0.85, 1, 0.3),    #8
	Vector3(0.85, 1.15, 0.3),    #9
	Vector3(0.85, 1, 0),    #10
	Vector3(0.85, 1.15, 0),    #11
	Vector3(0.75, 1, 0.25),    #12
	Vector3(0.75, 1.15, 0.25),    #13
	Vector3(0.95, 1, 0.05),    #14
	Vector3(0.95,1.15, 0.05),   #15
]

const grass_vertices2 = [
	Vector3(0.89, 0.6, -0.15),        #0
	Vector3(0.78, 0.73, 0.13),     #1
	Vector3(0.87, 0.9, -0.11),    #2
	Vector3(0.78, 0.9, 0.11),    #3
	
	Vector3(0.8, 0.66, -0.17),    #4
	Vector3(0.7, 0.76, 0.1),    #5
	Vector3(0.84, 0.9, 0.13), #6
	Vector3(0.95, 0.85, -0.1),    #7
	
	Vector3(0.75, 0.75, -0.2),    #8
	Vector3(0.7, 0.8, 0),    #9
	Vector3(0.86, 0.82, 0.15),    #10
	Vector3(1, 0.76, -0.07),    #11
	
	Vector3(1, 0.7, -0.1),    #12
	Vector3(0.83, 0.76, 0.15),    #13
	Vector3(0.8, 0.85, -0.15),    #14
	Vector3(0.7, 0.9, 0.1),   #15
]

const grass_vertices3 = [
	Vector3(0.89, 0.6, 1.15),        #0
	Vector3(0.78, 0.73, 0.87),     #1
	Vector3(0.87, 0.9, 1.11),    #2
	Vector3(0.78, 0.9, 0.89),    #3
	
	Vector3(0.8, 0.66, 1.17),    #4
	Vector3(0.7, 0.76, 0.9),    #5
	Vector3(0.84, 0.9, 0.87), #6
	Vector3(0.95, 0.85, 1.1),    #7
	
	Vector3(0.75, 0.75, 1.2),    #8
	Vector3(0.7, 0.8, 1),    #9
	Vector3(0.86, 0.82, 0.85),    #10
	Vector3(1, 0.76, 1.07),    #11
	
	Vector3(1, 0.7, 1.1),    #12
	Vector3(0.83, 0.76, 0.85),    #13
	Vector3(0.8, 0.85, 1.15),    #14
	Vector3(0.7, 0.9, 0.9),   #15
]
const LEAF = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]; 

var i = []
var vertices = []

var BOTTOM
var LEFT
var RIGHT
var FRONT
var BACK
var TOP

var height 
var width

var uv_offset

var block_type = null; 

var a_ 
var b_
var c_ 
var d_ 
var e_ 
var f_
var g_
var h_ 
var i_
var j_
var k_ 
var l_
var m_ 
var n_
var o_
var p_ 
var q_ 
var r_
var s_
var t_
var u_ 
var v_ 
var w_ 
var x_
var y_ 
var z_
var aa_
var ab_

var uv_a 
var uv_b
var uv_c 
var uv_d 
var uv_e 
var uv_f
var uv_g
var uv_h 
var uv_i 
var uv_j
var uv_k 
var uv_l
var uv_m 
var uv_n
var uv_o
var uv_p 
var uv_q 
var uv_r
var uv_s
var uv_t
var uv_u 
var uv_v 
var uv_w 
var uv_x
var uv_y 
var uv_z
var uv_aa
var uv_ab

var blocks = [] #

var leaf = Global.LEAF3

var rng = RandomNumberGenerator.new(); 

var st = SurfaceTool.new(); 
var gst = SurfaceTool.new(); 

var mesh = null ; 
var mesh_instance = null; 

var gmesh = null; 
var gmesh_instance = null; 

var material = preload("res://new_spatialmaterial.tres");
var grass_material = preload("res://grass_mat.tres"); 

var chunk_position = Vector2() setget set_chunk_position

var noise = OpenSimplexNoise.new(); 

var world

func _ready():
	world = get_parent().get_parent(); 
	material.albedo_texture.set_flags(2) 
	grass_material.albedo_texture.set_flags(2) 
	generate(); 
	
	
func generate():
	blocks= []; 
	
	blocks.resize(Global.DIMENSION.x); 
	for i in range(0, Global.DIMENSION.x):
		blocks[i] = []; 
		blocks[i].resize(Global.DIMENSION.y); 
		for j in range (0, Global.DIMENSION.y): 
			blocks[i][j]= []; 
			blocks[i][j].resize(Global.DIMENSION.z); 
			for k in range (0, Global.DIMENSION.z):
				var global_pos = chunk_position * Vector2(Global.DIMENSION.x, Global.DIMENSION.z) + Vector2(i, k)
				
				var height = int((noise.get_noise_2dv(global_pos) + 1) / 2 * Global.DIMENSION.y)
				var block = Global.AIR
				
				if j < height / 2:
					block = Global.STONE; 
				elif j < height:
					block = Global.DIRT; 
				elif j== height: 
					block = Global.GRASS; 
					
				blocks[i][j][k] = block; 

func update():
	if mesh_instance != null:
		mesh_instance.call_deferred("queue_free")
		mesh_instance = null
	
	mesh = Mesh.new()
	mesh_instance = MeshInstance.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	if gmesh_instance != null:
		gmesh_instance.call_deferred("queue_free")
		gmesh_instance = null
	
	gmesh = Mesh.new()
	gmesh_instance = MeshInstance.new()
	gst.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	for x in Global.DIMENSION.x:
		for y in Global.DIMENSION.y:
			for z in Global.DIMENSION.z:
				create_block(x,y,z); 
	
	st.generate_normals(false)
	st.set_material(material)
	st.commit(mesh)
	mesh_instance.set_mesh(mesh)
	
	add_child(mesh_instance)
	mesh_instance.create_trimesh_collision()
	
	
	gst.generate_normals(false)
	gst.set_material(grass_material)
	gst.commit(gmesh)
	gmesh_instance.set_mesh(gmesh)
	
	add_child(gmesh_instance)
	
	self.visible = true; 
	
	
func check_local_transparent(x, y, z):
	if x >= 0 && x < Global.DIMENSION.x && \
		y >= 0  && y < Global.DIMENSION.y && \
		z >= 0 && z < Global.DIMENSION.z:
		return not Global.types[blocks[x][y][z]][Global.SOLID]
	return true
	
func check_transparent(x, y, z):
	var nc = world.get_chunk(Vector2(x,z))
	if nc != null:
		return nc.check_local_transparent(0, y, 0); 
		
func rand_grass():
	rng.randomize(); 
	var r_leaf = rng.randi_range(0,999); 
	if r_leaf <=799:
		leaf = Global.LEAF3
	elif r_leaf >= 930 && r_leaf <= 969:
		leaf = Global.LEAF5; 
	elif r_leaf >=850 && r_leaf <= 829:
		leaf = Global.LEAF1; 
	elif r_leaf >= 970 && r_leaf <= 995:
		leaf = Global.LEAF4; 
	elif r_leaf >= 995 && r_leaf <= 997:
		leaf = Global.LEAF6; 
	elif r_leaf >= 998 && r_leaf <= 998:
		leaf = Global.LEAF7; 
	else:
		leaf = Global.LEAF2; 

	
func create_block(x, y, z):
	var block = blocks[x][y][z]
	var height = 1.0 / Global.TEXTURE_ATLAS_SIZE.y 
	var width = 1.0 / Global.TEXTURE_ATLAS_SIZE.x
	if block == Global.AIR:
		return
		
	var block_data = {
	"cube1" :
		{"vertices" : [
			Vector3(1, 0, 0), #0
			Vector3(0, 0, 0), #1
			Vector3(0, 0.7, 0), #2
			Vector3(0.1, 0.9, 0), #3
			Vector3(0.3, 1, 0), #4
			Vector3(1, 1, 0), #5
			Vector3(1, 0, 1), #6
			Vector3(0, 0, 1),  #7
			Vector3(0, 0.7, 1), #8
			Vector3(0.1,0.9,1), #9 
			Vector3(0.3,1,1), #10 
			Vector3(1,1,1), #11 
		],
		"BOTTOM":
			{"uvs":
				[Vector2(0, -0.2*width),
				Vector2(-0.05*width, -0.05*height),
				Vector2(-0.2*width, 0),
				Vector2(-0.8*width, 0),
				Vector2(-0.95*width, -0.05*height),
				Vector2(-width, -0.2*height),
				Vector2(0, -0.8*height),
				Vector2(-0.05*width, -0.95*height),
				Vector2(-0.2*width, -height),
				Vector2(-0.8*width, -height),
				Vector2(-0.95*width, -0.95*height),
				Vector2(-width, -0.8*height)]
			,
			"coords":  [0,1,6,7]},
		"TOP":
			{ "uvs":[
			Vector2(-width, 0),
			Vector2(-0.9*width, 0),
			Vector2(-0.7*width, 0),
			Vector2(0,0),
			Vector2(-width, -height),
			Vector2(-0.9*width, -height),
			Vector2(-0.7*width, -height),
			Vector2(0,-height)
		],
		"coords":[2,3,4,5,8,9,10,11]},
		"LEFT":{
			"uvs":[
				Vector2(0, 0),
				Vector2(0, -0.7*height),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height)
			],
			"coords":[1,2,7,8],
		},
		"RIGHT":
			{
			"uvs":
				[Vector2(0, 0),
				Vector2(0, -height),
				Vector2(-width,0),
				Vector2(-width, -height)
			],
			"coords":[0,5,6,11],
			},
		},
	"cube2" :
		{"vertices" : [
			Vector3(0, 0, 0), #0
			Vector3(1, 0, 0), #1
			Vector3(1, 0.7, 0), #2
			Vector3(0.9, 0.9, 0), #3
			Vector3(0.7, 1, 0), #4
			Vector3(0, 1, 0), #5
			Vector3(0, 0, 1), #6
			Vector3(1, 0, 1),  #7
			Vector3(1, 0.7, 1), #8
			Vector3(0.9,0.9,1), #9 
			Vector3(0.7,1,1), #10 
			Vector3(0,1,1), #11 
		],
		"BOTTOM":
			{"uvs":
				[Vector2(0, 0),
				Vector2(0, -height),
				Vector2(-width, 0),
				Vector2(-width, -height)]
			,
			"coords":  [0,1,6,7]},
		"TOP":
			{ "uvs":[
			Vector2(-width, 0),
			Vector2(-0.9*width, 0),
			Vector2(-0.7*width, 0),
			Vector2(0,0),
			Vector2(-width, -height),
			Vector2(-0.9*width, -height),
			Vector2(-0.7*width, -height),
			Vector2(0,-height)
		],
		"coords":[2,3,4,5,8,9,10,11]},
		"LEFT":{
			"uvs":[
				 Vector2(0, 0),
				Vector2(0, -height),
				Vector2(-width,0),
				Vector2(-width, -height)
			],
			"coords":[0,5,6,11],
		},
		"RIGHT":{
			"uvs":
				[Vector2(0, 0),
				Vector2(0, -0.7*height),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height)
			],
			"coords":[1,2,7,8],
			}},
	"cube3" :
		{"vertices" : [
			Vector3(0, 0, 0), #0
			Vector3(0,0,1), #1
			Vector3(0,0.7,1), #2
			Vector3(0,0.9,0.9), #3
			Vector3(0,1,0.7), #4
			Vector3(0,1,0), #5
			Vector3(1,0,0), #6
			Vector3(1,0,1),  #7
			Vector3(1,0.7,1), #8
			Vector3(1,0.9,0.9), #9 
			Vector3(1,1,0.7), #10 
			Vector3(1,1,0), #11 
		],
		"BOTTOM":
			{"uvs":
				[Vector2(0, 0),
				Vector2(0, -height),
				Vector2(-width, 0),
				Vector2(-width, -height)],
			"coords":  [0,1,6,7]},
		"TOP":
			{ "uvs":[
				Vector2(-width, 0),
				Vector2(-0.9*width, 0),
				Vector2(-0.7*width, 0),
				Vector2(0,0),
				Vector2(-width, -height),
				Vector2(-0.9*width, -height),
				Vector2(-0.7*width, -height),
				Vector2(0,-height)
		],
		"coords":[2,3,4,5,8,9,10,11]},
		"FRONT":{
			"uvs":[
				Vector2(0, 0),
				Vector2(0, -0.7*height),
				Vector2(-width,0),
				Vector2(-width, -0.7*height)
			],
			"coords":[1,2,7,8],
		},
		"BACK":{
			"uvs":
				[Vector2(0, 0),
				Vector2(0, -0.7*height),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height)
			],
			"coords":[0,5,6,11],
			}
		},
	"cube4" :
		{"vertices" : [
			Vector3(0, 0, 1), #0
			Vector3(0,0,0), #1
			Vector3(0,0.7,0), #2
			Vector3(0,0.9,0.1), #3
			Vector3(0,1,0.3), #4
			Vector3(0,1,1), #5
			Vector3(1,0,1), #6
			Vector3(1,0,0),  #7
			Vector3(1,0.7,0), #8
			Vector3(1,0.9,0.1), #9 
			Vector3(1,1,0.3), #10 
			Vector3(1,1,1), #11 
		],
		"BOTTOM":
			{"uvs":
				[Vector2(0, 0),
				Vector2(0, -height),
				Vector2(-width, 0),
				Vector2(-width, -height)],
			"coords":  [0,1,6,7]},
		"TOP":
			{ "uvs":[
				Vector2(-width, 0),
				Vector2(-0.9*width, 0),
				Vector2(-0.7*width, 0),
				Vector2(0,0),
				Vector2(-width, -height),
				Vector2(-0.9*width, -height),
				Vector2(-0.7*width, -height),
				Vector2(0,-height)
		],
		"coords":[2,3,4,5,8,9,10,11]},
		"FRONT":{
			"uvs":[
				Vector2(0, 0),
				Vector2(0, -0.7*height),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height)
			],
			"coords":[0,5,6,11],
		},
		"BACK":{
			"uvs":
				[Vector2(0, 0),
				Vector2(0, -0.7*height),
				Vector2(-width,0),
				Vector2(-width, -0.7*height)
			],
			"coords":[1,2,7,8],
			}},
	"cube5" :
		{"vertices" : [
			Vector3(0,0,0), #0
			Vector3(1,0,0), #1
			Vector3(1,1,0), #2
			Vector3(0.3,1,0), #3
			Vector3(0.1,0.9,0), #4
			Vector3(0,0.7,0), #5
			Vector3(0,0,0.8),  #6
			Vector3(0.05,0,0.95), #7
			Vector3(0.2,0,1), #8
			Vector3(1,0,1), #9
			Vector3(1,0.7,1), #10 
			Vector3(1,0.9,0.9), #11
			Vector3(1,1,0.7), #12 
			Vector3(0.3,1,0.7), #13
			Vector3(0.25,0.9,0.9), #14
			Vector3(0.2,0.7,1), #15
			Vector3(0.15,0.9,0.85), #16
			Vector3(0.05,0.7,0.95), #17
			Vector3(0.1,0.9,0.75), #18
			Vector3(0,0.7,0.8) #19
		],
		"BOTTOM":
			{"uvs":
				[Vector2(0, 0),
				Vector2(-width, 0),
				Vector2(0, -0.8*height),
				Vector2(-0.05*width, -0.95*height),
				Vector2(-0.2*width, -0.8*height),
				Vector2(-width, -height)],
			"coords":  [0, 1, 6, 7, 8, 9]},
		"TOP":
			{ "uvs":[
				Vector2(-width,0),
				Vector2(-0.3*width, 0),
				Vector2(-0.1*width, 0),
				Vector2(0, 0),
				Vector2(-width, -height),
				Vector2(-width, -0.9*height),
				Vector2(-width, -0.7*height),
				Vector2(-0.3*width, -0.7*height),
				Vector2(-0.25*width, -0.9*height),
				Vector2(-0.2*width, -height),
				Vector2(-0.15*width, -0.85*height),
				Vector2(-0.05*width, -0.95*height),
				Vector2(-0.1*width, -0.75*height),
				Vector2(0,-0.8*height),
		],
		"coords":[2,3,4,5,10,11,12,13,14,15,16,17,18,19]},
		"LEFT":{
			"uvs":[
				Vector2(0, 0),
				Vector2(0, -height * 0.7),
				Vector2(-0.8*width, 0),
				Vector2(-0.8*width, -0.7*height)
			],
			"coords":[0,5,6,19],
		},
		"RIGHT":{
			"uvs":
				[ Vector2(0,0),
				Vector2(0,-height),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height)
			],
			"coords":[1, 2, 9, 10, 11, 12],
			},
		"FRONT":{
			"uvs":[Vector2(0,0),
				Vector2(-0.05*width,0),
				Vector2(-0.2*width,0),
				Vector2(-1*width,0),
				Vector2(-1*width,-0.7*height),
				Vector2(-0.2*width,-0.7*height),
				Vector2(-0.05*width,-0.7*height),
				Vector2(0,-0.7*height)],
			"coords":[6, 7, 8, 9, 10, 15, 17, 19]
		},
		"BACK":{
			"uvs":[Vector2(0, 0),
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(-0.3* width, -height),
				Vector2(-0.1* width, -0.9*height),
				Vector2(0, -0.7* height)],
			"coords":[0,1,2,3,4,5]
		}
		},
	"cube6" :
		{"vertices" : [
			Vector3(1,0,0), #0
			Vector3(0,0,0), #1
			Vector3(0,1,0), #2
			Vector3(0.7,1,0), #3
			Vector3(0.9,0.9,0), #4
			Vector3(1,0.7,0), #5
			Vector3(1,0,0.8),  #6
			Vector3(0.95,0,0.95), #7
			Vector3(0.8,0,1), #8
			Vector3(0,0,1), #9
			Vector3(0,0.7,1), #10 
			Vector3(0,0.9,0.9), #11
			Vector3(0,1,0.7), #12 
			Vector3(0.7,1,0.7), #13
			Vector3(0.75,0.9,0.9), #14
			Vector3(0.8,0.7,1), #15
			Vector3(0.85,0.9,0.85), #16
			Vector3(0.95,0.7,0.95), #17
			Vector3(0.9,0.9,0.75), #18
			Vector3(1,0.7,0.8) #19
		],
		"BOTTOM":
			{"uvs":
				[Vector2(0, 0),
				Vector2(-width, 0),
				Vector2(0, -0.8*height),
				Vector2(-0.05*width, -0.95*height),
				Vector2(-0.2*width, -0.8*height),
				Vector2(-width, -height)],
			"coords":  [0, 1, 6, 7, 8, 9]},
		"TOP":
			{ "uvs":[
				Vector2(-width,0),
				Vector2(-0.3*width, 0),
				Vector2(-0.1*width, 0),
				Vector2(0, 0),
				Vector2(-width, -height),
				Vector2(-width, -0.9*height),
				Vector2(-width, -0.7*height),
				Vector2(-0.3*width, -0.7*height),
				Vector2(-0.25*width, -0.9*height),
				Vector2(-0.2*width, -height),
				Vector2(-0.15*width, -0.85*height),
				Vector2(-0.05*width, -0.95*height),
				Vector2(-0.1*width, -0.75*height),
				Vector2(0,-0.8*height),
		],
		"coords":[2,3,4,5,10,11,12,13,14,15,16,17,18,19]},
		"LEFT":{
			"uvs":[
				Vector2(0, 0),
				Vector2(0, -height * 0.7),
				Vector2(-0.8*width, 0),
				Vector2(-0.8*width, -0.7*height)
			],
			"coords":[1, 2, 9, 10, 11, 12],
		},
		"RIGHT":{
			"uvs":
				[ Vector2(0,0),
				Vector2(0,-height),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height)
			],
			"coords":[0,5,6,19],
			},
		"FRONT":{
			"uvs":[Vector2(0,0),
				Vector2(-0.05*width,0),
				Vector2(-0.2*width,0),
				Vector2(-1*width,0),
				Vector2(-1*width,-0.7*height),
				Vector2(-0.2*width,-0.7*height),
				Vector2(-0.05*width,-0.7*height),
				Vector2(0,-0.7*height)],
			"coords":[6, 7, 8, 9, 10, 15, 17, 19]
		},
		"BACK":{
			"uvs":[Vector2(0, 0),
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(-0.3* width, -height),
				Vector2(-0.1* width, -0.9*height),
				Vector2(0, -0.7* height)],
			"coords":[0,1,2,3,4,5]
		}},
	"cube7" :
		{"vertices" : [
			Vector3(1,0,1), #0
			Vector3(0,0,1), #1
			Vector3(0,1,1), #2
			Vector3(0.7,1,1), #3
			Vector3(0.9,0.9,1), #4
			Vector3(1,0.7,1), #5
			Vector3(1,0,0.2),  #6
			Vector3(0.95,0,0.05), #7
			Vector3(0.8,0,0), #8
			Vector3(0,0,0), #9
			Vector3(0,0.7,0), #10 
			Vector3(0,0.9,0.1), #11
			Vector3(0,1,0.3), #12 
			Vector3(0.7,1,0.3), #13
			Vector3(0.75,0.9,0.1), #14
			Vector3(0.8,0.7,0), #15
			Vector3(0.85,0.9,0.15), #16
			Vector3(0.95,0.7,0.05), #17
			Vector3(0.9,0.9,0.25), #18
			Vector3(1,0.7,0.2) #19
		],
		"BOTTOM":
			{"uvs":
				[Vector2(0, 0),
				Vector2(-width, 0),
				Vector2(0, -0.8*height),
				Vector2(-0.05*width, -0.95*height),
				Vector2(-0.2*width, -0.8*height),
				Vector2(-width, -height)],
			"coords":  [0, 1, 6, 7, 8, 9]},
		"TOP":
			{ "uvs":[
				Vector2(-width,0),
				Vector2(-0.3*width, 0),
				Vector2(-0.1*width, 0),
				Vector2(0, 0),
				Vector2(-width, -height),
				Vector2(-width, -0.9*height),
				Vector2(-width, -0.7*height),
				Vector2(-0.3*width, -0.7*height),
				Vector2(-0.25*width, -0.9*height),
				Vector2(-0.2*width, -height),
				Vector2(-0.15*width, -0.85*height),
				Vector2(-0.05*width, -0.95*height),
				Vector2(-0.1*width, -0.75*height),
				Vector2(0,-0.8*height)
		],
		"coords":[2,3,4,5,10,11,12,13,14,15,16,17,18,19]},
		"LEFT":{
			"uvs":[
				Vector2(0,0),
				Vector2(0,-height),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height)
			],
			"coords":[1, 2, 9, 10, 11, 12],
		},
		"RIGHT":{
			"uvs":
				[ Vector2(0, 0),
				Vector2(0, -height * 0.7),
				Vector2(-0.8*width, 0),
				Vector2(-0.8*width, -0.7*height)
			],
			"coords":[0,5,6,19],
			},
		"FRONT":{
			"uvs":[Vector2(0, 0),
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(-0.3* width, -height),
				Vector2(-0.1* width, -0.9*height),
				Vector2(0, -0.7* height)],
			"coords":[0,1,2,3,4,5]
		},
		"BACK":{
			"uvs":[Vector2(0,0),
				Vector2(-0.05*width,0),
				Vector2(-0.2*width,0),
				Vector2(-1*width,0),
				Vector2(-1*width,-0.7*height),
				Vector2(-0.2*width,-0.7*height),
				Vector2(-0.05*width,-0.7*height),
				Vector2(0,-0.7*height)],
			"coords":[6, 7, 8, 9, 10, 15, 17, 19]}
		},
	"cube8" :
		{"vertices" : [
			Vector3(0,0,1), #0
			Vector3(1,0,1), #1
			Vector3(1,1,1), #2
			Vector3(0.3,1,1), #3
			Vector3(0.1,0.9,1), #4
			Vector3(0,0.7,1), #5
			Vector3(0,0,0.2),  #6
			Vector3(0.05,0,0.05), #7
			Vector3(0.2,0,0), #8
			Vector3(1,0,0), #9
			Vector3(1,0.7,0), #10 
			Vector3(1,0.9,0.1), #11
			Vector3(1,1,0.3), #12 
			Vector3(0.3,1,0.3), #13
			Vector3(0.25,0.9,0.1), #14
			Vector3(0.2,0.7,0), #15
			Vector3(0.15,0.9,0.15), #16
			Vector3(0.05,0.7,0.05), #17
			Vector3(0.1,0.9,0.25), #18
			Vector3(0,0.7,0.2) #19
		],
		"BOTTOM":
			{"uvs":
				[Vector2(0, 0),
				Vector2(-width, 0),
				Vector2(0, -0.8*height),
				Vector2(-0.05*width, -0.95*height),
				Vector2(-0.2*width, -0.8*height),
				Vector2(-width, -height)],
			"coords":  [0, 1, 6, 7, 8, 9]},
		"TOP":
			{ "uvs":[
				 Vector2(-width,0),
				Vector2(-0.3*width, 0),
				Vector2(-0.1*width, 0),
				Vector2(0, 0),
				Vector2(-width, -height),
				Vector2(-width, -0.9*height),
				Vector2(-width, -0.7*height),
				Vector2(-0.3*width, -0.7*height),
				Vector2(-0.25*width, -0.9*height),
				Vector2(-0.2*width, -height),
				Vector2(-0.15*width, -0.85*height),
				Vector2(-0.05*width, -0.95*height),
				Vector2(-0.1*width, -0.75*height),
				Vector2(0,-0.8*height)
		],
		"coords":[2,3,4,5,10,11,12,13,14,15,16,17,18,19]},
		"RIGHT":{
			"uvs":[
				Vector2(0,0),
				Vector2(0,-height),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height)
			],
			"coords":[1, 2, 9, 10, 11, 12],
		},
		"LEFT":{
			"uvs":
				[Vector2(0, 0),
				Vector2(0, -height * 0.7),
				Vector2(-0.8*width, 0),
				Vector2(-0.8*width, -0.7*height)
			],
			"coords":[0,5,6,19],
			},
		"FRONT":{
			"uvs":[Vector2(0, 0),
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(-0.3* width, -height),
				Vector2(-0.1* width, -0.9*height),
				Vector2(0, -0.7* height)],
			"coords":[0,1,2,3,4,5]
		},
		"BACK":{
			"uvs":[Vector2(0,0),
				Vector2(-0.05*width,0),
				Vector2(-0.2*width,0),
				Vector2(-1*width,0),
				Vector2(-1*width,-0.7*height),
				Vector2(-0.2*width,-0.7*height),
				Vector2(-0.05*width,-0.7*height),
				Vector2(0,-0.7*height)],
			"coords":[6, 7, 8, 9, 10, 15, 17, 19]}},
	"cube13":
		{"vertices" : [
			Vector3(0,0,0), #0
			Vector3(0.8,0,0), #1
			Vector3(0.95,0,0.05), #2
			Vector3(1,0,0.2), #3
			Vector3(1,0.7,0.2), #4
			Vector3(0.95,0.7,0.05), #5
			Vector3(0.8,0.7,0), #6
			Vector3(0,0.7,0),  #7
			Vector3(0,0.9,0.1), #8
			Vector3(0.75,0.9,0.1), #9 
			Vector3(0.85,0.9,0.15), #10 
			Vector3(0.9,0.9,0.25), #11  
			Vector3(0.7,1,0.3), #12
			Vector3(0,1,0.3), #13  
			Vector3(0,0,1), #14  
			Vector3(0.8,0,1), #15  
			Vector3(0.95,0,0.95), #16  
			Vector3(1,0,0.8), #17  
			Vector3(1,0.7,0.8), #18  
			Vector3(0.95,0.7,0.95), #19  
			Vector3(0.8,0.7,1), #20  
			Vector3(0,0.7,1), #21  
			Vector3(0,0.9,0.9), #22  
			Vector3(0.75,0.9,0.9), #23 
			Vector3(0.85,0.9,0.85), #24  
			Vector3(0.9,0.9,0.75), #25  
			Vector3(0.7,1,0.7), #26  
			Vector3(0,1,0.7), #27  
		],
		"BOTTOM":
			{"uvs":
				[Vector2(0,0),
				Vector2(-0.8*width, 0),
				Vector2(-0.95*width, -0.05*height),
				Vector2(-width, -0.2*height),
				Vector2(0, -height),
				Vector2(-0.8*width, -height),
				Vector2(-0.95*width, -0.95*height),
				Vector2(-width, -0.8*height)],
			"coords":  [0,1,2,3,14,15,16,17]},
		"TOP":
			{ "uvs":[
				Vector2(0, -0.8*height),
				Vector2(-0.05*width, -0.95*height),
				Vector2(-0.2*width, -height),
				Vector2(-width, -height),
				Vector2(-width, -0.9*height),
				Vector2(-0.25*width, -0.9*height),
				Vector2(-0.15*width, -0.85*height),
				Vector2(-0.1*width, -0.75*height),
				Vector2(-0.3*width, -0.7*height),
				Vector2(-width, -0.7*height),
				Vector2(0, -0.2*height),
				Vector2(-0.05*width, -0.05*height),
				Vector2(-0.2*width, 0),
				Vector2(-width, 0),
				Vector2(-width, -0.1*height),
				Vector2(-0.25*width, -0.1*height),
				Vector2(-0.15*width, -0.15*height),
				Vector2(-0.1*width, -0.25*height),
				Vector2(-0.3*width, -0.3*height),
				Vector2(-width, -0.3*height)
		],
		"coords":[4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27]},
		"LEFT":{
			"uvs":[
				Vector2(0,0),
				Vector2(0,-0.7*height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(-0.3*width, -height),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height)
			],
			"coords":[0,7,8,13,14,21,22,27],
		},
		"RIGHT":{
			"uvs":
				[Vector2(-0.2*width, 0),
				Vector2(-0.2*width, -0.7*height),
				Vector2(-0.8*width, 0),
				Vector2(-0.8*width, -0.7*height)
			],
			"coords":[3, 4, 17, 18],
			},
		"FRONT":{
			"uvs":[Vector2(0,0),
				Vector2(-0.8*width, 0),
				Vector2(-0.95*width, 0),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.95*width, -0.7*height),
				Vector2(-0.8*width, -0.7*height),
				Vector2(0,-0.7*height)],
			"coords":[14, 15, 16, 17, 18, 19, 20 ,21]
		},
		"BACK":{
			"uvs":[Vector2(0,0),
				Vector2(-0.8*width, 0),
				Vector2(-0.95*width, 0),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.95*width, -0.7*height),
				Vector2(-0.8*width, -0.7*height),
				Vector2(0,-0.7*height)],
			"coords":[0,1,2,3,4,5,6,7]}
		},
	"cube14":
		{"vertices" : [
			Vector3(1,0,0), #0
			Vector3(0.2,0,0), #1
			Vector3(0.05,0,0.05), #2
			Vector3(0,0,0.2), #3
			Vector3(0,0.7,0.2), #4
			Vector3(0.05,0.7,0.05), #5
			Vector3(0.2,0.7,0), #6
			Vector3(1,0.7,0),  #7
			Vector3(1,0.9,0.1), #8
			Vector3(0.25,0.9,0.1), #9 
			Vector3(0.15,0.9,0.15), #10 
			Vector3(0.1,0.9,0.25), #11  
			Vector3(0.3,1,0.3), #12
			Vector3(1,1,0.3), #13  
			Vector3(1,0,1), #14  
			Vector3(0.2,0,1), #15  
			Vector3(0.05,0,0.95), #16  
			Vector3(0,0,0.8), #17  
			Vector3(0,0.7,0.8), #18  
			Vector3(0.05,0.7,0.95), #19  
			Vector3(0.2,0.7,1), #20  
			Vector3(1,0.7,1), #21  
			Vector3(1,0.9,0.9), #22  
			Vector3(0.25,0.9,0.9), #23 
			Vector3(0.15,0.9,0.85), #24  
			Vector3(0.1,0.9,0.75), #25  
			Vector3(0.3,1,0.7), #26  
			Vector3(1,1,0.7), #27
		],
		"BOTTOM":
			{"uvs":
				[Vector2(0,0),
				Vector2(-0.8*width, 0),
				Vector2(-0.95*width, -0.05*height),
				Vector2(-width, -0.2*height),
				Vector2(0, -height),
				Vector2(-0.8*width, -height),
				Vector2(-0.95*width, -0.95*height),
				Vector2(-width, -0.8*height)],
			"coords":  [0,1,2,3,14,15,16,17]},
		"TOP":
			{ "uvs":[
				Vector2(0, -0.8*height),
				Vector2(-0.05*width, -0.95*height),
				Vector2(-0.2*width, -height),
				Vector2(-width, -height),
				Vector2(-width, -0.9*height),
				Vector2(-0.25*width, -0.9*height),
				Vector2(-0.15*width, -0.85*height),
				Vector2(-0.1*width, -0.75*height),
				Vector2(-0.3*width, -0.7*height),
				Vector2(-width, -0.7*height),
				Vector2(0, -0.2*height),
				Vector2(-0.05*width, -0.05*height),
				Vector2(-0.2*width, 0),
				Vector2(-width, 0),
				Vector2(-width, -0.1*height),
				Vector2(-0.25*width, -0.1*height),
				Vector2(-0.15*width, -0.15*height),
				Vector2(-0.1*width, -0.25*height),
				Vector2(-0.3*width, -0.3*height),
				Vector2(-width, -0.3*height)
		],
		"coords":[4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27]},
		"LEFT":{
			"uvs":[
				Vector2(-0.2*width, 0),
				Vector2(-0.2*width, -0.7*height),
				Vector2(-0.8*width, 0),
				Vector2(-0.8*width, -0.7*height),
			],
			"coords":[3, 4, 17, 18],
		},
		"RIGHT":{
			"uvs":
				[Vector2(0,0),
				Vector2(0,-height),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height)
			],
			"coords":[0,7,8,13,14,21,22,27],
			},
		"FRONT":{
			"uvs":[Vector2(0,0),
				Vector2(-0.8*width, 0),
				Vector2(-0.95*width, 0),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.95*width, -0.7*height),
				Vector2(-0.8*width, -0.7*height),
				Vector2(0,-0.7*height)],
			"coords":[14, 15, 16, 17, 18, 19, 20 ,21]
		},
		"BACK":{
			"uvs":[Vector2(0,0),
				Vector2(-0.8*width, 0),
				Vector2(-0.95*width, 0),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.95*width, -0.7*height),
				Vector2(-0.8*width, -0.7*height),
				Vector2(0,-0.7*height)],
			"coords":[0,1,2,3,4,5,6,7]}},

	"cube15":
		{"vertices" : [
			Vector3(0,0,1), #0
			Vector3(0,0,0.2), #1
			Vector3(0.05,0,0.05), #2
			Vector3(0.2,0,0), #3
			Vector3(0.2,0.7,0), #4
			Vector3(0.05,0.7,0.05), #5
			Vector3(0,0.7,0.2), #6
			Vector3(0,0.7,1),  #7
			Vector3(0.1,0.9,1), #8
			Vector3(0.1,0.9,0.25), #9 
			Vector3(0.15,0.9,0.15), #10 
			Vector3(0.25,0.9,0.1), #11  
			Vector3(0.3,1,0.3), #12
			Vector3(0.3,1,1), #13  
			Vector3(1,0,1), #14  
			Vector3(1,0,0.2), #15  
			Vector3(0.95,0,0.05), #16  
			Vector3(0.8,0,0), #17  
			Vector3(0.8,0.7,0), #18  
			Vector3(0.95,0.7,0.05), #19  
			Vector3(1,0.7,0.2), #20  
			Vector3(1,0.7,1), #21  
			Vector3(0.9,0.9,1), #22  
			Vector3(0.9,0.9,0.25), #23 
			Vector3(0.85,0.9,0.15), #24  
			Vector3(0.75,0.9,0.1), #25  
			Vector3(0.7,1,0.3), #26  
			Vector3(0.7,1,1), #27  
		],
		"BOTTOM":
			{"uvs":
				[ Vector2(0,0),
				Vector2(-0.8*width, 0),
				Vector2(-0.95*width, -0.05*height),
				Vector2(-width, -0.2*height),
				Vector2(0, -height),
				Vector2(-0.8*width, -height),
				Vector2(-0.95*width, -0.95*height),
				Vector2(-width, -0.8*height)],
			"coords":  [0,1,2,3,14,15,16,17]},
		"TOP":
			{ "uvs":[
				Vector2(0, -0.8*height),
				Vector2(-0.05*width, -0.95*height),
				Vector2(-0.2*width, -height),
				Vector2(-width, -height),
				Vector2(-width, -0.9*height),
				Vector2(-0.25*width, -0.9*height),
				Vector2(-0.15*width, -0.85*height),
				Vector2(-0.1*width, -0.75*height),
				Vector2(-0.3*width, -0.7*height),
				Vector2(-width, -0.7*height),
				Vector2(0, -0.2*height),
				Vector2(-0.05*width, -0.05*height),
				Vector2(-0.2*width, 0),
				Vector2(-width, 0),
				Vector2(-width, -0.1*height),
				Vector2(-0.25*width, -0.1*height),
				Vector2(-0.15*width, -0.15*height),
				Vector2(-0.1*width, -0.25*height),
				Vector2(-0.3*width, -0.3*height),
				Vector2(-width, -0.3*height)
		],
		"coords":[4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27]},
		"LEFT":{
			"uvs":[
				Vector2(0,0),
				Vector2(-0.8*width, 0),
				Vector2(-0.95*width, 0),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.95*width, -0.7*height),
				Vector2(-0.8*width, -0.7*height),
				Vector2(0,-0.7*height)
			],
			"coords":[0,1,2,3,4,5,6,7],
		},
		"RIGHT":{
			"uvs":[
				Vector2(0,0),
				Vector2(-0.8*width, 0),
				Vector2(-0.95*width, 0),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.95*width, -0.7*height),
				Vector2(-0.8*width, -0.7*height),
				Vector2(0,-0.7*height),
			],
			"coords":[14, 15, 16, 17, 18, 19, 20 ,21],
			},
		"FRONT":{
			"uvs":[Vector2(0,0),
				Vector2(0,-0.7*height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(-0.3*width, -height),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height)],
			"coords":[0,7,8,13,14,21,22,27]
		},
		"BACK":{
			"uvs":[Vector2(-0.2*width, 0),
				Vector2(-0.2*width, -0.7*height),
				Vector2(-0.8*width, 0),
				Vector2(-0.8*width, -0.7*height)],
			"coords":[3, 4, 17, 18]}},
	"cube16":
		{"vertices" : [
			Vector3(1,0,0), #0
			Vector3(1,0,0.8), #1
			Vector3(0.95,0,0.95), #2
			Vector3(0.8,0,1), #3
			Vector3(0.8,0.7,1), #4
			Vector3(0.95,0.7,0.95), #5
			Vector3(1,0.7,0.8), #6
			Vector3(1,0.7,0),  #7
			Vector3(0.9,0.9,0), #8
			Vector3(0.9,0.9,0.75), #9 
			Vector3(0.85,0.9,0.85), #10 
			Vector3(0.75,0.9,0.9), #11  
			Vector3(0.7,1,0.7), #12
			Vector3(0.7,1,0), #13  
			Vector3(0,0,0), #14  
			Vector3(0,0,0.8), #15  
			Vector3(0.05,0,0.95), #16  
			Vector3(0.2,0,1), #17  
			Vector3(0.2,0.7,1), #18  
			Vector3(0.05,0.7,0.95), #19  
			Vector3(0,0.7,0.8), #20  
			Vector3(0,0.7,0), #21  
			Vector3(0.1,0.9,0), #22  
			Vector3(0.1,0.9,0.75), #23 
			Vector3(0.15,0.9,0.85), #24  
			Vector3(0.25,0.9,0.9), #25  
			Vector3(0.3,1,0.7), #26  
			Vector3(0.3,1,0), #27  
		],
		"BOTTOM":
			{"uvs":[Vector2(0,0),
				Vector2(-0.8*width, 0),
				Vector2(-0.95*width, -0.05*height),
				Vector2(-width, -0.2*height),
				Vector2(0, -height),
				Vector2(-0.8*width, -height),
				Vector2(-0.95*width, -0.95*height),
				Vector2(-width, -0.8*height)],
			"coords":[0,1,2,3,14,15,16,17] },
		"TOP":
			{ "uvs":[Vector2(0, -0.8*height),
				Vector2(-0.05*width, -0.95*height),
				Vector2(-0.2*width, -height),
				Vector2(-width, -height),
				Vector2(-width, -0.9*height),
				Vector2(-0.25*width, -0.9*height),
				Vector2(-0.15*width, -0.85*height),
				Vector2(-0.1*width, -0.75*height),
				Vector2(-0.3*width, -0.7*height),
				Vector2(-width, -0.7*height),
				Vector2(0, -0.2*height),
				Vector2(-0.05*width, -0.05*height),
				Vector2(-0.2*width, 0),
				Vector2(-width, 0),
				Vector2(-width, -0.1*height),
				Vector2(-0.25*width, -0.1*height),
				Vector2(-0.15*width, -0.15*height),
				Vector2(-0.1*width, -0.25*height),
				Vector2(-0.3*width, -0.3*height),
				Vector2(-width, -0.3*height)

		],
		"coords":[4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27]},
		"LEFT":{
			"uvs":[Vector2(0,0),
				Vector2(-0.8*width, 0),
				Vector2(-0.95*width, 0),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.95*width, -0.7*height),
				Vector2(-0.8*width, -0.7*height),
				Vector2(0,-0.7*height),

			],
			"coords":[14, 15, 16, 17, 18, 19, 20 ,21],
		},
		"RIGHT":{
			"uvs":[
				Vector2(0,0),
				Vector2(-0.8*width, 0),
				Vector2(-0.95*width, 0),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.95*width, -0.7*height),
				Vector2(-0.8*width, -0.7*height),
				Vector2(0,-0.7*height)
			],
			"coords":[0,1,2,3,4,5,6,7],
			},
		"FRONT":{
			"uvs":[Vector2(-0.2*width, 0),
				Vector2(-0.2*width, -0.7*height),
				Vector2(-0.8*width, 0),
				Vector2(-0.8*width, -0.7*height)],
			"coords":[3, 4, 17, 18]
		},
		"BACK":{
			"uvs":[Vector2(0,0),
				Vector2(0,-0.7*height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(-0.3*width, -height),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height)],
			"coords":[0,7,8,13,14,21,22,27]},
			},
	"cube17":
		{"vertices" : [
			Vector3(0,0,0.2), #0
			Vector3(0.05,0,0.05), #1
			Vector3(0.2,0,0), #2
			Vector3(0.8,0,0), #3
			Vector3(0.95,0,0.05), #4
			Vector3(1,0,0.2), #5
			Vector3(1,0.7,0.2), #6
			Vector3(0.95,0.7,0.05),  #7
			Vector3(0.8,0.7,0), #8
			Vector3(0.2,0.7,0), #9 
			Vector3(0.05,0.7,0.05), #10 
			Vector3(0,0.7,0.2), #11  
			Vector3(0.1,0.9,0.25), #12
			Vector3(0.15,0.9,0.15), #13  
			Vector3(0.25,0.9,0.1), #14  
			Vector3(0.75,0.9,0.1), #15  
			Vector3(0.85, 0.9,0.15), #16  
			Vector3(0.9,0.9,0.25), #17  
			Vector3(0.7,1,0.3), #18  
			Vector3(0.3,1,0.3), #19  
			Vector3(0,0,0.8), #20  
			Vector3(0.05,0,0.95), #21  
			Vector3(0.2,0,1), #22  
			Vector3(0.8,0,1), #23 
			Vector3(0.95,0,0.95), #24  
			Vector3(1, 0, 0.8), #25  
			Vector3(1,0.7,0.8), #26  
			Vector3(0.95,0.7,0.95), #27  
			Vector3(0.8,0.7,1), #28
			Vector3(0.2,0.7,1), #29  
			Vector3(0.05,0.7,0.95), #30  
			Vector3(0,0.7,0.8), #31  
			Vector3(0.9,0.9,0.75), #32  
			Vector3(0.85,0.9,0.85), #33  
			Vector3(0.75,0.9,0.9), #34  
			Vector3(0.25,0.9,0.9), #35  
			Vector3(0.15,0.9,0.85),#36  
			Vector3(0.1,0.9, 0.75), #37  
			Vector3(0.7,1,0.7), #38  
			Vector3(0.3,1,0.7), #39    
		],
		"BOTTOM":
			{"uvs":[Vector2(0, -0.2*width),
				Vector2(-0.05*width, -0.05*height),
				Vector2(-0.2*width, 0),
				Vector2(-0.8*width, 0),
				Vector2(-0.95*width, -0.05*height),
				Vector2(-width, -0.2*height),
				Vector2(0, -0.8*height),
				Vector2(-0.05*width, -0.95*height),
				Vector2(-0.2*width, -height),
				Vector2(-0.8*width, -height),
				Vector2(-0.95*width, -0.95*height),
				Vector2(-width, -0.8*height)],
			"coords":[0,1,2,3,4,5,20,21,22,23,24,25] },
		"TOP":
			{ "uvs":[
				Vector2(-width, -0.8*height),
				Vector2(-0.95*width, -0.95*height),
				Vector2(-0.8*width, -height),
				Vector2(-0.2*width, -height),
				Vector2(-0.05*width, -0.95*height),
				Vector2(0,-0.8*height),
				Vector2(-0.1*width, -0.75*height),
				Vector2(-0.15*width, -0.85*height),
				Vector2(-0.25*width, -0.9*height),
				Vector2(-0.75*width, -0.9*height),
				Vector2(-0.85*width, -0.85*height),
				Vector2(-0.9*width, -0.75*height),
				Vector2(-0.7*width, -0.7*height),
				Vector2(-0.3*width, -0.7*height),
				Vector2(-width, -0.2*height),
				Vector2(-0.95*width, -0.05*height),
				Vector2(-0.8*width, 0),
				Vector2(-0.2*width, 0),
				Vector2(-0.05*width, -0.05*height),
				Vector2(0, -0.2*height),
				Vector2(-0.9*width, -0.2*height),
				Vector2(-0.85*width, -0.15*height),
				Vector2(-0.8*width, -0.1*height),
				Vector2(-0.2*width, -0.1*height),
				Vector2(-0.15*width, -0.15*height),
				Vector2(-0.1*width, -0.25*height),
				Vector2(-0.3*width, -0.3*height),
				Vector2(-0.7*width, -0.3*height)
		],
		"coords":[6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 26, 27, 28, 29, 30,31, 32,33, 34, 35, 36, 37, 38, 39]},
		"LEFT":{
			"uvs":[
				Vector2(-0.2*width, 0),
				Vector2(-0.2*width, -0.7*height),
				Vector2(-0.8*width, 0),
				Vector2(-0.8*width, -0.7*height)
			],
			"coords":[0,11,20,31],
		},
		"RIGHT":{
			"uvs":[
				Vector2(-0.2*width, 0),
				Vector2(-0.2*width, -0.7*height),
				Vector2(-0.8*width, 0),
				Vector2(-0.8*width, -0.7*height)
			],
			"coords":[5,6,25,26],
			},
		"FRONT":{
			"uvs":[Vector2(0,0),
				Vector2(-0.05*width, 0),
				Vector2(-0.2*width, 0),
				Vector2(-0.8*width, 0),
				Vector2(-0.95*width, 0),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.95*width, -0.7*height),
				Vector2(-0.8*width, -0.7*height),
				Vector2(-0.2*width, -0.7*height),
				Vector2(-0.05*width, -0.7*height),
				Vector2(0, -0.7*height)],
			"coords":[20,21,22,23,24,25,26,27,28,29,30,31]
		},
		"BACK":{
			"uvs":[Vector2(0,0),
				Vector2(-0.05*width, 0),
				Vector2(-0.2*width, 0),
				Vector2(-0.8*width, 0),
				Vector2(-0.95*width, 0),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.95*width, -0.7*height),
				Vector2(-0.8*width, -0.7*height),
				Vector2(-0.2*width, -0.7*height),
				Vector2(-0.05*width, -0.7*height),
				Vector2(0, -0.7*height)],
			"coords":[0,1,2,3,4,5,6,7,8,9,10,11]}
		},
	"cube18":
		{"vertices" : [
			Vector3(0, 0, 0), #0
			Vector3(1,0,0), #1
			Vector3(1,1,0), #2
			Vector3(0,1,0), #3
			Vector3(0,0,0.8), #4
			Vector3(0.05,0,0.95), #5
			Vector3(0.2,0,1), #6
			Vector3(1,0,1),  #7
			Vector3(1,1,1), #8
			Vector3(0.2,1,1), #9 
			Vector3(0.05,1,0.95), #10 
			Vector3(0,1,0.8), #11 
		],
		"BOTTOM":
			{"uvs":[Vector2(0, 0),
				Vector2(-width,0),
				Vector2(0,-0.7*height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(-0.3*width, -height),
				Vector2(-width, -height)],
			"coords":[0,1,4,5,6,7] },
		"LEFT":{
			"uvs":[
				Vector2(-0.2*width, 0),
				Vector2(-0.2*width, -height),
				Vector2(-0.8*width, 0),
				Vector2(-0.8*width, -height)
			],
			"coords":[0,3,4,11],
		},
		"RIGHT":{
			"uvs":[
				Vector2(0, 0),
				Vector2(0, -height),
				Vector2(-width, 0),
				Vector2(-width, -height)
			],
			"coords":[1,2,7,8],
			},
		"FRONT":{
			"uvs":[Vector2(0,0),
				Vector2(-0.1*width, 0),
				Vector2(-0.3*width, 0),
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -height),
				Vector2(0,-height)],
			"coords":[4,5,6,7,8,9,10,11]
		},
		"BACK":{
			"uvs":[Vector2(0,0),
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(0, -height)],
			"coords":[0,1,2,3]}
			},
	"cube19":
		{"vertices" : [
			Vector3(1, 0, 0), #0
			Vector3(0,0,0), #1
			Vector3(0,1,0), #2
			Vector3(1,1,0), #3
			Vector3(1,0,0.8), #4
			Vector3(0.95,0,0.95), #5
			Vector3(0.8,0,1), #6
			Vector3(0,0,1),  #7
			Vector3(0,1,1), #8
			Vector3(0.8,1,1), #9 
			Vector3(0.95,1,0.95), #10 
			Vector3(1,1,0.8), #11 
		],
		"BOTTOM":
			{"uvs":[Vector2(0, 0),
				Vector2(-width,0),
				Vector2(0,-0.7*height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(-0.3*width, -height),
				Vector2(-width, -height)],
			"coords":[0,1,4,5,6,7] },
		"LEFT":{
			"uvs":[
				Vector2(0, 0),
				Vector2(0, -height),
				Vector2(-width, 0),
				Vector2(-width, -height)
			],
			"coords":[1,2,7,8],
		},
		"RIGHT":{
			"uvs":[
				Vector2(-0.2*width, 0),
				Vector2(-0.2*width, -height),
				Vector2(-0.8*width, 0),
				Vector2(-0.8*width, -height)
			],
			"coords":[0,3,4,11],
			},
		"FRONT":{
			"uvs":[Vector2(0,0),
				Vector2(-0.1*width, 0),
				Vector2(-0.3*width, 0),
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -height),
				Vector2(0,-height)],
			"coords":[4,5,6,7,8,9,10,11]
		},
		"BACK":{
			"uvs":[Vector2(0,0),
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(0, -height)],
			"coords":[0,1,2,3]}
		},
	"cube20":
		{"vertices" : [
			Vector3(0, 0, 0), #0
			Vector3(0,0,1), #1
			Vector3(0,1,1), #2
			Vector3(0,1,0), #3
			Vector3(0.8,0,0), #4
			Vector3(0.95,0,0.05), #5
			Vector3(1,0,0.2), #6
			Vector3(1,0,1),  #7
			Vector3(1,1,1), #8
			Vector3(1,1,0.2), #9 
			Vector3(0.95,1,0.05), #10 
			Vector3(0.8,1,0), #11 
		],
		"BOTTOM":
			{"uvs":[Vector2(0, 0),
				Vector2(-width,0),
				Vector2(0,-0.7*height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(-0.3*width, -height),
				Vector2(-width, -height)],
			"coords":[0,1,4,5,6,7] },
		"LEFT":{
			"uvs":[
				Vector2(0,0),
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(0, -height)
			],
			"coords":[0,1,2,3],
		},
		"RIGHT":{
			"uvs":[
				Vector2(0,0),
				Vector2(-0.1*width, 0),
				Vector2(-0.3*width, 0),
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -height),
				Vector2(0,-height)
			],
			"coords":[4,5,6,7,8,9,10,11],
			},
		"FRONT":{
			"uvs":[ Vector2(0, 0),
				Vector2(0, -height),
				Vector2(-width, 0),
				Vector2(-width, -height)],
			"coords":[1,2,7,8]
		},
		"BACK":{
			"uvs":[ Vector2(0, 0),
				Vector2(0, -height),
				Vector2(-0.8*width, 0),
				Vector2(-0.8*width, -height)],
			"coords":[0,3,4,11]}
		},
	"cube21":
		{"vertices" : [
			Vector3(1, 0, 0), #0
			Vector3(1,0,1), #1
			Vector3(1,1,1), #2
			Vector3(1,1,0), #3
			Vector3(0.2,0,0), #4
			Vector3(0.05,0,0.05), #5
			Vector3(0,0,0.2), #6
			Vector3(0,0,1),  #7
			Vector3(0,1,1), #8
			Vector3(0,1,0.2), #9 
			Vector3(0.05,1,0.05), #10 
			Vector3(0.2,1,0), #11 
		],
		"BOTTOM":
			{"uvs":[Vector2(0, 0),
				Vector2(-width,0),
				Vector2(0,-0.7*height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(-0.3*width, -height),
				Vector2(-width, -height)],
			"coords":[0,1,4,5,6,7] },
		"LEFT":{
			"uvs":[
				Vector2(0,0),
				Vector2(-0.1*width, 0),
				Vector2(-0.3*width, 0),
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -height),
				Vector2(0,-height)
			],
			"coords":[4,5,6,7,8,9,10,11],
		},
		"RIGHT":{
			"uvs":[
				Vector2(0,0),
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(0, -height)
			],
			"coords":[0,1,2,3],
			},
		"FRONT":{
			"uvs":[Vector2(0, 0),
				Vector2(0, -height),
				Vector2(-width, 0),
				Vector2(-width, -height)],
			"coords":[1,2,7,8]
		},
		"BACK":{
			"uvs":[Vector2(-0.2*width, 0),
				Vector2(-0.2*width, -height),
				Vector2(-width, 0),
				Vector2(-width, -height)],
			"coords":[0,3,4,11]}
		},
	"cube22":
		{"vertices" : [
			Vector3(0,0,0), #0
			Vector3(1,0,0), #1
			Vector3(1,0.7,0), #2
			Vector3(0.9,0.9,0), #3
			Vector3(0.7,1,0), #4
			Vector3(0.3,1,0), #5
			Vector3(0.1,0.9,0), #6
			Vector3(0,0.7,0),  #7
			Vector3(0,0,1), #8
			Vector3(1,0,1), #9 
			Vector3(1,0.7,1), #10 
			Vector3(0.9,0.9,1), #11  
			Vector3(0.7,1,1), #12
			Vector3(0.3,1,1), #13  
			Vector3(0.1,0.9,1), #14  
			Vector3(0,0.7,1), #15  
		],
		"BOTTOM":
			{"uvs":[Vector2(0, 0),
				Vector2(0, -height),
				Vector2(-width, 0),
				Vector2(-width, -height)],
			"coords":[0,1,8,9] },
		"LEFT":{
			"uvs":[
				Vector2(0,0),
				Vector2(0,-0.7*height),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height)
			],
			"coords":[0,7,8,15],
		},
		"RIGHT":{
			"uvs":[
				Vector2(0,0),
				Vector2(0,-0.7*height),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height)
			],
			"coords":[1,2,9,10],
			},
		"FRONT":{
			"uvs":[Vector2(0,0),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0,-0.7*height)],
			"coords":[8,9,10,11,12,13,14,15]
		},
		"BACK":{
			"uvs":[Vector2(0,0),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0, -0.7*height)],
			"coords":[0,1,2,3,4,5,6,7]},
		"TOP":
			{ "uvs":[
				Vector2(-width, -height),
				Vector2(-0.9*width, -height),
				Vector2(-0.7*width, -height),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -height),
				Vector2(0, -height),
				Vector2(-width, 0),
				Vector2(-0.9*width,0),
				Vector2(-0.7*width, 0),
				Vector2(-0.3*width,0),
				Vector2(-0.1*width, 0),
				Vector2(0,0)
		],
		"coords":[2,3,4,5,6,7,10,11,12,13,14,15]},
		},
	"cube23":
		{"vertices" : [
			Vector3(0,0,0), #0
			Vector3(0,0,1), #1
			Vector3(0,0.7,1), #2
			Vector3(0,0.9,0.9), #3
			Vector3(0,1,0.7), #4j
			Vector3(0,1,0.3), #5j
			Vector3(0,0.9,0.1), #6
			Vector3(0,0.7,0),  #7
			Vector3(1,0,0), #8
			Vector3(1,0,1), #9 
			Vector3(1,0.7,1), #10 
			Vector3(1,0.9,0.9), #11  
			Vector3(1,1,0.7), #12j
			Vector3(1,1,0.3), #13j  
			Vector3(1,0.9,0.1), #14  
			Vector3(1,0.7,0), #15  
		],
		"BOTTOM":
			{"uvs":[Vector2(0, 0),
				Vector2(0, -height),
				Vector2(-width, 0),
				Vector2(-width, -height)],
			"coords":[0,1,8,9] },
		"LEFT":{
			"uvs":[
				 Vector2(0,0),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0, -0.7*height)
			],
			"coords":[0,1,2,3,4,5,6,7],
		},
		"RIGHT":{
			"uvs":[
				Vector2(0,0),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0,-0.7*height)
			],
			"coords":[8,9,10,11,12,13,14,15],
			},
		"FRONT":{
			"uvs":[
				Vector2(0,0),
				Vector2(0,-0.7*height),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height)
			],
			"coords":[1,2,9,10]
		},
		"BACK":{
			"uvs":[Vector2(0,0),
				Vector2(0,-0.7*height),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height)],
			"coords":[0,7,8,15]},
		"TOP":
			{ "uvs":[
				Vector2(-width, -height),
				Vector2(-0.9*width, -height),
				Vector2(-0.7*width, -height),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -height),
				Vector2(0, -height),
				Vector2(-width, 0),
				Vector2(-0.9*width,0),
				Vector2(-0.7*width, 0),
				Vector2(-0.3*width,0),
				Vector2(-0.1*width, 0),
				Vector2(0,0)
		],
		"coords":[2,3,4,5,6,7,10,11,12,13,14,15]},
		},
	"cube28":
		{"vertices" : [
			Vector3(0,0,0), #0
			Vector3(0.8,0,0), #1
			Vector3(0.95,0,0.05), #2
			Vector3(1,0,0.2), #3
			Vector3(1,0.7,0.2), #4
			Vector3(0.95,0.7,0.05), #5
			Vector3(0.8,0.7,0), #6
			Vector3(0,0.7,0),  #7
			Vector3(0,0.9,0.1), #8
			Vector3(0.75,0.9,0.1), #9 
			Vector3(0.85,0.9,0.15), #10 
			Vector3(0.9,0.9,0.25), #11 
			Vector3(0.7,1,0.3), #12
			Vector3(0,1,0.3), #13
			Vector3(0,0,1), #14
			Vector3(1,0,1), #15
			Vector3(1,0.7,1), #16
			Vector3(0.9,0.9,1), #17
			Vector3(0.7,1,1), #18
			Vector3(0.25,1,0.75), #19
			Vector3(0,1,0.7), #20
			Vector3(0.1,0.9,1), #21
			Vector3(0.08,0.9,0.92), #22
			Vector3(0,0.9,0.9), #23
			Vector3(0,0.7,1), #24
			Vector3(0.3,1,1), #25
		],
		"BOTTOM":
			{"uvs":[
				Vector2(0,-height),
				Vector2(-0.8*width, -height),
				Vector2(-0.95*width, -0.95*height),
				Vector2(-width, -0.8*height),
				Vector2(0,0),
				Vector2(-width, 0)
			],
			"coords":[0,1,2,3,14,15] 
			},
		"LEFT":{
			"uvs":[
				Vector2(0,0),
				Vector2(0, -0.7*height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(-0.3*width, -height),
				Vector2(-width, 0),
				Vector2(-0.7*width, -height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-width, -0.7*height),
			],
			"coords":[0,7,8,13,14,20,23,24],
		},
		"RIGHT":{
			"uvs":[
				Vector2(0,0),
				Vector2(0,-0.7*height),
				Vector2(-0.8*width, 0),
				Vector2(-0.8*width, -0.7*height)
			],
			"coords":[3,4,15,16],
			},
		"FRONT":{
			"uvs":[
				Vector2(0,0),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0,-0.7*height),
				Vector2(-0.3*width, -height),
			],
			"coords":[14,15,16,17,18,21,24,25]
		},
		"BACK":{
			"uvs":[
				Vector2(0,0),
				Vector2(-0.8*width, 0),
				Vector2(-0.95*width, 0),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.95*width, -0.7*height),
				Vector2(-0.8*width, -0.7*height),
				Vector2(0,-0.7*height)
			],
			"coords":[0,1,2,3,4,5,6,7]},
		"TOP":
			{ "uvs":[
				Vector2(-width, -0.8*height),
				Vector2(-0.95*width, -0.95*height),
				Vector2(-0.8*width, -height),
				Vector2(0, -height),
				Vector2(0, -0.9*height),
				Vector2(-0.75*width, -0.9*height),
				Vector2(-0.85*width, -0.85*height),
				Vector2(-0.9*width, -0.75*height),
				Vector2(-0.7*width, -0.7*height),
				Vector2(0, -0.7*height),
				Vector2(-width, 0),
				Vector2(-0.9*width, 0),
				Vector2(-0.7*width, 0),
				Vector2(-0.25*width, -0.25*height),
				Vector2(0,-0.3*height),
				Vector2(-0.1*width, 0),
				Vector2(-0.08*width, -0.08*height),
				Vector2(0, -0.1*height),
				Vector2(0,0),
				Vector2(-0.3*width, 0)
		],
		"coords":[4,5,6,7,8,9,10,11,12,13,16,17,18,19,20,21,22,23,24,25]},
		},
	"cube29":
		{"vertices" : [
			Vector3(1,0,0), #0
			Vector3(0.2,0,0), #1
			Vector3(0.05,0,0.05), #2
			Vector3(0,0,0.2), #3
			Vector3(0,0.7,0.2), #4
			Vector3(0.05,0.7,0.05), #5
			Vector3(0.2,0.7,0), #6
			Vector3(1,0.7,0),  #7
			Vector3(1,0.9,0.1), #8
			Vector3(0.25,0.9,0.1), #9 
			Vector3(0.15,0.9,0.15), #10 
			Vector3(0.1,0.9,0.25), #11 
			Vector3(0.3,1,0.3), #12
			Vector3(1,1,0.3), #13
			Vector3(1,0,1), #14
			Vector3(0,0,1), #15
			Vector3(0,0.7,1), #16
			Vector3(0.1,0.9,1), #17
			Vector3(0.3,1,1), #18
			Vector3(0.75,1,0.75), #19
			Vector3(1,1,0.7), #20
			Vector3(0.9,0.9,1), #21
			Vector3(0.92,0.9,0.92), #22
			Vector3(1,0.9,0.9), #23
			Vector3(1,0.7,1), #24
			Vector3(0.7,1,1), #25
		],
		"BOTTOM":
			{"uvs":[
				Vector2(0,-height),
				Vector2(-0.8*width, -height),
				Vector2(-0.95*width, -0.95*height),
				Vector2(-width, -0.8*height),
				Vector2(0,0),
				Vector2(-width, 0)
			],
			"coords":[0,1,2,3,14,15] 
			},
		"LEFT":{
			"uvs":[
				Vector2(0,0),
				Vector2(0,-0.7*height),
				Vector2(-0.8*width, 0),
				Vector2(-0.8*width, -0.7*height)
			],
			"coords":[3,4,15,16],
		},
		"RIGHT":{
			"uvs":[
				Vector2(0,0),
				Vector2(0, -0.7*height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(-0.3*width, -height),
				Vector2(-width, 0),
				Vector2(-0.7*width, -height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-width, -0.7*height)
			],
			"coords":[0,7,8,13,14,20,23,24],
			},
		"FRONT":{
			"uvs":[
				 Vector2(0,0),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0,-0.7*height),
				Vector2(-0.3*width, -height)
			],
			"coords":[14,15,16,17,18,21,24,25]
		},
		"BACK":{
			"uvs":[
				Vector2(0,0),
				Vector2(-0.8*width, 0),
				Vector2(-0.95*width, 0),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.95*width, -0.7*height),
				Vector2(-0.8*width, -0.7*height),
				Vector2(0,-0.7*height)
			],
			"coords":[0,1,2,3,4,5,6,7]},
		"TOP":
			{ "uvs":[
				Vector2(-width, -0.8*height),
				Vector2(-0.95*width, -0.95*height),
				Vector2(-0.8*width, -height),
				Vector2(0, -height),
				Vector2(0, -0.9*height),
				Vector2(-0.75*width, -0.9*height),
				Vector2(-0.85*width, -0.85*height),
				Vector2(-0.9*width, -0.75*height),
				Vector2(-0.7*width, -0.7*height),
				Vector2(0, -0.7*height),
				Vector2(-width, 0),
				Vector2(-0.9*width, 0),
				Vector2(-0.7*width, 0),
				Vector2(-0.25*width, -0.25*height),
				Vector2(0,-0.3*height),
				Vector2(-0.1*width, 0),
				Vector2(-0.08*width, -0.08*height),
				Vector2(0, -0.1*height),
				Vector2(0,0),
				Vector2(-0.3*width, 0)
		],
		"coords":[4,5,6,7,8,9,10,11,12,13,16,17,18,19,20,21,22,23,24,25]},
		},
	"cube30":
		{"vertices" : [
			Vector3(0,0,1), #0
			Vector3(0.8,0,1), #1
			Vector3(0.95,0,0.95), #2
			Vector3(1,0,0.8), #3
			Vector3(1,0.7,0.8), #4
			Vector3(0.95,0.7,0.95), #5
			Vector3(0.8,0.7,1), #6
			Vector3(0,0.7,1),  #7
			Vector3(0,0.9,0.9), #8
			Vector3(0.75,0.9,0.9), #9 
			Vector3(0.85,0.9,0.85), #10 
			Vector3(0.9,0.9,0.75), #11 
			Vector3(0.7,1,0.7), #12
			Vector3(0,1,0.7), #13
			Vector3(0,0,0), #14
			Vector3(1,0,0), #15
			Vector3(1,0.7,0), #16
			Vector3(0.9,0.9,0), #17
			Vector3(0.7,1,0), #18
			Vector3(0.25,1,0.25), #19
			Vector3(0,1,0.3), #20
			Vector3(0.1,0.9,0), #21
			Vector3(0.08,0.9,0.08), #22
			Vector3(0,0.9,0.1), #23
			Vector3(0,0.7,0), #24
			Vector3(0.3,1,0), #25
		],
		"BOTTOM":
			{"uvs":[
				Vector2(0,-height),
				Vector2(-0.8*width, -height),
				Vector2(-0.95*width, -0.95*height),
				Vector2(-width, -0.8*height),
				Vector2(0,0),
				Vector2(-width, 0)
			],
			"coords":[0,1,2,3,14,15] 
			},
		"LEFT":{
			"uvs":[
				Vector2(0,0),
				Vector2(0, -0.7*height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(-0.3*width, -height),
				Vector2(-width, 0),
				Vector2(-0.7*width, -height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-width, -0.7*height)
			],
			"coords":[0,7,8,13,14,20,23,24],
		},
		"RIGHT":{
			"uvs":[
				Vector2(0,0),
				Vector2(0,-0.7*height),
				Vector2(-0.8*width, 0),
				Vector2(-0.8*width, -0.7*height)
			],
			"coords":[3,4,15,16],
			},
		"FRONT":{
			"uvs":[
				Vector2(0,0),
				Vector2(-0.8*width, 0),
				Vector2(-0.95*width, 0),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.95*width, -0.7*height),
				Vector2(-0.8*width, -0.7*height),
				Vector2(0,-0.7*height)
			],
			"coords":[0,1,2,3,4,5,6,7]
		},
		"BACK":{
			"uvs":[
				Vector2(0,0),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0,-0.7*height),
				Vector2(-0.3*width, -height)
			],
			"coords":[14,15,16,17,18,21,24,25]},
		"TOP":
			{ "uvs":[
				Vector2(-width, -0.8*height),
				Vector2(-0.95*width, -0.95*height),
				Vector2(-0.8*width, -height),
				Vector2(0, -height),
				Vector2(0, -0.9*height),
				Vector2(-0.75*width, -0.9*height),
				Vector2(-0.85*width, -0.85*height),
				Vector2(-0.9*width, -0.75*height),
				Vector2(-0.7*width, -0.7*height),
				Vector2(0, -0.7*height),
				Vector2(-width, 0),
				Vector2(-0.9*width, 0),
				Vector2(-0.7*width, 0),
				Vector2(-0.25*width, -0.25*height),
				Vector2(0,-0.3*height),
				Vector2(-0.1*width, 0),
				Vector2(-0.08*width, -0.08*height),
				Vector2(0, -0.1*height),
				Vector2(0,0),
				Vector2(-0.3*width, 0)
		],
		"coords":[4,5,6,7,8,9,10,11,12,13,16,17,18,19,20,21,22,23,24,25]},
		},
	"cube31":
		{"vertices" : [
			Vector3(1,0,1), #0
			Vector3(0.2,0,1), #1
			Vector3(0.05,0,0.95), #2
			Vector3(0,0,0.8), #3
			Vector3(0,0.7,0.8), #4
			Vector3(0.05,0.7,0.95), #5
			Vector3(0.2,0.7,1), #6
			Vector3(1,0.7,1),  #7
			Vector3(1,0.9,0.9), #8
			Vector3(0.25,0.9,0.9), #9 
			Vector3(0.15,0.9,0.85), #10 
			Vector3(0.1,0.9,0.75), #11 
			Vector3(0.3,1,0.7), #12
			Vector3(1,1,0.7), #13
			Vector3(1,0,0), #14
			Vector3(0,0,0), #15
			Vector3(0,0.7,0), #16
			Vector3(0.1,0.9,0), #17
			Vector3(0.3,1,0), #18
			Vector3(0.75,1,0.25), #19
			Vector3(1,1,0.3), #20
			Vector3(0.9,0.9,0), #21
			Vector3(0.92,0.9,0.08), #22
			Vector3(1,0.9,0.1), #23
			Vector3(1,0.7,0), #24
			Vector3(0.7,1,0), #25
		],
		"BOTTOM":
			{"uvs":[
				Vector2(0,-height),
				Vector2(-0.8*width, -height),
				Vector2(-0.95*width, -0.95*height),
				Vector2(-width, -0.8*height),
				Vector2(0,0),
				Vector2(-width, 0)
			],
			"coords":[0,1,2,3,14,15] 
			},
		"LEFT":{
			"uvs":[
				Vector2(0,0),
				Vector2(0,-0.7*height),
				Vector2(-0.8*width, 0),
				Vector2(-0.8*width, -0.7*height)
			],
			"coords":[3,4,15,16],
		},
		"RIGHT":{
			"uvs":[
				Vector2(0,0),
				Vector2(0, -0.7*height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(-0.3*width, -height),
				Vector2(-width, 0),
				Vector2(-0.7*width, -height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-width, -0.7*height)
			],
			"coords":[0,7,8,13,14,20,23,24],
			},
		"FRONT":{
			"uvs":[
				Vector2(0,0),
				Vector2(-0.8*width, 0),
				Vector2(-0.95*width, 0),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.95*width, -0.7*height),
				Vector2(-0.8*width, -0.7*height),
				Vector2(0,-0.7*height)
			],
			"coords":[0,1,2,3,4,5,6,7]
		},
		"BACK":{
			"uvs":[
				Vector2(0,0),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0,-0.7*height),
				Vector2(-0.3*width, -height)
			],
			"coords":[14,15,16,17,18,21,24,25]},
		"TOP":
			{ "uvs":[
			Vector2(-width, -0.8*height),
			Vector2(-0.95*width, -0.95*height),
			Vector2(-0.8*width, -height),
			Vector2(0, -height),
			Vector2(0, -0.9*height),
			Vector2(-0.75*width, -0.9*height),
			Vector2(-0.85*width, -0.85*height),
			Vector2(-0.9*width, -0.75*height),
			Vector2(-0.7*width, -0.7*height),
			Vector2(0, -0.7*height),
			Vector2(-width, 0),
			Vector2(-0.9*width, 0),
			Vector2(-0.7*width, 0),
			Vector2(-0.25*width, -0.25*height),
			Vector2(0,-0.3*height),
			Vector2(-0.1*width, 0),
			Vector2(-0.08*width, -0.08*height),
			Vector2(0, -0.1*height),
			Vector2(0,0),
			Vector2(-0.3*width, 0)
		],
		"coords":[4,5,6,7,8,9,10,11,12,13,16,17,18,19,20,21,22,23,24,25]},
		},
	"cube32":
		{"vertices" : [
			Vector3(0,0,0), #0
			Vector3(1,0,0), #1
			Vector3(1,1,0), #2
			Vector3(0,1,0), #3
			Vector3(0,0,1), #4
			Vector3(1,0,1), #5
			Vector3(1,0.7,1), #6
			Vector3(0.9,0.9,1),  #7
			Vector3(0.7,1,1), #8
			Vector3(0.3,1,1), #9 
			Vector3(0.1,0.9,1), #10 
			Vector3(0,0.7,1), #11 
			Vector3(0,0.9,0.9), #12
			Vector3(0,1,0.7), #13 
			Vector3(1,1,0.7), #14 
			Vector3(1,0.9,0.9), #15 
		],
		"BOTTOM":
			{"uvs":[
				Vector2(0, 0),
				Vector2(0, height),
				Vector2(width, height),
				Vector2(width, 0)
			],
			"coords":[0,1,4,5] 
			},
		"LEFT":{
			"uvs":[
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(0,0),
				Vector2(0,-0.7*height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(-0.3*width, -height)
			],
			"coords":[0,3,4,11,12,13],
		},
		"RIGHT":{
			"uvs":[
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(0,0),
				Vector2(0,-0.7*height),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -0.9*height)
			],
			"coords":[1,2,5,6,14,15],
			},
		"FRONT":{
			"uvs":[
				Vector2(0,0),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0,-0.7*height)
			],
			"coords":[4,5,6,7,8,9,10,11]
		},
		"BACK":{
			"uvs":[
				Vector2(0,0),
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(0,-height)
			],
			"coords":[0,1,2,3]},
		"TOP":
			{ "uvs":[
			 Vector2(-width, -height),
			Vector2(0,-height),
			Vector2(-width, 0),
			Vector2(-0.9*width, 0),
			Vector2(-0.7*width, 0),
			Vector2(-0.3*width, 0),
			Vector2(-0.1*width, 0),
			Vector2(0,0),
			Vector2(0,-0.1*height),
			Vector2(0,-0.3*height),
			Vector2(-width, -0.3*height),
			Vector2(-width, -0.1*height)
		],
		"coords":[2,3,6,7,8,9,10,11,12,13,14,15]},
		},
	"cube33":
		{"vertices" : [
			Vector3(0,0,1), #0
			Vector3(1,0,1), #1
			Vector3(1,1,1), #2
			Vector3(0,1,1), #3
			Vector3(0,0,0), #4
			Vector3(1,0,0), #5
			Vector3(1,0.7,0), #6
			Vector3(0.9,0.9,0),  #7
			Vector3(0.7,1,0), #8
			Vector3(0.3,1,0), #9 
			Vector3(0.1,0.9,0), #10 
			Vector3(0,0.7,0), #11 
			Vector3(0,0.9,0.1), #12
			Vector3(0,1,0.3), #13 
			Vector3(1,1,0.3), #14 
			Vector3(1,0.9,0.1), #15 
		],
		"BOTTOM":
			{"uvs":[
				Vector2(0, 0),
				Vector2(0, height),
				Vector2(width, height),
				Vector2(width, 0)
			],
			"coords":[0,1,4,5] 
			},
		"LEFT":{
			"uvs":[
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(0,0),
				Vector2(0,-0.7*height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(-0.3*width, -height)
			],
			"coords":[0,3,4,11,12,13],
		},
		"RIGHT":{
			"uvs":[
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(0,0),
				Vector2(0,-0.7*height),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -0.9*height)
			],
			"coords":[1,2,5,6,14,15],
			},
		"FRONT":{
			"uvs":[
				Vector2(0,0),
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(0,-height)
			],
			"coords":[0,1,2,3]
		},
		"BACK":{
			"uvs":[
				Vector2(0,0),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0,-0.7*height)
			],
			"coords":[4,5,6,7,8,9,10,11]},
		"TOP":
			{ "uvs":[
				Vector2(-width, -height),
				Vector2(0,-height),
				Vector2(-width, 0),
				Vector2(-0.9*width, 0),
				Vector2(-0.7*width, 0),
				Vector2(-0.3*width, 0),
				Vector2(-0.1*width, 0),
				Vector2(0,0),
				Vector2(0,-0.1*height),
				Vector2(0,-0.3*height),
				Vector2(-width, -0.3*height),
				Vector2(-width, -0.1*height)
		],
		"coords":[2,3,6,7,8,9,10,11,12,13,14,15]},
		},
	"cube34":
		{"vertices" : [
			Vector3(0,0,0), #0
			Vector3(0,0,1), #1
			Vector3(0,1,1), #2
			Vector3(0,1,0), #3
			Vector3(1,0,0), #4
			Vector3(1,0,1), #5
			Vector3(1,0.7,1), #6
			Vector3(1,0.9,0.9),  #7
			Vector3(1,1,0.7), #8
			Vector3(1,1,0.3), #9 
			Vector3(1,0.9,0.1), #10 
			Vector3(1,0.7,0), #11 
			Vector3(0.9,0.9,0), #12
			Vector3(0.7,1,0), #13 
			Vector3(0.7,1,1), #14 
			Vector3(0.9,0.9,1), #15 
		],
		"BOTTOM":
			{"uvs":[
				Vector2(0, 0),
				Vector2(0, height),
				Vector2(width, height),
				Vector2(width, 0)
			],
			"coords":[0,1,4,5] 
			},
		"LEFT":{
			"uvs":[
				Vector2(0,0),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0,-0.7*height)
			],
			"coords":[4,5,6,7,8,9,10,11],
		},
		"RIGHT":{
			"uvs":[
				Vector2(0,0),
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(0,-height)
			],
			"coords":[0,1,2,3],
			},
		"FRONT":{
			"uvs":[
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(0,0),
				Vector2(0,-0.7*height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(-0.3*width, -height)
			],
			"coords":[0,3,4,11,12,13]
		},
		"BACK":{
			"uvs":[
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(0,0),
				Vector2(0,-0.7*height),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -0.9*height)
			],
			"coords":[1,2,5,6,14,15]},
		"TOP":
			{ "uvs":[
				Vector2(-width, -height),
				Vector2(0,-height),
				Vector2(-width, 0),
				Vector2(-0.9*width, 0),
				Vector2(-0.7*width, 0),
				Vector2(-0.3*width, 0),
				Vector2(-0.1*width, 0),
				Vector2(0,0),
				Vector2(0,-0.1*height),
				Vector2(0,-0.3*height),
				Vector2(-width, -0.3*height),
				Vector2(-width, -0.1*height)
		],
		"coords":[2,3,6,7,8,9,10,11,12,13,14,15]},
		},
	"cube35":
		{"vertices" : [
			Vector3(1,0,0), #0
			Vector3(1,0,1), #1
			Vector3(1,1,1), #2
			Vector3(1,1,0), #3
			Vector3(0,0,0), #4
			Vector3(0,0,1), #5
			Vector3(0,0.7,1), #6
			Vector3(0,0.9,0.9),  #7
			Vector3(0,1,0.7), #8
			Vector3(0,1,0.3), #9 
			Vector3(0,0.9,0.1), #10 
			Vector3(0,0.7,0), #11 
			Vector3(0.1,0.9,0), #12
			Vector3(0.3,1,0), #13 
			Vector3(0.3,1,1), #14 
			Vector3(0.1,0.9,1), #15 
		],
		"BOTTOM":
			{"uvs":[
				Vector2(0, 0),
				Vector2(0, height),
				Vector2(width, height),
				Vector2(width, 0)
			],
			"coords":[0,1,4,5] 
			},
		"LEFT":{
			"uvs":[
				Vector2(0,0),
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(0,-height)
			],
			"coords":[0,1,2,3],
		},
		"RIGHT":{
			"uvs":[
				Vector2(0,0),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0,-0.7*height)
			],
			"coords":[4,5,6,7,8,9,10,11],
			},
		"FRONT":{
			"uvs":[
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(0,0),
				Vector2(0,-0.7*height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(-0.3*width, -height)
			],
			"coords":[0,3,4,11,12,13]
		},
		"BACK":{
			"uvs":[
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(0,0),
				Vector2(0,-0.7*height),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -0.9*height)
			],
			"coords":[1,2,5,6,14,15]},
		"TOP":
			{ "uvs":[
				Vector2(-width, -height),
				Vector2(0,-height),
				Vector2(-width, 0),
				Vector2(-0.9*width, 0),
				Vector2(-0.7*width, 0),
				Vector2(-0.3*width, 0),
				Vector2(-0.1*width, 0),
				Vector2(0,0),
				Vector2(0,-0.1*height),
				Vector2(0,-0.3*height),
				Vector2(-width, -0.3*height),
				Vector2(-width, -0.1*height)
		],
		"coords":[2,3,6,7,8,9,10,11,12,13,14,15]},
	},
	"cube36":
		{"vertices" : [
			Vector3(0,0,0), #0
			Vector3(1,0,0), #1
			Vector3(1,0.7,0), #2
			Vector3(0.9,0.9,0), #3
			Vector3(0.7,1,0), #4
			Vector3(0.3,1,0), #5
			Vector3(0.1,0.9,0), #6
			Vector3(0,0.7,0), #7
			Vector3(0,0.9,0.1), #8
			Vector3(0,1,0.3), #9 
			Vector3(1,1,0.3), #10 
			Vector3(1,0.9,0.1), #11 
			Vector3(0,0,1), #12
			Vector3(1,0,1), #13 
			Vector3(1,0.7,1), #14 
			Vector3(0.9,0.9,1), #15 
			Vector3(0.7,1,1), #16
			Vector3(0.3,1,1), #17 
			Vector3(0.1,0.9,1), #18 
			Vector3(0,0.7,1), #19 
			Vector3(0,0.9,0.9), #20 
			Vector3(0,1,0.7), #21 
			Vector3(1,1,0.7), #22 
			Vector3(1,0.9,0.9) #23
		],
		"BOTTOM":
			{"uvs":[
				Vector2(0, 0),
				Vector2(-width, 0),
				Vector2(0, -height),
				Vector2(-width, -height)
			],
			"coords":[0,1,12,13] 
			},
		"LEFT":{
			"uvs":[
				Vector2(0,0),
				Vector2(0,-0.7*height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(-0.3*width, -height),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height)
			],
			"coords":[0,7,8,9,12,19,20,21],
		},
		"RIGHT":{
			"uvs":[
				Vector2(-width, 0 ),
				Vector2(-width, -0.7*height),
				Vector2(-0.7*width, -height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(0,0),
				Vector2(0,-0.7*height),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -height)
			],
			"coords":[1,2,10,11,13,14,22,23],
			},
		"FRONT":{
			"uvs":[
				Vector2(0,0),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0,-0.7*height)
			],
			"coords":[12,13,14,15,16,17,18,19]
		},
		"BACK":{
			"uvs":[
				Vector2(0,0),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0,-0.7*height)
			],
			"coords":[0,1,2,3,4,5,6,7]},
		"TOP":
			{ "uvs":[
				Vector2(-width, -height),
				Vector2(-0.9*width, -height),
				Vector2(-0.7*width, -height),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -height),
				Vector2(0,-height),
				Vector2(0, -0.9*height),
				Vector2(0,-0.7*height),
				Vector2(-width, -0.7*height),
				Vector2(-width, -0.9*height),
				Vector2(-width, 0),
				Vector2(-0.9*width, 0),
				Vector2(-0.7*width, 0),
				Vector2(-0.3*width, 0),
				Vector2(-0.1*width, 0),
				Vector2(0,0),
				Vector2(0,-0.1*height),
				Vector2(0,-0.3*height),
				Vector2(-width, -0.3*height),
				Vector2(-width, -0.1*height)
		],
		"coords":[2,3,4,5,6,7,8,9,10,11,14,15,16,17,18,19,20,21,22,23]},
		},
	"cube37":
		{"vertices" : [
			Vector3(0,0,0), #0
			Vector3(1,0,0), #1
			Vector3(1,0.7,0), #2
			Vector3(0.9,0.9,0), #3
			Vector3(0.7,1,0), #4
			Vector3(0.3,1,0), #5
			Vector3(0.1,0.9,0), #6
			Vector3(0,0.7,0),  #7
			Vector3(0,0.9,0.1), #8
			Vector3(0,1,0.3), #9 
			Vector3(1,1,0.3), #10 
			Vector3(1,0.9,0.1), #11 
			Vector3(0,0,1), #12
			Vector3(1,0,1), #13
			Vector3(1,1,1), #14
			Vector3(0.3,1,1), #15
			Vector3(0.1,0.9,1), #16
			Vector3(0,0.7,1), #17
			Vector3(0,0.9,0.9), #18
			Vector3(0,1,0.7), #19
		],
		"BOTTOM":
			{"uvs":[
				Vector2(0, 0),
				Vector2(-width, 0),
				Vector2(0, -height),
				Vector2(-width, -height)
			],
			"coords":[0, 1,12,13] 
			},
		"LEFT":{
			"uvs":[
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height),
				Vector2(0,0),
				Vector2(0,-0.7*height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(-0.3*width, -height)
			],
			"coords":[0,7,8,9,12,17,18,19],
		},
		"RIGHT":{
			"uvs":[
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-width*0.7, -height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(0,0),
				Vector2(0,-height)

			],
			"coords":[1,2,10,11,13,14],
			},
		"FRONT":{
			"uvs":[
				Vector2(0,0),
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0, -0.7*height)
			],
			"coords":[12,13,14,15,16,17]
		},
		"BACK":{
			"uvs":[
				Vector2(0,0),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0, -0.7*height)
			],
			"coords":[0,1,2,3,4,5,6,7]},
		"TOP":
			{ "uvs":[
				Vector2(-width, -height),
				Vector2(-0.9*width, -height),
				Vector2(-0.7*width, -height),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -height),
				Vector2(0,-height),
				Vector2(0,-0.9*height),
				Vector2(0, -0.7*height),
				Vector2(-width, -0.7*height),
				Vector2(-width, -0.9*height),
				Vector2(-width, 0),
				Vector2(-0.3*width, 0),
				Vector2(-0.1*width, 0),
				Vector2(0,0),
				Vector2(0,-0.1*height),
				Vector2(0,-0.3*height)
		],
		"coords":[2,3,4,5,6,7,8,9,10,11,14,15,16,17,18,19]},
		},
	"cube38":
		{"vertices" : [
			Vector3(1,0,0), #0
			Vector3(0,0,0), #1
			Vector3(0,0.7,0), #2
			Vector3(0.1,0.9,0), #3
			Vector3(0.3,1,0), #4
			Vector3(0.7,1,0), #5
			Vector3(0.9,0.9,0), #6
			Vector3(1,0.7,0),  #7
			Vector3(1,0.9,0.1), #8
			Vector3(1,1,0.3), #9 
			Vector3(0,1,0.3), #10 
			Vector3(0,0.9,0.1), #11 
			Vector3(1,0,1), #12
			Vector3(0,0,1), #13
			Vector3(0,1,1), #14
			Vector3(0.7,1,1), #15
			Vector3(0.9,0.9,1), #16
			Vector3(1,0.7,1), #17
			Vector3(1,0.9,0.9), #18
			Vector3(1,1,0.7), #19
		],
		"BOTTOM":
			{"uvs":[
				Vector2(0, 0),
				Vector2(-width, 0),
				Vector2(0, -height),
				Vector2(-width, -height)
			],
			"coords":[0, 1,12,13] 
			},
		"LEFT":{
			"uvs":[
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-width*0.7, -height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(0,0),
				Vector2(0,-height)
			],
			"coords":[1,2,10,11,13,14],
		},
		"RIGHT":{
			"uvs":[
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height),
				Vector2(0,0),
				Vector2(0,-0.7*height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(-0.3*width, -height)
			],
			"coords":[0,7,8,9,12,17,18,19],
			},
		"FRONT":{
			"uvs":[
				Vector2(0,0),
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0, -0.7*height)
			],
			"coords":[12,13,14,15,16,17]
		},
		"BACK":{
			"uvs":[
				Vector2(0,0),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0, -0.7*height)
			],
			"coords":[0,1,2,3,4,5,6,7]},
		"TOP":
			{ "uvs":[
				Vector2(-width, -height),
				Vector2(-0.9*width, -height),
				Vector2(-0.7*width, -height),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -height),
				Vector2(0,-height),
				Vector2(0,-0.9*height),
				Vector2(0, -0.7*height),
				Vector2(-width, -0.7*height),
				Vector2(-width, -0.9*height),
				Vector2(-width, 0),
				Vector2(-0.3*width, 0),
				Vector2(-0.1*width, 0),
				Vector2(0,0),
				Vector2(0,-0.1*height),
				Vector2(0,-0.3*height)
		],
		"coords":[2,3,4,5,6,7,8,9,10,11,14,15,16,17,18,19]},
		},
	"cube39":
		{"vertices" : [
			Vector3(1,0,0), #0
			Vector3(0,0,0), #1
			Vector3(0,0.7,0), #2
			Vector3(0.1,0.9,0), #3
			Vector3(0.3,1,0), #4
			Vector3(0.7,1,0), #5
			Vector3(0.9,0.9,0), #6
			Vector3(1,0.7,0),  #7
			Vector3(1,0.9,0.1), #8
			Vector3(1,1,0.3), #9 
			Vector3(0,1,0.3), #10 
			Vector3(0,0.9,0.1), #11 
			Vector3(1,0,1), #12
			Vector3(0,0,1), #13
			Vector3(0,1,1), #14
			Vector3(0.7,1,1), #15
			Vector3(0.9,0.9,1), #16
			Vector3(1,0.7,1), #17
			Vector3(1,0.9,0.9), #18
			Vector3(1,1,0.7), #19
		],
		"BOTTOM":
			{"uvs":[
				Vector2(0, 0),
				Vector2(-width, 0),
				Vector2(0, -height),
				Vector2(-width, -height)
			],
			"coords":[0, 1,12,13] 
			},
		"LEFT":{
			"uvs":[
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-width*0.7, -height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(0,0),
				Vector2(0,-height)
			],
			"coords":[1,2,10,11,13,14],
		},
		"RIGHT":{
			"uvs":[
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height),
				Vector2(0,0),
				Vector2(0,-0.7*height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(-0.3*width, -height)
			],
			"coords":[0,7,8,9,12,17,18,19],
			},
		"FRONT":{
			"uvs":[
				Vector2(0,0),
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0, -0.7*height)
			],
			"coords":[12,13,14,15,16,17]
		},
		"BACK":{
			"uvs":[
				Vector2(0,0),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0, -0.7*height)
			],
			"coords":[0,1,2,3,4,5,6,7]},
		"TOP":
			{ "uvs":[
				Vector2(-width, -height),
				Vector2(-0.9*width, -height),
				Vector2(-0.7*width, -height),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -height),
				Vector2(0,-height),
				Vector2(0,-0.9*height),
				Vector2(0, -0.7*height),
				Vector2(-width, -0.7*height),
				Vector2(-width, -0.9*height),
				Vector2(-width, 0),
				Vector2(-0.3*width, 0),
				Vector2(-0.1*width, 0),
				Vector2(0,0),
				Vector2(0,-0.1*height),
				Vector2(0,-0.3*height)
		],
		"coords":[2,3,4,5,6,7,8,9,10,11,14,15,16,17,18,19]},
		},
	"cube40":
		{"vertices" : [
			Vector3(0,0,1), #0
			Vector3(1,0,1), #1
			Vector3(1,0.7,1), #2
			Vector3(0.9,0.9,1), #3
			Vector3(0.7,1,1), #4
			Vector3(0.3,1,1), #5
			Vector3(0.1,0.9,1), #6
			Vector3(0,0.7,1),  #7
			Vector3(0,0.9,0.9), #8
			Vector3(0,1,0.7), #9 
			Vector3(1,1,0.7), #10 
			Vector3(1,0.9,0.9), #11 
			Vector3(0,0,0), #12
			Vector3(1,0,0), #13
			Vector3(1,1,0), #14
			Vector3(0.3,1,0), #15
			Vector3(0.1,0.9,0), #16
			Vector3(0,0.7,0), #17
			Vector3(0,0.9,0.1), #18
			Vector3(0,1,0.3), #19
		],
		"BOTTOM":
			{"uvs":[
				Vector2(0, 0),
				Vector2(-width, 0),
				Vector2(0, -height),
				Vector2(-width, -height)
			],
			"coords":[0, 1,12,13] 
			},
		"LEFT":{
			"uvs":[
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height),
				Vector2(0,0),
				Vector2(0,-0.7*height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(-0.3*width, -height)
			],
			"coords":[0,7,8,9,12,17,18,19],
		},
		"RIGHT":{
			"uvs":[
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-width*0.7, -height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(0,0),
				Vector2(0,-height)
			],
			"coords":[1,2,10,11,13,14],
			},
		"FRONT":{
			"uvs":[
				Vector2(0,0),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0, -0.7*height)
			],
			"coords":[0,1,2,3,4,5,6,7]
		},
		"BACK":{
			"uvs":[
				Vector2(0,0),
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0, -0.7*height)
			],
			"coords":[12,13,14,15,16,17]},
		"TOP":
			{ "uvs":[
				Vector2(-width, -height),
				Vector2(-0.9*width, -height),
				Vector2(-0.7*width, -height),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -height),
				Vector2(0,-height),
				Vector2(0,-0.9*height),
				Vector2(0, -0.7*height),
				Vector2(-width, -0.7*height),
				Vector2(-width, -0.9*height),
				Vector2(-width, 0),
				Vector2(-0.3*width, 0),
				Vector2(-0.1*width, 0),
				Vector2(0,0),
				Vector2(0,-0.1*height),
				Vector2(0,-0.3*height)
		],
		"coords":[2,3,4,5,6,7,8,9,10,11,14,15,16,17,18,19]},
	},
	"cube41":
		{"vertices" : [
			Vector3(0,0,0), #0
			Vector3(1,0,0), #1
			Vector3(1,0.7,0), #2
			Vector3(1,0.9,0.1), #3
			Vector3(1,1,0.3), #4
			Vector3(0,1,0.3), #5
			Vector3(0,0.9,0.1), #6
			Vector3(0,0.7,0),  #7
			Vector3(0,0,1), #8
			Vector3(1,0,1), #9 
			Vector3(1,0.7,1), #10 
			Vector3(0.9,0.9,1), #11 
			Vector3(0.7,1,1), #12
			Vector3(0.3,1,1), #13
			Vector3(0.1,0.9,1), #14
			Vector3(0,0.7,1), #15
			Vector3(0,0.9,0.9), #16
			Vector3(0,1,0.7), #17
			Vector3(1,1,0.7), #18
			Vector3(1,0.9,0.9), #19
		],
		"BOTTOM":
			{"uvs":[
				Vector2(0, 0),
				Vector2(-width, 0),
				Vector2(0, -height),
				Vector2(-width, -height)
			],
			"coords":[0,1,8,9] 
			},
		"LEFT":{
			"uvs":[
				Vector2(0, 0),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0, -0.7*height),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height)
			],
			"coords":[0,5,6,7,8,15,16,17],
		},
		"RIGHT":{
			"uvs":[
				Vector2(0,0),
				Vector2(0,-0.7*height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(-0.3*width, -height),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.7*width, -height),
				Vector2(-0.9*width, -0.9*height)
			],
			"coords":[1,2,3,4,9,10,18,19],
			},
		"FRONT":{
			"uvs":[
				Vector2(0,0),
				Vector2(-width,0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0,-0.7*height)
			],
			"coords":[8,9,10,11,12,13,14,15]
		},
		"BACK":{
			"uvs":[
				Vector2(0,0),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(0, -0.7*height)
			],
			"coords":[0,1,2,7]},
		"TOP":
			{ "uvs":[
				Vector2(-width, -height),
				Vector2(-width, -0.9*height),
				Vector2(-width, -0.7*height),
				Vector2(0, -0.7* height),
				Vector2(0, -0.9*height),
				Vector2(0, -height),
				Vector2(-width, 0),
				Vector2(-0.9*width, 0),
				Vector2(-0.7*width, 0),
				Vector2(-0.3*width, 0),
				Vector2(-0.1*width, 0),
				Vector2(0,0),
				Vector2(0, -0.1*height),
				Vector2(0, -0.3*height),
				Vector2(-width, -0.3*height),
				Vector2(-width, -0.1*height)
		],
		"coords":[2,3,4,5,6,7,10,11,12,13,14,15,16,17,18,19]},
	},
	"cube42":
		{"vertices" : [
			Vector3(0,0,1), #0
			Vector3(1,0,1), #1
			Vector3(1,0.7,1), #2
			Vector3(1,0.9,0.9), #3
			Vector3(1,1,0.7), #4
			Vector3(0,1,0.7), #5
			Vector3(0,0.9,0.9), #6
			Vector3(0,0.7,1),  #7
			Vector3(0,0,0), #8
			Vector3(1,0,0), #9 
			Vector3(1,0.7,0), #10 
			Vector3(0.9,0.9,0), #11 
			Vector3(0.7,1,0), #12
			Vector3(0.3,1,0), #13
			Vector3(0.1,0.9,0), #14
			Vector3(0,0.7,0), #15
			Vector3(0,0.9,0.1), #16
			Vector3(0,1,0.3), #17
			Vector3(1,1,0.3), #18
			Vector3(1,0.9,0.1), #19
		],
		"BOTTOM":
			{"uvs":[
				Vector2(0, 0),
				Vector2(-width, 0),
				Vector2(0, -height),
				Vector2(-width, -height)
			],
			"coords":[0,1,8,9] 
			},
		"LEFT":{
			"uvs":[
				Vector2(0, 0),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0, -0.7*height),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height)
			],
			"coords":[0,5,6,7,8,15,16,17],
		},
		"RIGHT":{
			"uvs":[
				Vector2(0,0),
				Vector2(0,-0.7*height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(-0.3*width, -height),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.7*width, -height),
				Vector2(-0.9*width, -0.9*height)
			],
			"coords":[1,2,3,4,9,10,18,19],
			},
		"FRONT":{
			"uvs":[
				Vector2(0,0),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(0, -0.7*height)
			],
			"coords":[0,1,2,7]
		},
		"BACK":{
			"uvs":[
				Vector2(0,0),
				Vector2(-width,0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0,-0.7*height)
			],
			"coords":[8,9,10,11,12,13,14,15]},
		"TOP":
			{ "uvs":[
				Vector2(-width, -height),
				Vector2(-width, -0.9*height),
				Vector2(-width, -0.7*height),
				Vector2(0, -0.7* height),
				Vector2(0, -0.9*height),
				Vector2(0, -height),
				Vector2(-width, 0),
				Vector2(-0.9*width, 0),
				Vector2(-0.7*width, 0),
				Vector2(-0.3*width, 0),
				Vector2(-0.1*width, 0),
				Vector2(0,0),
				Vector2(0, -0.1*height),
				Vector2(0, -0.3*height),
				Vector2(-width, -0.3*height),
				Vector2(-width, -0.1*height)
		],
		"coords":[2,3,4,5,6,7,10,11,12,13,14,15,16,17,18,19]},
		},
	"cube43":
		{"vertices" : [
			Vector3(1,0,0), #0
			Vector3(1,0,1), #1
			Vector3(1,0.7,1), #2
			Vector3(0.9,0.9,1), #3
			Vector3(0.7,1,1), #4
			Vector3(0.7,1,0), #5
			Vector3(0.9,0.9,0), #6
			Vector3(1,0.7,0),  #7
			Vector3(0,0,0), #8
			Vector3(0,0,1), #9 
			Vector3(0,0.7,1), #10 
			Vector3(0,0.9,0.9), #11 
			Vector3(0,1,0.7), #12
			Vector3(0,1,0.3), #13
			Vector3(0,0.9,0.1), #14
			Vector3(0,0.7,0), #15
			Vector3(0.1,0.9,0), #16
			Vector3(0.3,1,0), #17
			Vector3(0.3,1,1), #18
			Vector3(0.1,0.9,1), #19
		],
		"BOTTOM":
			{"uvs":[
				Vector2(0, 0),
				Vector2(-width, 0),
				Vector2(0, -height),
				Vector2(-width, -height)
			],
			"coords":[0,1,8,9] 
			},
		"LEFT":{
			"uvs":[
				Vector2(0,0),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(0, -0.7*height)
			],
			"coords":[0,1,2,7],
		},
		"RIGHT":{
			"uvs":[
				Vector2(0,0),
				Vector2(-width,0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0,-0.7*height)
			],
			"coords":[8,9,10,11,12,13,14,15],
			},
		"FRONT":{
			"uvs":[
				Vector2(0, 0),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0, -0.7*height),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height)
			],
			"coords":[0,5,6,7,8,15,16,17]
		},
		"BACK":{
			"uvs":[
				Vector2(0,0),
				Vector2(0,-0.7*height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(-0.3*width, -height),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.7*width, -height),
				Vector2(-0.9*width, -0.9*height)
			],
			"coords":[1,2,3,4,9,10,18,19]},
		"TOP":
			{ "uvs":[
				Vector2(-width, -height),
				Vector2(-width, -0.9*height),
				Vector2(-width, -0.7*height),
				Vector2(0, -0.7* height),
				Vector2(0, -0.9*height),
				Vector2(0, -height),
				Vector2(-width, 0),
				Vector2(-0.9*width, 0),
				Vector2(-0.7*width, 0),
				Vector2(-0.3*width, 0),
				Vector2(-0.1*width, 0),
				Vector2(0,0),
				Vector2(0, -0.1*height),
				Vector2(0, -0.3*height),
				Vector2(-width, -0.3*height),
				Vector2(-width, -0.1*height)
		],
		"coords":[2,3,4,5,6,7,10,11,12,13,14,15,16,17,18,19]},
	},
	"cube44":
		{"vertices" : [
			Vector3(0,0,0), #0
			Vector3(0,0,1), #1
			Vector3(0,0.7,1), #2
			Vector3(0.1,0.9,1), #3
			Vector3(0.3,1,1), #4
			Vector3(0.3,1,0), #5
			Vector3(0.1,0.9,0), #6
			Vector3(0,0.7,0),  #7
			Vector3(1,0,0), #8
			Vector3(1,0,1), #9 
			Vector3(1,0.7,1), #10 
			Vector3(1,0.9,0.9), #11 
			Vector3(1,1,0.7), #12
			Vector3(1,1,0.3), #13
			Vector3(1,0.9,0.1), #14
			Vector3(1,0.7,0), #15
			Vector3(0.9,0.9,0), #16
			Vector3(0.7,1,0), #17
			Vector3(0.7,1,1), #18
			Vector3(0.9,0.9,1), #19
		],
		"BOTTOM":
			{"uvs":[
				Vector2(0, 0),
				Vector2(-width, 0),
				Vector2(0, -height),
				Vector2(-width, -height)
			],
			"coords":[0,1,8,9] 
			},
		"LEFT":{
			"uvs":[
				Vector2(0,0),
				Vector2(-width,0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0,-0.7*height)
			],
			"coords":[8,9,10,11,12,13,14,15],
		},
		"RIGHT":{
			"uvs":[
				Vector2(0,0),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(0, -0.7*height)
			],
			"coords":[0,1,2,7],
			},
		"FRONT":{
			"uvs":[
				Vector2(0, 0),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0, -0.7*height),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height)
			],
			"coords":[0,5,6,7,8,15,16,17]
		},
		"BACK":{
			"uvs":[
				Vector2(0,0),
				Vector2(0,-0.7*height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(-0.3*width, -height),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.7*width, -height),
				Vector2(-0.9*width, -0.9*height)
			],
			"coords":[1,2,3,4,9,10,18,19]},
		"TOP":
			{ "uvs":[
				Vector2(-width, -height),
				Vector2(-width, -0.9*height),
				Vector2(-width, -0.7*height),
				Vector2(0, -0.7* height),
				Vector2(0, -0.9*height),
				Vector2(0, -height),
				Vector2(-width, 0),
				Vector2(-0.9*width, 0),
				Vector2(-0.7*width, 0),
				Vector2(-0.3*width, 0),
				Vector2(-0.1*width, 0),
				Vector2(0,0),
				Vector2(0, -0.1*height),
				Vector2(0, -0.3*height),
				Vector2(-width, -0.3*height),
				Vector2(-width, -0.1*height)
		],
		"coords":[2,3,4,5,6,7,10,11,12,13,14,15,16,17,18,19]},
	},
	"cube45":
		{"vertices" : [
			Vector3(0,0,0), #0
			Vector3(1,0,0), #1
			Vector3(1,0.7,0), #2
			Vector3(1,0.9,0.1), #3
			Vector3(1,1,0.3), #4
			Vector3(0,1,0.3), #5
			Vector3(0,0.9,0.1), #6
			Vector3(0,0.7,0),  #7
			Vector3(0,0,1), #8
			Vector3(1,0,1), #9 
			Vector3(1,1,1), #10 
			Vector3(0.3,1,1), #11 
			Vector3(0.1,0.9,1), #12
			Vector3(0,0.7,1), #13
			Vector3(0,0.9,0.9), #14
			Vector3(0,1,0.7), #15
		],
		"BOTTOM":
			{"uvs":[
				Vector2(0, 0),
				Vector2(-width, 0),
				Vector2(0, -height),
				Vector2(-width, -height)
			],
			"coords":[0, 1,8,9] 
			},
		"LEFT":{
			"uvs":[
				Vector2(0,0),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0,-0.7*height),
				Vector2(-width,0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height)
			],
			"coords":[0,5,6,7,8,13,14,15],
		},
		"RIGHT":{
			"uvs":[
				Vector2(0, 0),
				Vector2(0, -0.7*height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(-0.3*width, -height),
				Vector2(-width, 0),
				Vector2(-width, -height)
			],
			"coords":[1,2,3,4,9,10],
			},
		"FRONT":{
			"uvs":[
				Vector2(0, 0),
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(-0.3* width, -height),
				Vector2(-0.1* width,-0.9*height),
				Vector2(0, -0.7* height)
			],
			"coords":[8,9,10,11,12,13]
		},
		"BACK":{
			"uvs":[
				Vector2(0, 0),
				Vector2(-width,0),
				Vector2(-0.7*width,-0.7* height),
				Vector2(0, -0.7*height)
			],
			"coords":[0,1,2,7]},
		"TOP":
			{ "uvs":[
				Vector2(-width, -height),
				Vector2(-width, -0.9*height),
				Vector2(-width, -0.7*height),
				Vector2(0, -0.7*height),
				Vector2(0,-0.9*height),
				Vector2(0,-height),
				Vector2(-width, 0),
				Vector2(-0.3*width, 0),
				Vector2(-0.1*width, 0),
				Vector2(0,0),
				Vector2(0, -0.1*height),
				Vector2(0,-0.3*height)
		],
		"coords":[2,3,4,5,6,7,10,11,12,13,14,15]},
	},
	"cube46":
		{"vertices" : [
			Vector3(1,0,0), #0
			Vector3(0,0,0), #1
			Vector3(0,0.7,0), #2
			Vector3(0,0.9,0.1), #3
			Vector3(0,1,0.3), #4
			Vector3(1,1,0.3), #5
			Vector3(1,0.9,0.1), #6
			Vector3(1,0.7,0),  #7
			Vector3(1,0,1), #8
			Vector3(0,0,1), #9 
			Vector3(0,1,1), #10 
			Vector3(0.7,1,1), #11 
			Vector3(0.9,0.9,1), #12
			Vector3(1,0.7,1), #13
			Vector3(1,0.9,0.9), #14
			Vector3(1,1,0.7), #15
		],
		"BOTTOM":
			{"uvs":[
				Vector2(0, 0),
				Vector2(-width, 0),
				Vector2(0, -height),
				Vector2(-width, -height)
			],
			"coords":[0, 1,8,9] 
			},
		"LEFT":{
			"uvs":[
				Vector2(0, 0),
				Vector2(0, -0.7*height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(-0.3*width, -height),
				Vector2(-width, 0),
				Vector2(-width, -height)
			],
			"coords":[1,2,3,4,9,10],
		},
		"RIGHT":{
			"uvs":[
				Vector2(0,0),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0,-0.7*height),
				Vector2(-width,0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height)
			],
			"coords":[0,5,6,7,8,13,14,15],
			},
		"FRONT":{
			"uvs":[
				Vector2(0, 0),
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(-0.3* width, -height),
				Vector2(-0.1* width,-0.9*height),
				Vector2(0, -0.7* height)
			],
			"coords":[8,9,10,11,12,13]
		},
		"BACK":{
			"uvs":[
				Vector2(0, 0),
				Vector2(-width,0),
				Vector2(-0.7*width,-0.7* height),
				Vector2(0, -0.7*height)
			],
			"coords":[0,1,2,7]},
		"TOP":
			{ "uvs":[
				Vector2(-width, -height),
				Vector2(-width, -0.9*height),
				Vector2(-width, -0.7*height),
				Vector2(0, -0.7*height),
				Vector2(0,-0.9*height),
				Vector2(0,-height),
				Vector2(-width, 0),
				Vector2(-0.3*width, 0),
				Vector2(-0.1*width, 0),
				Vector2(0,0),
				Vector2(0, -0.1*height),
				Vector2(0,-0.3*height)
		],
		"coords":[2,3,4,5,6,7,10,11,12,13,14,15]},
	},
	"cube47":
		{"vertices" : [
			Vector3(0,0,0), #0
			Vector3(0,0,1), #1
			Vector3(0,0.7,1), #2
			Vector3(0.1,0.9,1), #3
			Vector3(0.3,1,1), #4
			Vector3(0.3,1,0), #5
			Vector3(0.1,0.9,0), #6
			Vector3(0,0.7,0),  #7
			Vector3(1,0,0), #8
			Vector3(1,0,1), #9 
			Vector3(1,1,1), #10 
			Vector3(1,1,0.3), #11 
			Vector3(1,0.9,0.1), #12
			Vector3(1,0.7,0), #13
			Vector3(0.9,0.9,0), #14
			Vector3(0.7,1,0), #15
		],
		"BOTTOM":
			{"uvs":[
				Vector2(0, 0),
				Vector2(-width, 0),
				Vector2(0, -height),
				Vector2(-width, -height)
			],
			"coords":[0, 1,8,9] 
			},
		"LEFT":{
			"uvs":[
				Vector2(0, 0),
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(-0.3* width, -height),
				Vector2(-0.1* width,-0.9*height),
				Vector2(0, -0.7* height)
			],
			"coords":[8,9,10,11,12,13],
		},
		"RIGHT":{
			"uvs":[
				Vector2(0, 0),
				Vector2(-width,0),
				Vector2(-0.7*width,-0.7* height),
				Vector2(0, -0.7*height)
			],
			"coords":[0,1,2,7],
			},
		"FRONT":{
			"uvs":[
				Vector2(0,0),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0,-0.7*height),
				Vector2(-width,0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height)
			],
			"coords":[0,5,6,7,8,13,14,15]
		},
		"BACK":{
			"uvs":[
				Vector2(0, 0),
				Vector2(0, -0.7*height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(-0.3*width, -height),
				Vector2(-width, 0),
				Vector2(-width, -height)
			],
			"coords":[1,2,3,4,9,10]},
		"TOP":
			{ "uvs":[
				Vector2(-width, -height),
				Vector2(-width, -0.9*height),
				Vector2(-width, -0.7*height),
				Vector2(0, -0.7*height),
				Vector2(0,-0.9*height),
				Vector2(0,-height),
				Vector2(-width, 0),
				Vector2(-0.3*width, 0),
				Vector2(-0.1*width, 0),
				Vector2(0,0),
				Vector2(0, -0.1*height),
				Vector2(0,-0.3*height)
		],
		"coords":[2,3,4,5,6,7,10,11,12,13,14,15]},
		},
	"cube48":
		{"vertices" : [
			Vector3(1,0,0), #0
			Vector3(1,0,1), #1
			Vector3(1,0.7,1), #2
			Vector3(0.9,0.9,1), #3
			Vector3(0.7,1,1), #4
			Vector3(0.7,1,0), #5
			Vector3(0.9,0.9,0), #6
			Vector3(1,0.7,0),  #7
			Vector3(0,0,0), #8
			Vector3(0,0,1), #9 
			Vector3(0,1,1), #10 
			Vector3(0,1,0.3), #11 
			Vector3(0,0.9,0.1), #12
			Vector3(0,0.7,0), #13
			Vector3(0.1,0.9,0), #14
			Vector3(0.3,1,0), #15
		],
		"BOTTOM":
			{"uvs":[
				Vector2(0, 0),
				Vector2(-width, 0),
				Vector2(0, -height),
				Vector2(-width, -height)
			],
			"coords":[0, 1,8,9] 
			},
		"LEFT":{
			"uvs":[
				Vector2(0, 0),
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(-0.3* width, -height),
				Vector2(-0.1* width,-0.9*height),
				Vector2(0, -0.7* height)
			],
			"coords":[8,9,10,11,12,13],
		},
		"RIGHT":{
			"uvs":[
				Vector2(0, 0),
				Vector2(-width,0),
				Vector2(-0.7*width,-0.7* height),
				Vector2(0, -0.7*height)
			],
			"coords":[0,1,2,7],
			},
		"FRONT":{
			"uvs":[
				Vector2(0, 0),
				Vector2(0, -0.7*height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(-0.3*width, -height),
				Vector2(-width, 0),
				Vector2(-width, -height)
			],
			"coords":[1,2,3,4,9,10]
		},
		"BACK":{
			"uvs":[
				Vector2(0,0),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0,-0.7*height),
				Vector2(-width,0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height)
			],
			"coords":[0,5,6,7,8,13,14,15]},
		"TOP":
			{ "uvs":[
				Vector2(-width, -height),
				Vector2(-width, -0.9*height),
				Vector2(-width, -0.7*height),
				Vector2(0, -0.7*height),
				Vector2(0,-0.9*height),
				Vector2(0,-height),
				Vector2(-width, 0),
				Vector2(-0.3*width, 0),
				Vector2(-0.1*width, 0),
				Vector2(0,0),
				Vector2(0, -0.1*height),
				Vector2(0,-0.3*height)
		],
		"coords":[2,3,4,5,6,7,10,11,12,13,14,15]},
		},
	"cube49":
		{"vertices" : [
			Vector3(0,0,1), #0
			Vector3(0,0,0), #1
			Vector3(0,0.7,0), #2
			Vector3(0.1,0.9,0), #3
			Vector3(0.3,1,0), #4
			Vector3(0.3,1,1), #5
			Vector3(0.1,0.9,1), #6
			Vector3(0,0.7,1),  #7
			Vector3(1,0,1), #8
			Vector3(1,0,0), #9 
			Vector3(1,1,0), #10 
			Vector3(1,1,0.7), #11 
			Vector3(1,0.9,0.9), #12
			Vector3(1,0.7,1), #13
			Vector3(0.9,0.9,1), #14
			Vector3(0.7,1,1), #15
		],
		"BOTTOM":
			{"uvs":[
				Vector2(0, 0),
				Vector2(0, height),
				Vector2(width, height),
				Vector2(width, 0)
			],
			"coords":[0, 1,8,9] 
			},
		"LEFT":{
			"uvs":[
				Vector2(-width, 0),
				Vector2(0, 0),
				Vector2(0, -0.7*height),
				Vector2(-width, -0.7*height)
			],
			"coords":[0,1,2,7],
		},
		"RIGHT":{
			"uvs":[
				Vector2(-width, 0),
				Vector2(0,0),
				Vector2(0, -height),
				Vector2(-0.7*width, -height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-width, -0.7*height)
			],
			"coords":[8,9,10,11,12,13],
			},
		"FRONT":{
			"uvs":[
				Vector2(0,0),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0,-0.7*height),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height)
			],
			"coords":[0,5,6,7,8,13,14,15]
		},
		"BACK":{
			"uvs":[
				Vector2(0,0),
				Vector2(0,-0.7*height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(-0.3*width, -height),
				Vector2(-width, 0),
				Vector2(-width, -height)
			],
			"coords":[1,2,3,4,9,10]},
		"TOP":
			{ "uvs":[
				Vector2(0,0),
				Vector2(-0.1*width, 0),
				Vector2(-0.3*width, 0),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -height),
				Vector2(0,-height),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-width, -0.9*height),
				Vector2(-width, -height),
				Vector2(-0.9*width, -height),
				Vector2(-0.7*width, -height)
		],
		"coords":[2,3,4,5,6,7,10,11,12,13,14,15]},
		},
	"cube50":
		{"vertices" : [
			Vector3(1,0,1), #0
			Vector3(1,0,0), #1
			Vector3(1,0.7,0), #2
			Vector3(0.9,0.9,0), #3
			Vector3(0.7,1,0), #4
			Vector3(0.7,1,1), #5
			Vector3(0.9,0.9,1), #6
			Vector3(1,0.7,1),  #7
			Vector3(0,0,1), #8
			Vector3(0,0,0), #9 
			Vector3(0,1,0), #10 
			Vector3(0,1,0.7), #11 
			Vector3(0,0.9,0.9), #12
			Vector3(0,0.7,1), #13
			Vector3(0.1,0.9,1), #14
			Vector3(0.3,1,1), #15
		],
		"BOTTOM":
			{"uvs":[
				Vector2(0, 0),
				Vector2(0, height),
				Vector2(width, height),
				Vector2(width, 0)
			],
			"coords":[0, 1,8,9] 
			},
		"LEFT":{
			"uvs":[
				Vector2(-width, 0),
				Vector2(0,0),
				Vector2(0, -height),
				Vector2(-0.7*width, -height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-width, -0.7*height)
			],
			"coords":[8,9,10,11,12,13],
		},
		"RIGHT":{
			"uvs":[
				Vector2(-width, 0),
				Vector2(0, 0),
				Vector2(0, -0.7*height),
				Vector2(-width, -0.7*height)
			],
			"coords":[0,1,2,7],
			},
		"FRONT":{
			"uvs":[
				Vector2(0,0),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0,-0.7*height),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height)
			],
			"coords":[0,5,6,7,8,13,14,15]
		},
		"BACK":{
			"uvs":[
				Vector2(0,0),
				Vector2(0,-0.7*height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(-0.3*width, -height),
				Vector2(-width, 0),
				Vector2(-width, -height)
			],
			"coords":[1,2,3,4,9,10]},
		"TOP":
			{ "uvs":[
				Vector2(0,0),
				Vector2(-0.1*width, 0),
				Vector2(-0.3*width, 0),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -height),
				Vector2(0,-height),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-width, -0.9*height),
				Vector2(-width, -height),
				Vector2(-0.9*width, -height),
				Vector2(-0.7*width, -height)
		],
		"coords":[2,3,4,5,6,7,10,11,12,13,14,15]},
		},
	"cube51":
		{"vertices" : [
			Vector3(1,0,1), #0
			Vector3(0,0,1), #1
			Vector3(0,0.7,1), #2
			Vector3(0,0.9,0.9), #3
			Vector3(0,1,0.7), #4
			Vector3(1,1,0.7), #5
			Vector3(1,0.9,0.9), #6
			Vector3(1,0.7,1),  #7
			Vector3(1,0,0), #8
			Vector3(0,0,0), #9 
			Vector3(0,1,0), #10 
			Vector3(0.7,1,0), #11 
			Vector3(0.9,0.9,0), #12
			Vector3(1,0.7,0), #13
			Vector3(1,0.9,0.1), #14
			Vector3(1,1,0.3) #15
		],
		"BOTTOM":
			{"uvs":[
				Vector2(0, 0),
				Vector2(0, height),
				Vector2(width, height),
				Vector2(width, 0)
			],
			"coords":[0, 1,8,9] 
			},
		"LEFT":{
			"uvs":[
				Vector2(0,0),
				Vector2(0,-0.7*height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(-0.3*width, -height),
				Vector2(-width, 0),
				Vector2(-width, -height)
			],
			"coords":[1,2,3,4,9,10],
		},
		"RIGHT":{
			"uvs":[
				Vector2(0,0),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0,-0.7*height),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height)
			],
			"coords":[0,5,6,7,8,13,14,15],
			},
		"FRONT":{
			"uvs":[
				Vector2(-width, 0),
				Vector2(0, 0),
				Vector2(0, -0.7*height),
				Vector2(-width, -0.7*height)
			],
			"coords":[0,1,2,7]
		},
		"BACK":{
			"uvs":[
				Vector2(-width, 0),
				Vector2(0,0),
				Vector2(0, -height),
				Vector2(-0.7*width, -height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-width, -0.7*height)
			],
			"coords":[8,9,10,11,12,13]},
		"TOP":
			{ "uvs":[
				Vector2(0,0),
				Vector2(-0.1*width, 0),
				Vector2(-0.3*width, 0),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -height),
				Vector2(0,-height),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-width, -0.9*height),
				Vector2(-width, -height),
				Vector2(-0.9*width, -height),
				Vector2(-0.7*width, -height)
		],
		"coords":[2,3,4,5,6,7,10,11,12,13,14,15]},
	},
	"cube52":
		{"vertices" : [
			Vector3(0,0,1), #0
			Vector3(1,0,1), #1
			Vector3(1,0.7,1), #2
			Vector3(1,0.9,0.9), #3
			Vector3(1,1,0.7), #4
			Vector3(0,1,0.7), #5
			Vector3(0,0.9,0.9), #6
			Vector3(0,0.7,1),  #7
			Vector3(0,0,0), #8
			Vector3(1,0,0), #9 
			Vector3(1,1,0), #10 
			Vector3(0.3,1,0), #11 
			Vector3(0.1,0.9,0), #12
			Vector3(0,0.7,0), #13
			Vector3(0,0.9,0.1), #14
			Vector3(0,1,0.3), #15
		],
		"BOTTOM":
			{"uvs":[
				Vector2(0, 0),
				Vector2(0, height),
				Vector2(width, height),
				Vector2(width, 0)
			],
			"coords":[0, 1,8,9] 
			},
		"LEFT":{
			"uvs":[
				Vector2(0,0),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0,-0.7*height),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-0.7*width, -height)
			],
			"coords":[0,5,6,7,8,13,14,15],
		},
		"RIGHT":{
			"uvs":[
				Vector2(0,0),
				Vector2(0,-0.7*height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(-0.3*width, -height),
				Vector2(-width, 0),
				Vector2(-width, -height)
			],
			"coords":[1,2,3,4,9,10],
			},
		"FRONT":{
			"uvs":[
				Vector2(-width, 0),
				Vector2(0, 0),
				Vector2(0, -0.7*height),
				Vector2(-width, -0.7*height)
			],
			"coords":[0,1,2,7]
		},
		"BACK":{
			"uvs":[
				Vector2(-width, 0),
				Vector2(0,0),
				Vector2(0, -height),
				Vector2(-0.7*width, -height),
				Vector2(-0.9*width, -0.9*height),
				Vector2(-width, -0.7*height)
			],
			"coords":[8,9,10,11,12,13]},
		"TOP":
			{ "uvs":[
				Vector2(0,0),
				Vector2(-0.1*width, 0),
				Vector2(-0.3*width, 0),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -height),
				Vector2(0,-height),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height),
				Vector2(-width, -0.9*height),
				Vector2(-width, -height),
				Vector2(-0.9*width, -height),
				Vector2(-0.7*width, -height)
		],
		"coords":[2,3,4,5,6,7,10,11,12,13,14,15]},
	},
	"fillcube1":
		{"vertices" : [
			Vector3(0,0,0), #0
			Vector3(1,0,0), #1
			Vector3(1, 1, 0), #2
			Vector3(0, 1, 0), #3
			Vector3(0,0,1), #4
			Vector3(1,0,1), #5
			Vector3(1,1,1), #6
			Vector3(0.3, 1,1),  #7
			Vector3(0.1,0.9,1), #8
			Vector3(0,0.7,1), #9 
			Vector3(0,0.9,0.9), #10 
			Vector3(0,1,0.7), #11 
		],
		"BOTTOM":
			{"uvs":[
				Vector2(0, 0),
				Vector2(-width, 0),
				Vector2(0, -height),
				Vector2(-width, -height)
			],
			"coords":[0,1,4,5] 
			},
		"LEFT":{
			"uvs":[
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(0,0),
				Vector2(0,-0.7*height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(-0.3*width, -height)
			],
			"coords":[0,3, 4, 9, 10, 11],
		},
		"RIGHT":{
			"uvs":[
				Vector2(0, 0),
				Vector2(0, -height * 0.7),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height)
			],
			"coords":[1,2,5,6],
			},
		"FRONT":{
			"uvs":[
				Vector2(0, 0),
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0,-0.7*height)
			],
			"coords":[4,5,6,7,8,9]
		},
		"BACK":{
			"uvs":[
				Vector2(0,0),
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(0,-height)
			],
			"coords":[0,1,2,3]},
		"TOP":
			{ "uvs":[
				Vector2(-width, -height),
				Vector2(0,-height),
				Vector2(-width, 0),
				Vector2(-0.3*width, 0),
				Vector2(-0.1*width, 0),
				Vector2(0,0),
				Vector2(0,-0.1*height),
				Vector2(0,-0.3*height) 
		],
		"coords":[2, 3, 6, 7, 8, 9, 10, 11]},
	},
	"fillcube2":
		{"vertices" : [
			Vector3(1,0,0), #0
			Vector3(0,0,0), #1
			Vector3(0, 1, 0), #2
			Vector3(1, 1, 0), #3
			Vector3(1,0,1), #4
			Vector3(0,0,1), #5
			Vector3(0,1,1), #6
			Vector3(0.7, 1,1),  #7
			Vector3(0.9,0.9,1), #8
			Vector3(1,0.7,1), #9 
			Vector3(1,0.9,0.9), #10 
			Vector3(1,1,0.7), #11 
		],
		"BOTTOM":
			{"uvs":[
				Vector2(0, 0),
				Vector2(-width, 0),
				Vector2(0, -height),
				Vector2(-width, -height)
			],
			"coords":[0,1,4,5] 
			},
		"LEFT":{
			"uvs":[
				Vector2(0, 0),
				Vector2(0, -height * 0.7),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height)
			],
			"coords":[1,2,5,6],
		},
		"RIGHT":{
			"uvs":[
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(0,0),
				Vector2(0,-0.7*height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(-0.3*width, -height)
			],
			"coords":[0,3, 4, 9, 10, 11],
			},
		"FRONT":{
			"uvs":[
				Vector2(0, 0),
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0,-0.7*height)
			],
			"coords":[4,5,6,7,8,9]
		},
		"BACK":{
			"uvs":[
				Vector2(0,0),
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(0,-height)
			],
			"coords":[0,1,2,3]},
		"TOP":
			{ "uvs":[
				Vector2(-width, -height),
				Vector2(0,-height),
				Vector2(-width, 0),
				Vector2(-0.3*width, 0),
				Vector2(-0.1*width, 0),
				Vector2(0,0),
				Vector2(0,-0.1*height),
				Vector2(0,-0.3*height) 
		],
		"coords":[2, 3, 6, 7, 8, 9, 10, 11]},
		},
	"fillcube3":
		{"vertices" : [
			Vector3(0,0,1), #0
			Vector3(1,0,1), #1
			Vector3(1, 1, 1), #2
			Vector3(0, 1, 1), #3
			Vector3(0,0,0), #4
			Vector3(1,0,0), #5
			Vector3(1,1,0), #6
			Vector3(0.3, 1,0),  #7
			Vector3(0.1,0.9,0), #8
			Vector3(0,0.7,0), #9 
			Vector3(0,0.9,0.1), #10 
			Vector3(0,1,0.3), #11 
		],
		"BOTTOM":
			{"uvs":[
				Vector2(0, 0),
				Vector2(-width, 0),
				Vector2(0, -height),
				Vector2(-width, -height)
			],
			"coords":[0,1,4,5] 
			},
		"LEFT":{
			"uvs":[
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(0,0),
				Vector2(0,-0.7*height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(-0.3*width, -height)
			],
			"coords":[0,3, 4, 9, 10, 11],
		},
		"RIGHT":{
			"uvs":[
				Vector2(0, 0),
				Vector2(0, -height * 0.7),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height)
			],
			"coords":[1,2,5,6],
			},
		"FRONT":{
			"uvs":[
				Vector2(0,0),
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(0,-height)
			],
			"coords":[0,1,2,3]
		},
		"BACK":{
			"uvs":[
				Vector2(0, 0),
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0,-0.7*height)
			],
			"coords":[4,5,6,7,8,9]},
		"TOP":
			{ "uvs":[
				Vector2(-width, -height),
				Vector2(0,-height),
				Vector2(-width, 0),
				Vector2(-0.3*width, 0),
				Vector2(-0.1*width, 0),
				Vector2(0,0),
				Vector2(0,-0.1*height),
				Vector2(0,-0.3*height) 
		],
		"coords":[2, 3, 6, 7, 8, 9, 10, 11]},
		},
	"fillcube4":
		{"vertices" : [
			Vector3(1,0,1), #0
			Vector3(0,0,1), #1
			Vector3(0, 1, 1), #2
			Vector3(1, 1, 1), #3
			Vector3(1,0,0), #4
			Vector3(0,0,0), #5
			Vector3(0,1,0), #6
			Vector3(0.7, 1,0),  #7
			Vector3(0.9,0.9,0), #8
			Vector3(1,0.7,0), #9 
			Vector3(1,0.9,0.1), #10 
			Vector3(1,1,0.3), #11 
		],
		"BOTTOM":
			{"uvs":[
				Vector2(0, 0),
				Vector2(-width, 0),
				Vector2(0, -height),
				Vector2(-width, -height)
			],
			"coords":[0,1,4,5] 
			},
		"LEFT":{
			"uvs":[
				Vector2(0, 0),
				Vector2(0, -height * 0.7),
				Vector2(-width, 0),
				Vector2(-width, -0.7*height)
			],
			"coords":[1,2,5,6],
		},
		"RIGHT":{
			"uvs":[
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(0,0),
				Vector2(0,-0.7*height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(-0.3*width, -height)
			],
			"coords":[0,3, 4, 9, 10, 11],
			},
		"FRONT":{
			"uvs":[
				Vector2(0,0),
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(0,-height)
			],
			"coords":[0,1,2,3]
		},
		"BACK":{
			"uvs":[
				Vector2(0, 0),
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(-0.3*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0,-0.7*height)
			],
			"coords":[4,5,6,7,8,9]},
		"TOP":
			{ "uvs":[
				Vector2(-width, -height),
				Vector2(0,-height),
				Vector2(-width, 0),
				Vector2(-0.3*width, 0),
				Vector2(-0.1*width, 0),
				Vector2(0,0),
				Vector2(0,-0.1*height),
				Vector2(0,-0.3*height) 
		],
		"coords":[2, 3, 6, 7, 8, 9, 10, 11]},
		},
	"fillcube5":
		{"vertices" : [
			Vector3(0, 0, 0), #0
			Vector3(1, 0, 0), #1
			Vector3(1, 1, 0), #2
			Vector3(0,1,0), #3
			Vector3(0,0,1), #4
			Vector3(1,0,1), #5
			Vector3(1,1,1), #6
			Vector3(0.2, 1, 1),  #7
			Vector3(0.1, 0.9, 1), #8
			Vector3(0,0.7,1), #9 
			Vector3(0.05,0.9,0.95), #10 
			Vector3(0.05,1,0.95), #11 
			Vector3(0,0.9,0.9), #12
			Vector3(0,1,0.8), #13 
		],
		"BOTTOM":
			{"uvs":[
				Vector2(0, 0),
				Vector2(-width, 0),
				Vector2(0, -height),
				Vector2(-width, -height)
			],
			"coords":[0,1,4,5] 
			},
		"LEFT":{
			"uvs":[
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(0,0),
				Vector2(0,-0.7*height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(-0.3*width, -height)
			],
			"coords":[0,3,4,9,12,13],
		},
		"RIGHT":{
			"uvs":[
				Vector2(0, 0),
				Vector2(0, -height),
				Vector2(-width, 0),
				Vector2(-width, -height)
			],
			"coords":[1,2,5,6],
			},
		"FRONT":{
			"uvs":[
				Vector2(0,0),
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(-0.2*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0,-0.7*height),
				Vector2(-0.05*width, -0.9*height),
				Vector2(-0.05*width, -height),
				Vector2(0, -0.9*height),
				Vector2(0,-height)
			],
			"coords":[4,5,6,7,8,9,10,11,12,13]
		},
		"BACK":{
			"uvs":[
				Vector2(0, 0),
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(0, -height)
			],
			"coords":[0,1,2,3]},
		"TOP":
			{ "uvs":[
				Vector2(-width, -height),
				Vector2(0, -height),
				Vector2(-width, 0),
				Vector2(-0.2*width, 0),
				Vector2(-0.05*width, -0.05*height),
				Vector2(0, -0.2*height)
		],
		"coords":[2,3,6,7,11,13]},
		},
	"fillcube6":
		{"vertices" : [
			Vector3(1, 0, 0), #0
			Vector3(0, 0, 0), #1
			Vector3(0, 1, 0), #2
			Vector3(1,1,0), #3
			Vector3(1,0,1), #4
			Vector3(0,0,1), #5
			Vector3(0,1,1), #6
			Vector3(0.8, 1, 1),  #7
			Vector3(0.9, 0.9, 1), #8
			Vector3(1,0.7,1), #9 
			Vector3(0.95,0.9,0.95), #10 
			Vector3(0.95,1,0.95), #11 
			Vector3(1,0.9,0.9), #12
			Vector3(1,1,0.8), #13 
		],
		"BOTTOM":
			{"uvs":[
				Vector2(0, 0),
				Vector2(-width, 0),
				Vector2(0, -height),
				Vector2(-width, -height)
			],
			"coords":[0,1,4,5] 
			},
		"LEFT":{
			"uvs":[
				Vector2(0, 0),
				Vector2(0, -height),
				Vector2(-width, 0),
				Vector2(-width, -height)
			],
			"coords":[1,2,5,6],
		},
		"RIGHT":{
			"uvs":[
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(0,0),
				Vector2(0,-0.7*height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(-0.3*width, -height)
			],
			"coords":[0,3,4,9,12,13],
			},
		"FRONT":{
			"uvs":[
				Vector2(0,0),
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(-0.2*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0,-0.7*height),
				Vector2(-0.05*width, -0.9*height),
				Vector2(-0.05*width, -height),
				Vector2(0, -0.9*height),
				Vector2(0,-height)
			],
			"coords":[4,5,6,7,8,9,10,11,12,13]
		},
		"BACK":{
			"uvs":[
				Vector2(0, 0),
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(0, -height)
			],
			"coords":[0,1,2,3]},
		"TOP":
			{ "uvs":[
				Vector2(-width, -height),
				Vector2(0, -height),
				Vector2(-width, 0),
				Vector2(-0.2*width, 0),
				Vector2(-0.05*width, -0.05*height),
				Vector2(0, -0.2*height)
		],
		"coords":[2,3,6,7,11,13]},
		},
	"fillcube7":
		{"vertices" : [
			Vector3(1, 0, 1), #0
			Vector3(0, 0, 1), #1
			Vector3(0, 1, 1), #2
			Vector3(1,1,1), #3
			Vector3(1,0,0), #4
			Vector3(0,0,0), #5
			Vector3(0,1,0), #6
			Vector3(0.8, 1, 0),  #7
			Vector3(0.9, 0.9,0), #8
			Vector3(1,0.7,0), #9 
			Vector3(0.95,0.9,0.05), #10 
			Vector3(0.95,1,0.05), #11 
			Vector3(1,0.9,0.1), #12
			Vector3(1,1,0.2), #13 
		],
		"BOTTOM":
			{"uvs":[
				Vector2(0, 0),
				Vector2(-width, 0),
				Vector2(0, -height),
				Vector2(-width, -height)
			],
			"coords":[0,1,4,5] 
			},
		"LEFT":{
			"uvs":[
				Vector2(0, 0),
				Vector2(0, -height),
				Vector2(-width, 0),
				Vector2(-width, -height)
			],
			"coords":[1,2,5,6],
		},
		"RIGHT":{
			"uvs":[
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(0,0),
				Vector2(0,-0.7*height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(-0.3*width, -height)
			],
			"coords":[0,3,4,9,12,13],
			},
		"FRONT":{
			"uvs":[
				Vector2(0, 0),
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(0, -height)
			],
			"coords":[0,1,2,3]
		},
		"BACK":{
			"uvs":[
				Vector2(0,0),
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(-0.2*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0,-0.7*height),
				Vector2(-0.05*width, -0.9*height),
				Vector2(-0.05*width, -height),
				Vector2(0, -0.9*height),
				Vector2(0,-height)
			],
			"coords":[4,5,6,7,8,9,10,11,12,13]},
		"TOP":
			{ "uvs":[
				Vector2(-width, -height),
				Vector2(0, -height),
				Vector2(-width, 0),
				Vector2(-0.2*width, 0),
				Vector2(-0.05*width, -0.05*height),
				Vector2(0, -0.2*height)
		],
		"coords":[2,3,6,7,11,13]},
		},
	"fillcube8":
		{"vertices" : [
			Vector3(0, 0, 1), #0
			Vector3(1, 0, 1), #1
			Vector3(1, 1, 1), #2
			Vector3(0,1,1), #3
			Vector3(0,0,0), #4
			Vector3(1,0,0), #5
			Vector3(1,1,0), #6
			Vector3(0.2, 1, 0),  #7
			Vector3(0.1, 0.9, 0), #8
			Vector3(0,0.7,0), #9 
			Vector3(0.05,0.9,0.05), #10 
			Vector3(0.05,1,0.05), #11 
			Vector3(0,0.9,0.1), #12
			Vector3(0,1,0.2), #13 
		],
		"BOTTOM":
			{"uvs":[
				Vector2(0, 0),
				Vector2(-width, 0),
				Vector2(0, -height),
				Vector2(-width, -height)
			],
			"coords":[0,1,4,5] 
			},
		"LEFT":{
			"uvs":[
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(0,0),
				Vector2(0,-0.7*height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(-0.3*width, -height)
			],
			"coords":[0,3,4,9,12,13],
		},
		"RIGHT":{
			"uvs":[
				Vector2(0, 0),
				Vector2(0, -height),
				Vector2(-width, 0),
				Vector2(-width, -height)
			],
			"coords":[1,2,5,6],
			},
		"FRONT":{
			"uvs":[
				Vector2(0, 0),
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(0, -height)
			],
			"coords":[0,1,2,3]
		},
		"BACK":{
			"uvs":[
				Vector2(0,0),
				Vector2(-width, 0),
				Vector2(-width, -height),
				Vector2(-0.2*width, -height),
				Vector2(-0.1*width, -0.9*height),
				Vector2(0,-0.7*height),
				Vector2(-0.05*width, -0.9*height),
				Vector2(-0.05*width, -height),
				Vector2(0, -0.9*height),
				Vector2(0,-height)
			],
			"coords":[4,5,6,7,8,9,10,11,12,13]},
		"TOP":
			{ "uvs":[
				Vector2(-width, -height),
				Vector2(0, -height),
				Vector2(-width, 0),
				Vector2(-0.2*width, 0),
				Vector2(-0.05*width, -0.05*height),
				Vector2(0, -0.2*height)
		],
		"coords":[2,3,6,7,11,13]},
		},
	"default":
		{"vertices" : [
			Vector3(0, 0, 0), #0
			Vector3(1, 0, 0), #1
			Vector3(0, 1, 0), #2
			Vector3(1, 1, 0), #3
			Vector3(0, 0, 1), #4
			Vector3(1, 0, 1), #5
			Vector3(0, 1, 1), #6
			Vector3(1, 1, 1)  #7
		],
		"BOTTOM":
			{"uvs":[
				Vector2(0, 0),
				Vector2(-width,0),
				Vector2(0, -height),
				Vector2(-width, -height),
			],
			"coords":[0, 1, 4, 5] 
			},
		"LEFT":{
			"uvs":[
				Vector2(0, 0),
				Vector2(0, -height),
				Vector2(-width, 0),
				Vector2(-width, -height),
			],
			"coords":[0, 2, 4, 6],
		},
		"RIGHT":{
			"uvs":[
				Vector2(0, 0),
				Vector2(0, -height),
				Vector2(-width, 0),
				Vector2(-width, -height),
			],
			"coords":[1, 3, 5, 7],
			},
		"FRONT":{
			"uvs":[
				Vector2(0, 0),
				Vector2(-width, 0),
				Vector2(0, -height),
				Vector2(-width, -height),
			],
			"coords":[4, 5, 6, 7]
		},
		"BACK":{
			"uvs":[
				Vector2(0, 0),
				Vector2(-width,0),
				Vector2(0, -height),
				Vector2(-width, -height),
			],
			"coords":[0, 1, 2, 3]},
		"TOP":
			{ "uvs":[
				Vector2(0, 0),
				Vector2(-width, 0),
				Vector2(0, -height),
				Vector2(-width, -height),
		],
		"coords":[2, 3, 6, 7]},
		}
	}

	var c = self
	var chunk_pos = self.translation;
	var block_y = y
	var chunk_type = self
	var block_info = Global.types[block]
	
	rng.randomize(); 
	var plant_number = rng.randi_range(3,4)
	
	
	rng.randomize(); 
	var r_side = rng.randi_range(0, 2)
	var sides = [Global.SIDE1, Global.SIDE2, Global.SIDE3, Global.SIDE4, Global.SIDE5]
	
	var side = sides[r_side]; 
	
	
	
	if check_transparent(chunk_pos.x+1, block_y, chunk_pos.z) && check_transparent(chunk_pos.x-1, block_y, chunk_pos.z) && check_transparent(chunk_pos.x,block_y+1,chunk_pos.z) && check_transparent(chunk_pos.x, block_y, chunk_pos.z+1) && \
		check_transparent(chunk_pos.x, block_y, chunk_pos.z-1) && !check_transparent(chunk_pos.x,block_y-1,chunk_pos.z):
		create_faces("cube17", "TOP",block_data["cube17"]["vertices"],block_data["cube17"]["TOP"]["coords"],block_data["cube17"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("cube17","BOTTOM", block_data["cube17"]["vertices"],block_data["cube17"]["BOTTOM"]["coords"],block_data["cube17"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("cube17", "FRONT",block_data["cube17"]["vertices"],block_data["cube17"]["FRONT"]["coords"],block_data["cube17"]["FRONT"]["uvs"],x, y, z, block_info[side])
		create_faces("cube17", "RIGHT", block_data["cube17"]["vertices"],block_data["cube17"]["RIGHT"]["coords"],block_data["cube17"]["RIGHT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube17", "LEFT", block_data["cube17"]["vertices"],block_data["cube17"]["LEFT"]["coords"],block_data["cube17"]["LEFT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube17", "BACK", block_data["cube17"]["vertices"],block_data["cube17"]["BACK"]["coords"],block_data["cube17"]["BACK"]["uvs"], x, y, z, block_info[side])
			
		for e in range(0,plant_number+2):
			for i in range(0,plant_number):
				#block17
				create_grass1(0.3, 0.3, -0.6, 0, 0.2, plant_number, LEAF, e,i,x,y,z, block_info[leaf])  
				rand_grass()
				create_grass1(0.5, 0.1, -0.7, -0.22, -0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(0.1, 0.5, -0.88, -0.22, 0.15, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(0.1, 0.5, -0.23, -0.21, 0.15, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(0.3, 0.1, -0.6, -0.21, 0.65, plant_number, LEAF, e,i,x,y,z, block_info[leaf])
				rand_grass()

				create_grass2(0.7, 0.1, -0.77, -0.1, 0.9, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass2(0.1, 0.7, -0.12, -0.1, 0.22, plant_number, LEAF, e,i,x,y,z, block_info[leaf])
				rand_grass()
				create_grass2(0.1, 0.7, -0.95, -0.1, 0.2, plant_number, LEAF, e,i,x,y,z, block_info[leaf])
				rand_grass()
				create_grass2(0.7, 0.1, -0.78, -0.1, 0, plant_number, LEAF, e,i,x,y,z, block_info[leaf])
				
	elif !check_transparent(chunk_pos.x+1,block_y,chunk_pos.z) && !check_transparent(chunk_pos.x-1,block_y,chunk_pos.z) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z+1) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z-1) &&\
	check_transparent(chunk_pos.x,block_y+1,chunk_pos.z) && check_transparent(chunk_pos.x+1,block_y,chunk_pos.z+1) && check_transparent(chunk_pos.x+1,block_y,chunk_pos.z-1) && check_transparent(chunk_pos.x-1,block_y,chunk_pos.z+1) && \
	check_transparent(chunk_pos.x-1,block_y,chunk_pos.z-1): 
		create_faces("cube36","BOTTOM", block_data["cube36"]["vertices"],block_data["cube36"]["BOTTOM"]["coords"],block_data["cube36"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("cube36", "FRONT", block_data["cube36"]["vertices"],block_data["cube36"]["FRONT"]["coords"],block_data["cube36"]["FRONT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube36", "BACK", block_data["cube36"]["vertices"],block_data["cube36"]["BACK"]["coords"],block_data["cube36"]["BACK"]["uvs"], x, y, z, block_info[side])
		create_faces("cube36", "TOP", block_data["cube36"]["vertices"],block_data["cube36"]["TOP"]["coords"],block_data["cube36"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("cube36", "LEFT", block_data["cube36"]["vertices"],block_data["cube36"]["LEFT"]["coords"],block_data["cube36"]["LEFT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube36", "RIGHT", block_data["cube36"]["vertices"],block_data["cube36"]["RIGHT"]["coords"],block_data["cube36"]["RIGHT"]["uvs"], x, y, z, block_info[side]) 
		
		for e in range(0,plant_number+2):
			for i in range(0,plant_number):
				#block36
				create_grass1(0.4, 1, -0.68, 0, -0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf])  
				rand_grass()
				create_grass1(0.3, 0.3, -0.38, 0, 0.2, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(0.3, 0.3, -0.92, 0, 0.2, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 

				rand_grass()
				create_fill_grass(0.1, 0.1, 0.05, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(0.1, 0.15, 0.1, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(-0.05, 0.25, 0.1, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(0.12, 0.22, 0.22, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass(0, 0.22, 0.1, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass(0, 0.25, 0.1, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass(0.1, 0.22, 0.1, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass(0.15, 0.15, 0.1, LEAF,x,y,z, block_info[leaf])
				rand_grass()

				create_fill_grass2(0.15, 0.15, -0.05, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.12, 0.22, -0.08, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.05, 0.25, -0.15, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0, 0.25, -0.05, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.1, 0.25, -0.25, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.78, 0.22, -0.8, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.6, 0.22, -0.92, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.1, 0.22, -0.8, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.1, 0.25, -0.95, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.1, 0.25, -0.7, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.05, 0.25, -0.6, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.6, 0.22, -0.92, LEAF,x,y,z, block_info[leaf])

				rand_grass()
				create_fill_grass2(-0.78, 0.22, -0.25, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.78, 0.22, -0.15, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.57, 0.22, -0.05, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.45, 0.25, -0.05, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.8, 0.05, 0.95, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(-0.75, 0.15, 0.9, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(-0.7, 0.25, 0.85, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(-0.7, 0.22, 0.95, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.75, 0.15, 0.08, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.8, 0.1, 0.08, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.78, 0.2, 0.17, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.63, 0.2, 0.05, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.63, 0.25, 0.05, LEAF,x, y, z, block_info[leaf])
				
				
	elif !check_transparent(chunk_pos.x+1,block_y,chunk_pos.z) && !check_transparent(chunk_pos.x-1,block_y,chunk_pos.z) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z+1) && \
	!check_transparent(chunk_pos.x,block_y,chunk_pos.z-1) && !check_transparent(chunk_pos.x+1,block_y,chunk_pos.z+1) && check_transparent(chunk_pos.x-1,block_y,chunk_pos.z-1) && \
	check_transparent(chunk_pos.x-1,block_y,chunk_pos.z+1) && check_transparent(chunk_pos.x+1, block_y, chunk_pos.z-1) && check_transparent(chunk_pos.x,block_y+1,chunk_pos.z):
		create_faces("cube37","BOTTOM", block_data["cube37"]["vertices"],block_data["cube37"]["BOTTOM"]["coords"],block_data["cube37"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("cube37", "FRONT", block_data["cube37"]["vertices"],block_data["cube37"]["FRONT"]["coords"],block_data["cube37"]["FRONT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube37", "BACK", block_data["cube37"]["vertices"],block_data["cube37"]["BACK"]["coords"],block_data["cube37"]["BACK"]["uvs"], x, y, z, block_info[side])
		create_faces("cube37", "TOP", block_data["cube37"]["vertices"],block_data["cube37"]["TOP"]["coords"],block_data["cube37"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("cube37", "LEFT", block_data["cube37"]["vertices"],block_data["cube37"]["LEFT"]["coords"],block_data["cube37"]["LEFT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube37", "RIGHT", block_data["cube37"]["vertices"],block_data["cube37"]["RIGHT"]["coords"],block_data["cube37"]["RIGHT"]["uvs"], x, y, z, block_info[side])

		for e in range(0,plant_number+2):
				for i in range(0,plant_number):
					#block37
					rand_grass()
					create_grass1(0.7, 0.7, -0.64, 0, 0.13, plant_number, LEAF, e,i,x,y,z, block_info[leaf])  
					rand_grass()
					create_grass1(0.3, 0.3, -0.64, 0, -0.08, plant_number, LEAF, e,i,x,y,z, block_info[leaf])  
					rand_grass()
					create_grass1(0.3, 0.3, -0.9, 0, 0.2, plant_number, LEAF, e,i,x,y,z, block_info[leaf])  
					
					rand_grass()
					create_fill_grass(0.1, 0.1, 0.05, LEAF,x,y,z, block_info[leaf]) 
					rand_grass()
					create_fill_grass(0.1, 0.15, 0.1, LEAF,x,y,z, block_info[leaf]) 
					rand_grass()
					create_fill_grass(-0.05, 0.25, 0.1, LEAF,x,y,z, block_info[leaf]) 
					rand_grass()
					create_fill_grass(0.12, 0.22, 0.22, LEAF,x,y,z, block_info[leaf])
					rand_grass()
					create_fill_grass(0, 0.22, 0.1, LEAF,x,y,z, block_info[leaf])
					rand_grass()
					create_fill_grass(0, 0.25, 0.1, LEAF,x,y,z, block_info[leaf])
					rand_grass()
					create_fill_grass(0.1, 0.22, 0.1, LEAF,x,y,z, block_info[leaf])
					rand_grass()
					create_fill_grass(0.15, 0.15, 0.1, LEAF,x,y,z, block_info[leaf])
					

					rand_grass()
					create_fill_grass2(-0.78, 0.22, -0.25, LEAF,x,y,z, block_info[leaf])
					rand_grass()
					create_fill_grass2(-0.78, 0.22, -0.15, LEAF,x,y,z, block_info[leaf])
					rand_grass()
					create_fill_grass2(-0.57, 0.22, -0.05, LEAF,x,y,z, block_info[leaf])
					rand_grass()
					create_fill_grass2(-0.45, 0.25, -0.05, LEAF,x,y,z, block_info[leaf])
					rand_grass()
					create_fill_grass(-0.8, 0.05, 0.95, LEAF,x,y,z, block_info[leaf]) 
					rand_grass()
					create_fill_grass(-0.75, 0.15, 0.9, LEAF,x,y,z, block_info[leaf]) 
					rand_grass()
					create_fill_grass(-0.7, 0.25, 0.85, LEAF,x,y,z, block_info[leaf]) 
					rand_grass()
					create_fill_grass(-0.7, 0.22, 0.95, LEAF,x,y,z, block_info[leaf])
					
					rand_grass()
					create_fill_grass(-0.75, 0.15, 0.08, LEAF,x, y, z, block_info[leaf])
					rand_grass()
					create_fill_grass(-0.8, 0.1, 0.08, LEAF,x, y, z, block_info[leaf])
					rand_grass()
					create_fill_grass(-0.78, 0.2, 0.17, LEAF,x, y, z, block_info[leaf])
					rand_grass()
					create_fill_grass(-0.63, 0.2, 0.05, LEAF,x, y, z, block_info[leaf])
					rand_grass()
					create_fill_grass(-0.63, 0.25, 0.05, LEAF,x, y, z, block_info[leaf])
					
	elif !check_transparent(chunk_pos.x+1,block_y,chunk_pos.z) && !check_transparent(chunk_pos.x-1,block_y,chunk_pos.z) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z+1) && \
	!check_transparent(chunk_pos.x,block_y,chunk_pos.z-1) && check_transparent(chunk_pos.x+1,block_y,chunk_pos.z+1) && check_transparent(chunk_pos.x-1,block_y,chunk_pos.z-1) && \
	!check_transparent(chunk_pos.x-1,block_y,chunk_pos.z+1) && check_transparent(chunk_pos.x+1, block_y, chunk_pos.z-1) && check_transparent(chunk_pos.x,block_y+1,chunk_pos.z):
		create_faces("cube38","BOTTOM", block_data["cube38"]["vertices"],block_data["cube38"]["BOTTOM"]["coords"],block_data["cube38"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("cube38", "FRONT", block_data["cube38"]["vertices"],block_data["cube38"]["FRONT"]["coords"],block_data["cube38"]["FRONT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube38", "BACK", block_data["cube38"]["vertices"],block_data["cube38"]["BACK"]["coords"],block_data["cube38"]["BACK"]["uvs"], x, y, z, block_info[side])
		create_faces("cube38", "TOP", block_data["cube38"]["vertices"],block_data["cube38"]["TOP"]["coords"],block_data["cube38"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("cube38", "LEFT", block_data["cube38"]["vertices"],block_data["cube38"]["LEFT"]["coords"],block_data["cube38"]["LEFT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube38", "RIGHT", block_data["cube38"]["vertices"],block_data["cube38"]["RIGHT"]["coords"],block_data["cube38"]["RIGHT"]["uvs"], x, y, z, block_info[side])
		
		for e in range(0,plant_number+2):
			for i in range(0,plant_number):
				#block38 
				rand_grass()
				create_grass1(0.7, 0.7, -0.9, 0, 0.13, plant_number, LEAF, e,i,x,y,z, block_info[leaf])  
				rand_grass()
				create_grass1(0.3, 0.3, -0.64, 0, -0.08, plant_number, LEAF, e,i,x,y,z, block_info[leaf])  
				rand_grass()
				create_grass1(0.3, 0.3, -0.35, 0, 0.2, plant_number, LEAF, e,i,x,y,z, block_info[leaf])  
				
				rand_grass()
				create_fill_grass(-0.75, 0.15, 0.08, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.8, 0.1, 0.08, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.78, 0.2, 0.17, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.63, 0.2, 0.05, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.63, 0.25, 0.05, LEAF,x, y, z, block_info[leaf])
				
				rand_grass()
				create_fill_grass(0.1, 0.1, 0.05, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(0.1, 0.15, 0.1, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(-0.05, 0.25, 0.1, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(0.12, 0.22, 0.22, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass(0, 0.22, 0.1, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass(0, 0.25, 0.1, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass(0.1, 0.22, 0.1, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass(0.15, 0.15, 0.1, LEAF,x,y,z, block_info[leaf])
				
				rand_grass()
				create_fill_grass2(0.15, 0.15, -0.05, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.12, 0.22, -0.08, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.05, 0.25, -0.15, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0, 0.25, -0.05, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.1, 0.25, -0.25, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.78, 0.22, -0.8, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.6, 0.22, -0.92, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.1, 0.22, -0.8, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.1, 0.25, -0.95, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.1, 0.25, -0.7, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.05, 0.25, -0.6, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.6, 0.22, -0.92, LEAF,x,y,z, block_info[leaf])

	elif !check_transparent(chunk_pos.x+1,block_y,chunk_pos.z) && !check_transparent(chunk_pos.x-1,block_y,chunk_pos.z) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z+1) && \
	!check_transparent(chunk_pos.x,block_y,chunk_pos.z-1) && check_transparent(chunk_pos.x+1,block_y,chunk_pos.z+1) && !check_transparent(chunk_pos.x-1,block_y,chunk_pos.z-1) && \
	check_transparent(chunk_pos.x-1,block_y,chunk_pos.z+1) && check_transparent(chunk_pos.x+1, block_y, chunk_pos.z-1) && check_transparent(chunk_pos.x,block_y+1,chunk_pos.z):
		create_faces("cube39","BOTTOM", block_data["cube39"]["vertices"],block_data["cube39"]["BOTTOM"]["coords"],block_data["cube39"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("cube39", "FRONT", block_data["cube39"]["vertices"],block_data["cube39"]["FRONT"]["coords"],block_data["cube39"]["FRONT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube39", "BACK", block_data["cube39"]["vertices"],block_data["cube39"]["BACK"]["coords"],block_data["cube39"]["BACK"]["uvs"], x, y, z, block_info[side])
		create_faces("cube39", "TOP", block_data["cube39"]["vertices"],block_data["cube39"]["TOP"]["coords"],block_data["cube39"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("cube39", "LEFT", block_data["cube39"]["vertices"],block_data["cube39"]["LEFT"]["coords"],block_data["cube39"]["LEFT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube39", "RIGHT", block_data["cube39"]["vertices"],block_data["cube39"]["RIGHT"]["coords"],block_data["cube39"]["RIGHT"]["uvs"], x, y, z, block_info[side])
		
		for e in range(0,plant_number+2):
					for i in range(0,plant_number):
						#block39
						rand_grass()
						create_grass1(0.7, 0.7, -0.9, 0, 0.13, plant_number, LEAF, e,i,x,y,z, block_info[leaf])  
						rand_grass()
						create_grass1(0.3, 0.3, -0.64, 0, -0.08, plant_number, LEAF, e,i,x,y,z, block_info[leaf])  
						rand_grass()
						create_grass1(0.3, 0.3, -0.35, 0, 0.2, plant_number, LEAF, e,i,x,y,z, block_info[leaf])  
						
						rand_grass()
						create_fill_grass(-0.75, 0.15, 0.08, LEAF,x, y, z, block_info[leaf])
						rand_grass()
						create_fill_grass(-0.8, 0.1, 0.08, LEAF,x, y, z, block_info[leaf])
						rand_grass()
						create_fill_grass(-0.78, 0.2, 0.17, LEAF,x, y, z, block_info[leaf])
						rand_grass()
						create_fill_grass(-0.63, 0.2, 0.05, LEAF,x, y, z, block_info[leaf])
						rand_grass()
						create_fill_grass(-0.63, 0.25, 0.05, LEAF,x, y, z, block_info[leaf])
						
						rand_grass()
						create_fill_grass(0.1, 0.1, 0.05, LEAF,x,y,z, block_info[leaf]) 
						rand_grass()
						create_fill_grass(0.1, 0.15, 0.1, LEAF,x,y,z, block_info[leaf]) 
						rand_grass()
						create_fill_grass(-0.05, 0.25, 0.1, LEAF,x,y,z, block_info[leaf]) 
						rand_grass()
						create_fill_grass(0.12, 0.22, 0.22, LEAF,x,y,z, block_info[leaf])
						rand_grass()
						create_fill_grass(0, 0.22, 0.1, LEAF,x,y,z, block_info[leaf])
						rand_grass()
						create_fill_grass(0, 0.25, 0.1, LEAF,x,y,z, block_info[leaf])
						rand_grass()
						create_fill_grass(0.1, 0.22, 0.1, LEAF,x,y,z, block_info[leaf])
						rand_grass()
						create_fill_grass(0.15, 0.15, 0.1, LEAF,x,y,z, block_info[leaf])
						
						rand_grass()
						create_fill_grass2(0.15, 0.15, -0.05, LEAF,x,y,z, block_info[leaf])
						rand_grass()
						create_fill_grass2(0.12, 0.22, -0.08, LEAF,x,y,z, block_info[leaf])
						rand_grass()
						create_fill_grass2(0.05, 0.25, -0.15, LEAF,x,y,z, block_info[leaf])
						rand_grass()
						create_fill_grass2(0, 0.25, -0.05, LEAF,x,y,z, block_info[leaf])
						rand_grass()
						create_fill_grass2(0.1, 0.25, -0.25, LEAF,x,y,z, block_info[leaf])
						rand_grass()
						create_fill_grass2(-0.78, 0.22, -0.8, LEAF,x,y,z, block_info[leaf])
						rand_grass()
						create_fill_grass2(-0.6, 0.22, -0.92, LEAF,x,y,z, block_info[leaf])
						rand_grass()
						create_fill_grass2(0.1, 0.22, -0.8, LEAF,x,y,z, block_info[leaf])
						rand_grass()
						create_fill_grass2(-0.1, 0.25, -0.95, LEAF,x,y,z, block_info[leaf])
						rand_grass()
						create_fill_grass2(0.1, 0.25, -0.7, LEAF,x,y,z, block_info[leaf])
						rand_grass()
						create_fill_grass2(0.05, 0.25, -0.6, LEAF,x,y,z, block_info[leaf])
						rand_grass()
						create_fill_grass2(-0.6, 0.22, -0.92, LEAF,x,y,z, block_info[leaf])
						
	elif !check_transparent(chunk_pos.x+1,block_y,chunk_pos.z) && !check_transparent(chunk_pos.x-1,block_y,chunk_pos.z) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z+1) && \
	!check_transparent(chunk_pos.x,block_y,chunk_pos.z-1) && check_transparent(chunk_pos.x+1,block_y,chunk_pos.z+1) && check_transparent(chunk_pos.x-1,block_y,chunk_pos.z-1) && \
	check_transparent(chunk_pos.x-1,block_y,chunk_pos.z+1) && !check_transparent(chunk_pos.x+1, block_y, chunk_pos.z-1) && check_transparent(chunk_pos.x,block_y+1,chunk_pos.z):
		create_faces("cube40","BOTTOM", block_data["cube40"]["vertices"],block_data["cube40"]["BOTTOM"]["coords"],block_data["cube40"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("cube40", "FRONT", block_data["cube40"]["vertices"],block_data["cube40"]["FRONT"]["coords"],block_data["cube40"]["FRONT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube40", "BACK", block_data["cube40"]["vertices"],block_data["cube40"]["BACK"]["coords"],block_data["cube40"]["BACK"]["uvs"], x, y, z, block_info[side])
		create_faces("cube40", "TOP", block_data["cube40"]["vertices"],block_data["cube40"]["TOP"]["coords"],block_data["cube40"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("cube40", "LEFT", block_data["cube40"]["vertices"],block_data["cube40"]["LEFT"]["coords"],block_data["cube40"]["LEFT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube40", "RIGHT", block_data["cube40"]["vertices"],block_data["cube40"]["RIGHT"]["coords"],block_data["cube40"]["RIGHT"]["uvs"], x, y, z, block_info[side])
		
		for e in range(0,plant_number+2):
			for i in range(0,plant_number):
				#block40 
				rand_grass()
				create_grass1(0.7, 0.7, -0.66, 0, -0.05, plant_number, LEAF, e,i,x,y,z, block_info[leaf])  
				rand_grass()
				create_grass1(0.3, 0.3, -0.85, 0, 0.18, plant_number, LEAF, e,i,x,y,z, block_info[leaf])  
				rand_grass()
				create_grass1(0.3, 0.3, -0.67, 0, 0.46, plant_number, LEAF, e,i,x,y,z, block_info[leaf])  
				
				rand_grass()
				create_fill_grass(-0.75, 0.15, 0.08, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.8, 0.1, 0.08, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.78, 0.2, 0.17, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.63, 0.2, 0.05, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.63, 0.25, 0.05, LEAF,x, y, z, block_info[leaf])
				
				rand_grass()
				create_fill_grass2(0.15, 0.15, -0.05, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.12, 0.22, -0.08, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.05, 0.25, -0.15, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0, 0.25, -0.05, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.1, 0.25, -0.25, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.78, 0.22, -0.8, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.6, 0.22, -0.92, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.1, 0.22, -0.8, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.1, 0.25, -0.95, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.1, 0.25, -0.7, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.05, 0.25, -0.6, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.6, 0.22, -0.92, LEAF,x,y,z, block_info[leaf])
#
				rand_grass()
				create_fill_grass2(-0.78, 0.22, -0.25, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.78, 0.22, -0.15, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.57, 0.22, -0.05, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.45, 0.25, -0.05, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.8, 0.05, 0.95, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(-0.75, 0.15, 0.9, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(-0.7, 0.25, 0.85, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(-0.7, 0.22, 0.95, LEAF,x,y,z, block_info[leaf])
				
	elif !check_transparent(chunk_pos.x+1,block_y,chunk_pos.z) && !check_transparent(chunk_pos.x-1,block_y,chunk_pos.z) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z+1) && \
	check_transparent(chunk_pos.x,block_y+1,chunk_pos.z) && check_transparent(chunk_pos.x,block_y,chunk_pos.z-1) && check_transparent(chunk_pos.x+1,block_y,chunk_pos.z+1) &&  \
	check_transparent(chunk_pos.x-1,block_y,chunk_pos.z+1):
		create_faces("cube41","BOTTOM", block_data["cube41"]["vertices"],block_data["cube41"]["BOTTOM"]["coords"],block_data["cube41"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("cube41", "FRONT", block_data["cube41"]["vertices"],block_data["cube41"]["FRONT"]["coords"],block_data["cube41"]["FRONT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube41", "BACK", block_data["cube41"]["vertices"],block_data["cube41"]["BACK"]["coords"],block_data["cube41"]["BACK"]["uvs"], x, y, z, block_info[side])
		create_faces("cube41", "TOP", block_data["cube41"]["vertices"],block_data["cube41"]["TOP"]["coords"],block_data["cube41"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("cube41", "LEFT", block_data["cube41"]["vertices"],block_data["cube41"]["LEFT"]["coords"],block_data["cube41"]["LEFT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube41", "RIGHT", block_data["cube41"]["vertices"],block_data["cube41"]["RIGHT"]["coords"],block_data["cube41"]["RIGHT"]["uvs"], x, y, z, block_info[side])

		for e in range(0,plant_number+2):
			for i in range(0,plant_number):
				#block41
				rand_grass()
				create_grass1(1, 0.3, -0.9, 0, 0.18, plant_number, LEAF, e,i,x,y,z, block_info[leaf])  

				rand_grass()
				create_grass1(0.3, 0.3, -0.65, 0, 0.45, plant_number, LEAF, e,i,x,y,z, block_info[leaf])  
				rand_grass()
				create_grass2(1, 0.2, -0.85, 0.2, 0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass2(1, 0.2, -0.85, 0.05, 0,plant_number, LEAF, e,i,x,y,z, block_info[leaf])
				rand_grass()
				create_grass1(1, 0.2, -0.85, -0.1, 0,plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				
				rand_grass()
				create_fill_grass2(0.15, 0.15, -0.05, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.12, 0.22, -0.08, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.05, 0.25, -0.15, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0, 0.25, -0.05, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.1, 0.25, -0.25, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.78, 0.22, -0.8, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.6, 0.22, -0.92, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.1, 0.22, -0.8, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.1, 0.25, -0.95, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.1, 0.25, -0.7, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.05, 0.25, -0.6, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.6, 0.22, -0.92, LEAF,x,y,z, block_info[leaf])
				
				rand_grass()
				create_fill_grass2(-0.78, 0.22, -0.25, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.78, 0.22, -0.15, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.57, 0.22, -0.05, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.45, 0.25, -0.05, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.8, 0.05, 0.95, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(-0.75, 0.15, 0.9, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(-0.7, 0.25, 0.85, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(-0.7, 0.22, 0.95, LEAF,x,y,z, block_info[leaf])
				
				
	elif !check_transparent(chunk_pos.x+1,block_y,chunk_pos.z) && !check_transparent(chunk_pos.x-1,block_y,chunk_pos.z) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z-1) && \
	check_transparent(chunk_pos.x,block_y+1,chunk_pos.z) && check_transparent(chunk_pos.x,block_y,chunk_pos.z+1) && check_transparent(chunk_pos.x+1,block_y,chunk_pos.z-1) &&  \
	check_transparent(chunk_pos.x-1,block_y,chunk_pos.z-1):
		create_faces("cube42","BOTTOM", block_data["cube42"]["vertices"],block_data["cube42"]["BOTTOM"]["coords"],block_data["cube42"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("cube42", "FRONT", block_data["cube42"]["vertices"],block_data["cube42"]["FRONT"]["coords"],block_data["cube42"]["FRONT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube42", "BACK", block_data["cube42"]["vertices"],block_data["cube42"]["BACK"]["coords"],block_data["cube42"]["BACK"]["uvs"], x, y, z, block_info[side])
		create_faces("cube42", "TOP", block_data["cube42"]["vertices"],block_data["cube42"]["TOP"]["coords"],block_data["cube42"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("cube42", "LEFT", block_data["cube42"]["vertices"],block_data["cube42"]["LEFT"]["coords"],block_data["cube42"]["LEFT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube42", "RIGHT", block_data["cube42"]["vertices"],block_data["cube42"]["RIGHT"]["coords"],block_data["cube42"]["RIGHT"]["uvs"], x, y, z, block_info[side])
	
		for e in range(0,plant_number+2):
			for i in range(0,plant_number):
				#block42
				rand_grass()
				create_grass1(1, 0.3, -0.9, 0, 0.18, plant_number, LEAF, e,i,x,y,z, block_info[leaf])  
				
				rand_grass()
				create_grass1(0.3, 0.3, -0.6, 0, -0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf])  
				rand_grass()
				create_grass2(1, 0.2, -0.85, 0.1, 0.7,plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass2(1, 0.2, -0.85, -0.05, 0.85,plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(1, 0.2,-0.8, -0.1, 0.3 ,plant_number, LEAF, e,i,x,y,z, block_info[leaf])

				rand_grass()
				create_fill_grass(-0.75, 0.15, 0.08, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.8, 0.1, 0.08, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.78, 0.2, 0.17, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.63, 0.2, 0.05, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.63, 0.25, 0.05, LEAF,x, y, z, block_info[leaf])

				rand_grass()
				create_fill_grass(0.1, 0.1, 0.05, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(0.1, 0.15, 0.1, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(-0.05, 0.25, 0.1, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(0.12, 0.22, 0.22, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass(0, 0.22, 0.1, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass(0, 0.25, 0.1, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass(0.1, 0.22, 0.1, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass(0.15, 0.15, 0.1, LEAF,x,y,z, block_info[leaf])
				
				
	elif !check_transparent(chunk_pos.x-1,block_y,chunk_pos.z) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z+1) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z-1) && \
	check_transparent(chunk_pos.x,block_y+1,chunk_pos.z) && check_transparent(chunk_pos.x+1,block_y,chunk_pos.z) && check_transparent(chunk_pos.x-1,block_y,chunk_pos.z-1) && \
	check_transparent(chunk_pos.x-1,block_y,chunk_pos.z+1): 
		create_faces("cube43","BOTTOM", block_data["cube43"]["vertices"],block_data["cube43"]["BOTTOM"]["coords"],block_data["cube43"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("cube43", "FRONT", block_data["cube43"]["vertices"],block_data["cube43"]["FRONT"]["coords"],block_data["cube43"]["FRONT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube43", "BACK", block_data["cube43"]["vertices"],block_data["cube43"]["BACK"]["coords"],block_data["cube43"]["BACK"]["uvs"], x, y, z, block_info[side])
		create_faces("cube43", "TOP", block_data["cube43"]["vertices"],block_data["cube43"]["TOP"]["coords"],block_data["cube43"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("cube43", "LEFT", block_data["cube43"]["vertices"],block_data["cube43"]["LEFT"]["coords"],block_data["cube43"]["LEFT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube43", "RIGHT", block_data["cube43"]["vertices"],block_data["cube43"]["RIGHT"]["coords"],block_data["cube43"]["RIGHT"]["uvs"], x, y, z, block_info[side]) 

		for e in range(0,plant_number+2):
			for i in range(0,plant_number):
				#block43
				rand_grass()
				create_grass1(0.3, 1, -0.7, 0, -0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf])  
				rand_grass()
				create_grass1(0.3, 0.3, -0.88, 0, 0.2, plant_number, LEAF, e,i,x,y,z, block_info[leaf])  
				
				rand_grass()
				create_grass2(0.2, 1, -0.15, -0.05, 0.05, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass2(0.2, 1, -0.24, 0.2, 0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				
				rand_grass()
				create_fill_grass(-0.75, 0.15, 0.08, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.8, 0.1, 0.08, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.78, 0.2, 0.17, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.63, 0.2, 0.05, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.63, 0.25, 0.05, LEAF,x, y, z, block_info[leaf])

				rand_grass()
				create_fill_grass2(-0.78, 0.22, -0.25, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.78, 0.22, -0.15, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.57, 0.22, -0.05, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.45, 0.25, -0.05, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.8, 0.05, 0.95, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(-0.75, 0.15, 0.9, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(-0.7, 0.25, 0.85, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(-0.7, 0.22, 0.95, LEAF,x,y,z, block_info[leaf])
				
	elif !check_transparent(chunk_pos.x+1,block_y,chunk_pos.z) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z-1) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z+1) && \
	check_transparent(chunk_pos.x,block_y+1,chunk_pos.z) && check_transparent(chunk_pos.x-1,block_y,chunk_pos.z) && check_transparent(chunk_pos.x+1,block_y,chunk_pos.z+1) && \
	check_transparent(chunk_pos.x+1,block_y,chunk_pos.z-1):
		create_faces("cube44","BOTTOM", block_data["cube44"]["vertices"],block_data["cube44"]["BOTTOM"]["coords"],block_data["cube44"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("cube44", "FRONT", block_data["cube44"]["vertices"],block_data["cube44"]["FRONT"]["coords"],block_data["cube44"]["FRONT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube44", "BACK", block_data["cube44"]["vertices"],block_data["cube44"]["BACK"]["coords"],block_data["cube44"]["BACK"]["uvs"], x, y, z, block_info[side])
		create_faces("cube44", "TOP", block_data["cube44"]["vertices"],block_data["cube44"]["TOP"]["coords"],block_data["cube44"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("cube44", "LEFT", block_data["cube44"]["vertices"],block_data["cube44"]["LEFT"]["coords"],block_data["cube44"]["LEFT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube44", "RIGHT", block_data["cube44"]["vertices"],block_data["cube44"]["RIGHT"]["coords"],block_data["cube44"]["RIGHT"]["uvs"], x, y, z, block_info[side])

		for e in range(0,plant_number+2):
			for i in range(0,plant_number):
				#block44
				rand_grass()
				create_grass1(0.3, 1, -0.65, 0, -0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf])
				rand_grass()
				create_grass1(0.3, 0.3, -0.4, 0, 0.2, plant_number, LEAF, e,i,x,y,z, block_info[leaf])  
				
				rand_grass()
				create_grass2(0.2, 1, -0.65, 0.2, 0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass2(0.2, 1, -0.85, 0.05, 0.1,plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(0.2, 1, -0.85, -0.1, -0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				
				rand_grass()
				create_fill_grass2(0.15, 0.15, -0.05, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.12, 0.22, -0.08, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.05, 0.25, -0.15, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0, 0.25, -0.05, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.1, 0.25, -0.25, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.78, 0.22, -0.8, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.6, 0.22, -0.92, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.1, 0.22, -0.8, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.1, 0.25, -0.95, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.1, 0.25, -0.7, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.05, 0.25, -0.6, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.6, 0.22, -0.92, LEAF,x,y,z, block_info[leaf])
				
				rand_grass()
				create_fill_grass(0.1, 0.1, 0.05, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(0.1, 0.15, 0.1, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(-0.05, 0.25, 0.1, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(0.12, 0.22, 0.22, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass(0, 0.22, 0.1, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass(0, 0.25, 0.1, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass(0.1, 0.22, 0.1, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass(0.15, 0.15, 0.1, LEAF,x,y,z, block_info[leaf])
				
	elif !check_transparent(chunk_pos.x,block_y,chunk_pos.z+1) && !check_transparent(chunk_pos.x-1,block_y,chunk_pos.z) && !check_transparent(chunk_pos.x+1,block_y,chunk_pos.z) && \
	check_transparent(chunk_pos.x,block_y,chunk_pos.z-1) && check_transparent(chunk_pos.x,block_y+1,chunk_pos.z) && !check_transparent(chunk_pos.x+1,block_y,chunk_pos.z+1) && \
	check_transparent(chunk_pos.x-1,block_y,chunk_pos.z+1):
		create_faces("cube45","BOTTOM", block_data["cube45"]["vertices"],block_data["cube45"]["BOTTOM"]["coords"],block_data["cube45"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("cube45", "FRONT", block_data["cube45"]["vertices"],block_data["cube45"]["FRONT"]["coords"],block_data["cube45"]["FRONT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube45", "BACK", block_data["cube45"]["vertices"],block_data["cube45"]["BACK"]["coords"],block_data["cube45"]["BACK"]["uvs"], x, y, z, block_info[side])
		create_faces("cube45", "TOP", block_data["cube45"]["vertices"],block_data["cube45"]["TOP"]["coords"],block_data["cube45"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("cube45", "LEFT", block_data["cube45"]["vertices"],block_data["cube45"]["LEFT"]["coords"],block_data["cube45"]["LEFT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube45", "RIGHT", block_data["cube45"]["vertices"],block_data["cube45"]["RIGHT"]["coords"],block_data["cube45"]["RIGHT"]["uvs"], x, y, z, block_info[side])	

		for e in range(0,plant_number+2):
			for i in range(0,plant_number):
				#block45
				rand_grass()
				create_grass1(1, 0.35, -0.88, 0, 0.2,plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(0.7, 0.3, -0.68, 0, 0.55,plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				
				rand_grass()
				create_grass2(1, 0.2, -0.88, 0.2, 0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass2(1, 0.2, -0.88, 0.05, 0,plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(1, 0.2, -0.88, -0.1, 0,plant_number, LEAF, e,i,x,y,z, block_info[leaf])
				
				rand_grass()
				create_fill_grass2(-0.78, 0.22, -0.25, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.78, 0.22, -0.15, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.57, 0.22, -0.05, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.45, 0.25, -0.05, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.8, 0.05, 0.95, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(-0.75, 0.15, 0.9, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(-0.7, 0.25, 0.85, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(-0.7, 0.22, 0.95, LEAF,x,y,z, block_info[leaf])
				
	elif !check_transparent(chunk_pos.x,block_y,chunk_pos.z+1) && check_transparent(chunk_pos.x,block_y,chunk_pos.z-1) && !check_transparent(chunk_pos.x+1,block_y,chunk_pos.z) && \
	!check_transparent(chunk_pos.x-1,block_y,chunk_pos.z+1) && !check_transparent(chunk_pos.x-1,block_y,chunk_pos.z) && check_transparent(chunk_pos.x,block_y+1,chunk_pos.z) && \
	check_transparent(chunk_pos.x+1,block_y,chunk_pos.z+1): 
		create_faces("cube46","BOTTOM", block_data["cube46"]["vertices"],block_data["cube46"]["BOTTOM"]["coords"],block_data["cube46"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("cube46", "FRONT", block_data["cube46"]["vertices"],block_data["cube46"]["FRONT"]["coords"],block_data["cube46"]["FRONT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube46", "BACK", block_data["cube46"]["vertices"],block_data["cube46"]["BACK"]["coords"],block_data["cube46"]["BACK"]["uvs"], x, y, z, block_info[side])
		create_faces("cube46", "TOP", block_data["cube46"]["vertices"],block_data["cube46"]["TOP"]["coords"],block_data["cube46"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("cube46", "LEFT", block_data["cube46"]["vertices"],block_data["cube46"]["LEFT"]["coords"],block_data["cube46"]["LEFT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube46", "RIGHT", block_data["cube46"]["vertices"],block_data["cube46"]["RIGHT"]["coords"],block_data["cube46"]["RIGHT"]["uvs"], x, y, z, block_info[side])

		for e in range(0,plant_number+2):
			for i in range(0,plant_number):
				#block46
				rand_grass()
				create_grass1(1, 0.7, -0.88, 0, 0.2, plant_number, LEAF, e,i,x,y,z, block_info[leaf])
				
				rand_grass()
				create_grass2(1, 0.2, -0.88, 0.2, 0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf])
				rand_grass()
				create_grass2(1, 0.7, -0.88, 0.3, 0.35,plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass2(1, 0.2, -0.88, 0.05, 0,plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(1, 0.2, -0.88, -0.1, 0,plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				
				rand_grass()
				create_fill_grass2(0.15, 0.15, -0.05, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.12, 0.22, -0.08, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.05, 0.25, -0.15, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0, 0.25, -0.05, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.1, 0.25, -0.25, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.78, 0.22, -0.8, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.6, 0.22, -0.92, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.1, 0.22, -0.8, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.1, 0.25, -0.95, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.1, 0.25, -0.7, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.05, 0.25, -0.6, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.6, 0.22, -0.92, LEAF,x,y,z, block_info[leaf])
				
				
	elif !check_transparent(chunk_pos.x+1,block_y,chunk_pos.z) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z+1) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z-1) && \
	check_transparent(chunk_pos.x-1,block_y,chunk_pos.z) && check_transparent(chunk_pos.x,block_y+1,chunk_pos.z) && !check_transparent(chunk_pos.x+1,block_y,chunk_pos.z+1) && \
	check_transparent(chunk_pos.x+1,block_y,chunk_pos.z-1):
		create_faces("cube47","BOTTOM", block_data["cube47"]["vertices"],block_data["cube47"]["BOTTOM"]["coords"],block_data["cube47"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("cube47", "FRONT", block_data["cube47"]["vertices"],block_data["cube47"]["FRONT"]["coords"],block_data["cube47"]["FRONT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube47", "BACK", block_data["cube47"]["vertices"],block_data["cube47"]["BACK"]["coords"],block_data["cube47"]["BACK"]["uvs"], x, y, z, block_info[side])
		create_faces("cube47", "TOP", block_data["cube47"]["vertices"],block_data["cube47"]["TOP"]["coords"],block_data["cube47"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("cube47", "LEFT", block_data["cube47"]["vertices"],block_data["cube47"]["LEFT"]["coords"],block_data["cube47"]["LEFT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube47", "RIGHT", block_data["cube47"]["vertices"],block_data["cube47"]["RIGHT"]["coords"],block_data["cube47"]["RIGHT"]["uvs"], x, y, z, block_info[side])

		for e in range(0,plant_number+2):
			for i in range(0,plant_number):
				#block47
				rand_grass()
				create_grass1(0.7, 1, -0.7, 0, -0.05, plant_number, LEAF, e,i,x,y,z, block_info[leaf])

				rand_grass()
				create_grass2(0.2, 1, -0.85, 0.2, 0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass2(0.2, 1, -1.05, 0.05, 0.1,plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(0.2, 1, -0.9, -0.1, -0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 

				rand_grass()
				create_fill_grass(0.1, 0.1, 0.05, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(0.1, 0.15, 0.1, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(-0.05, 0.25, 0.1, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(0.12, 0.22, 0.22, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass(0, 0.22, 0.1, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass(0, 0.25, 0.1, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass(0.1, 0.22, 0.1, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass(0.15, 0.15, 0.1, LEAF,x,y,z, block_info[leaf])
				
	elif !check_transparent(chunk_pos.x-1,block_y,chunk_pos.z) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z+1) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z-1) && \
	check_transparent(chunk_pos.x+1,block_y,chunk_pos.z) && check_transparent(chunk_pos.x,block_y+1,chunk_pos.z) && !check_transparent(chunk_pos.x-1,block_y,chunk_pos.z+1) && \
	check_transparent(chunk_pos.x-1,block_y,chunk_pos.z-1):
		create_faces("cube48","BOTTOM", block_data["cube48"]["vertices"],block_data["cube48"]["BOTTOM"]["coords"],block_data["cube48"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("cube48", "FRONT", block_data["cube48"]["vertices"],block_data["cube48"]["FRONT"]["coords"],block_data["cube48"]["FRONT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube48", "BACK", block_data["cube48"]["vertices"],block_data["cube48"]["BACK"]["coords"],block_data["cube48"]["BACK"]["uvs"], x, y, z, block_info[side])
		create_faces("cube48", "TOP", block_data["cube48"]["vertices"],block_data["cube48"]["TOP"]["coords"],block_data["cube48"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("cube48", "LEFT", block_data["cube48"]["vertices"],block_data["cube48"]["LEFT"]["coords"],block_data["cube48"]["LEFT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube48", "RIGHT", block_data["cube48"]["vertices"],block_data["cube48"]["RIGHT"]["coords"],block_data["cube48"]["RIGHT"]["uvs"], x, y, z, block_info[side])

		for e in range(0,plant_number+2):
			for i in range(0,plant_number):
				#block48
				rand_grass()
				create_grass1(0.65, 0.95, -0.85, 0, -0.05, plant_number, LEAF, e,i,x,y,z, block_info[leaf])
				rand_grass()
				create_grass2(0.2, 1, -0.15, 0.2, 0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf])
				rand_grass()
				create_grass2(0.2, 1, 0, 0,0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(0.2, 1, -0.3, -0.15, -0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				
##
				rand_grass()
				create_fill_grass(-0.75, 0.15, 0.08, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.8, 0.1, 0.08, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.78, 0.2, 0.17, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.63, 0.2, 0.05, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.63, 0.25, 0.05, LEAF,x, y, z, block_info[leaf])
				
	elif !check_transparent(chunk_pos.x,block_y,chunk_pos.z+1) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z-1) && !check_transparent(chunk_pos.x+1,block_y,chunk_pos.z) && \
	!check_transparent(chunk_pos.x+1,block_y,chunk_pos.z-1) && check_transparent(chunk_pos.x,block_y+1,chunk_pos.z) && check_transparent(chunk_pos.x-1,block_y,chunk_pos.z) && \
	check_transparent(chunk_pos.x+1,block_y,chunk_pos.z+1):
		create_faces("cube49","BOTTOM", block_data["cube49"]["vertices"],block_data["cube49"]["BOTTOM"]["coords"],block_data["cube49"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("cube49", "FRONT", block_data["cube49"]["vertices"],block_data["cube49"]["FRONT"]["coords"],block_data["cube49"]["FRONT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube49", "BACK", block_data["cube49"]["vertices"],block_data["cube49"]["BACK"]["coords"],block_data["cube49"]["BACK"]["uvs"], x, y, z, block_info[side])
		create_faces("cube49", "TOP", block_data["cube49"]["vertices"],block_data["cube49"]["TOP"]["coords"],block_data["cube49"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("cube49", "LEFT", block_data["cube49"]["vertices"],block_data["cube49"]["LEFT"]["coords"],block_data["cube49"]["LEFT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube49", "RIGHT", block_data["cube49"]["vertices"],block_data["cube49"]["RIGHT"]["coords"],block_data["cube49"]["RIGHT"]["uvs"], x, y, z, block_info[side])

		
		for e in range(0,plant_number+2):
			for i in range(0,plant_number):
				#block49
				rand_grass()
				create_grass1(0.65, 0.95, -0.6, 0, -0.05, plant_number, LEAF, e,i,x,y,z, block_info[leaf])

				rand_grass()
				create_grass2(0.2, 1, -0.85, 0.2, 0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass2(0.2, 1, -1.05, 0.05, 0.1,plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(0.2, 1, -0.9, -0.1, -0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				
				rand_grass()
				create_fill_grass2(-0.78, 0.22, -0.25, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.78, 0.22, -0.15, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.57, 0.22, -0.05, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.45, 0.25, -0.05, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.8, 0.05, 0.95, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(-0.75, 0.15, 0.9, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(-0.7, 0.25, 0.85, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(-0.7, 0.22, 0.95, LEAF,x,y,z, block_info[leaf])

				rand_grass()
				create_fill_grass2(0.15, 0.15, -0.05, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.12, 0.22, -0.08, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.05, 0.25, -0.15, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0, 0.25, -0.05, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.1, 0.25, -0.25, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.78, 0.22, -0.8, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.6, 0.22, -0.92, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.1, 0.22, -0.8, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.1, 0.25, -0.95, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.1, 0.25, -0.7, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.05, 0.25, -0.6, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.6, 0.22, -0.92, LEAF,x,y,z, block_info[leaf])


	elif !check_transparent(chunk_pos.x,block_y,chunk_pos.z+1) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z-1) && !check_transparent(chunk_pos.x-1,block_y,chunk_pos.z) && \
	check_transparent(chunk_pos.x,block_y+1,chunk_pos.z) && check_transparent(chunk_pos.x+1,block_y,chunk_pos.z) && !check_transparent(chunk_pos.x-1,block_y,chunk_pos.z-1) && \
	check_transparent(chunk_pos.x-1,block_y,chunk_pos.z+1):
		create_faces("cube50","BOTTOM", block_data["cube50"]["vertices"],block_data["cube50"]["BOTTOM"]["coords"],block_data["cube50"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("cube50", "FRONT", block_data["cube50"]["vertices"],block_data["cube50"]["FRONT"]["coords"],block_data["cube50"]["FRONT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube50", "BACK", block_data["cube50"]["vertices"],block_data["cube50"]["BACK"]["coords"],block_data["cube50"]["BACK"]["uvs"], x, y, z, block_info[side])
		create_faces("cube50", "TOP", block_data["cube50"]["vertices"],block_data["cube50"]["TOP"]["coords"],block_data["cube50"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("cube50", "LEFT", block_data["cube50"]["vertices"],block_data["cube50"]["LEFT"]["coords"],block_data["cube50"]["LEFT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube50", "RIGHT", block_data["cube50"]["vertices"],block_data["cube50"]["RIGHT"]["coords"],block_data["cube50"]["RIGHT"]["uvs"], x, y, z, block_info[side])

		for e in range(0,plant_number+2):
			for i in range(0,plant_number):
				#block50
				rand_grass()
				create_grass1(0.55, 0.95, -0.85, 0, -0.05, plant_number, LEAF, e,i,x,y,z, block_info[leaf])
				
				rand_grass()
				create_fill_grass2(-0.88, 0.22, -0.25, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.88, 0.22, -0.15, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.67, 0.22, -0.05, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.5, 0.25, -0.05, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.9, 0.05, 0.95, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(-0.85, 0.15, 0.9, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(-0.8, 0.25, 0.85, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(-0.8, 0.22, 0.95, LEAF,x,y,z, block_info[leaf])

				rand_grass()
				create_grass2(0.2, 1, -0.15, 0.2, 0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass2(0.2, 1, 0, 0,0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(0.2, 1, -0.3, -0.15, -0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				
				
	elif !check_transparent(chunk_pos.x+1,block_y,chunk_pos.z) && !check_transparent(chunk_pos.x-1,block_y,chunk_pos.z) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z-1) && \
	check_transparent(chunk_pos.x,block_y,chunk_pos.z+1) && check_transparent(chunk_pos.x,block_y+1,chunk_pos.z) && !check_transparent(chunk_pos.x-1,block_y,chunk_pos.z-1)  && \
	check_transparent(chunk_pos.x+1,block_y,chunk_pos.z-1):
		create_faces("cube51","BOTTOM", block_data["cube51"]["vertices"],block_data["cube51"]["BOTTOM"]["coords"],block_data["cube51"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("cube51", "FRONT", block_data["cube51"]["vertices"],block_data["cube51"]["FRONT"]["coords"],block_data["cube51"]["FRONT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube51", "BACK", block_data["cube51"]["vertices"],block_data["cube51"]["BACK"]["coords"],block_data["cube51"]["BACK"]["uvs"], x, y, z, block_info[side])
		create_faces("cube51", "TOP", block_data["cube51"]["vertices"],block_data["cube51"]["TOP"]["coords"],block_data["cube51"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("cube51", "LEFT", block_data["cube51"]["vertices"],block_data["cube51"]["LEFT"]["coords"],block_data["cube51"]["LEFT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube51", "RIGHT", block_data["cube51"]["vertices"],block_data["cube51"]["RIGHT"]["coords"],block_data["cube51"]["RIGHT"]["uvs"], x, y, z, block_info[side])

		for e in range(0,plant_number+2):
			for i in range(0,plant_number):
				#block51
				rand_grass()
				create_grass1(0.95, 0.55, -0.85, 0, -0.05, plant_number, LEAF, e,i,x,y,z, block_info[leaf])
				
				rand_grass()
				create_fill_grass(0.1, 0.1, 0.05, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(0.1, 0.15, 0.1, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(-0.05, 0.25, 0.1, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(0.12, 0.22, 0.22, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass(0, 0.22, 0.1, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass(0, 0.25, 0.1, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass(0.1, 0.22, 0.1, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass(0.15, 0.15, 0.1, LEAF,x,y,z, block_info[leaf])

				rand_grass()
				create_grass2(1, 0.2, -0.85, 0.1, 0.7,plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass2(1, 0.2, -0.85, -0.05, 0.85,plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(1, 0.2,-0.87, -0.1, 0.3 ,plant_number, LEAF, e,i,x,y,z, block_info[leaf])
				
				
	elif !check_transparent(chunk_pos.x+1,block_y,chunk_pos.z) && !check_transparent(chunk_pos.x-1,block_y,chunk_pos.z) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z-1) && \
	check_transparent(chunk_pos.x,block_y,chunk_pos.z+1) && check_transparent(chunk_pos.x,block_y+1,chunk_pos.z) && !check_transparent(chunk_pos.x+1,block_y,chunk_pos.z-1) && \
	check_transparent(chunk_pos.x-1,block_y,chunk_pos.z-1):
		create_faces("cube52","BOTTOM", block_data["cube52"]["vertices"],block_data["cube52"]["BOTTOM"]["coords"],block_data["cube52"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("cube52", "FRONT", block_data["cube52"]["vertices"],block_data["cube52"]["FRONT"]["coords"],block_data["cube52"]["FRONT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube52", "BACK", block_data["cube52"]["vertices"],block_data["cube52"]["BACK"]["coords"],block_data["cube52"]["BACK"]["uvs"], x, y, z, block_info[side])
		create_faces("cube52", "TOP", block_data["cube52"]["vertices"],block_data["cube52"]["TOP"]["coords"],block_data["cube52"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("cube52", "LEFT", block_data["cube52"]["vertices"],block_data["cube52"]["LEFT"]["coords"],block_data["cube52"]["LEFT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube52", "RIGHT", block_data["cube52"]["vertices"],block_data["cube52"]["RIGHT"]["coords"],block_data["cube52"]["RIGHT"]["uvs"], x, y, z, block_info[side])

		for e in range(0,plant_number+2):
			for i in range(0,plant_number):
				#block52
				rand_grass()
				create_grass1(0.95, 0.55, -0.85, 0, -0.05, plant_number, LEAF, e,i,x,y,z, block_info[leaf])

				rand_grass()
				create_grass2(1.1, 0.2, -0.85, 0.1, 0.7,plant_number+1, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass2(1.1, 0.2, -0.85, -0.05, 0.85,plant_number+1, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(1.1, 0.2,-0.87, -0.1, 0.3 ,plant_number+1, LEAF, e,i,x,y,z, block_info[leaf])

				rand_grass()
				create_fill_grass(-0.75, 0.15, 0.08, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.8, 0.1, 0.08, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.78, 0.2, 0.17, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.63, 0.2, 0.05, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.63, 0.25, 0.05, LEAF,x, y, z, block_info[leaf])
				
	elif !check_transparent(chunk_pos.x-1,block_y,chunk_pos.z) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z+1) && check_transparent(chunk_pos.x,block_y+1,chunk_pos.z) && \
	check_transparent(chunk_pos.x+1,block_y,chunk_pos.z) && check_transparent(chunk_pos.x,block_y,chunk_pos.z-1) && \
	check_transparent(chunk_pos.x-1,block_y,chunk_pos.z+1):
		create_faces("cube28","BOTTOM", block_data["cube28"]["vertices"],block_data["cube28"]["BOTTOM"]["coords"],block_data["cube28"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("cube28", "FRONT", block_data["cube28"]["vertices"],block_data["cube28"]["FRONT"]["coords"],block_data["cube28"]["FRONT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube28", "BACK", block_data["cube28"]["vertices"],block_data["cube28"]["BACK"]["coords"],block_data["cube28"]["BACK"]["uvs"], x, y, z, block_info[side])
		create_faces("cube28", "TOP", block_data["cube28"]["vertices"],block_data["cube28"]["TOP"]["coords"],block_data["cube28"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("cube28", "LEFT", block_data["cube28"]["vertices"],block_data["cube28"]["LEFT"]["coords"],block_data["cube28"]["LEFT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube28", "RIGHT", block_data["cube28"]["vertices"],block_data["cube28"]["RIGHT"]["coords"],block_data["cube28"]["RIGHT"]["uvs"], x, y, z, block_info[side])

		for e in range(0,plant_number+2):
			for i in range(0,plant_number):
				#block28 
				rand_grass()
				create_grass1(0.3, 0.3, -0.92, 0, 0.15, plant_number, LEAF, e,i,x,y,z, block_info[leaf])  
				rand_grass()
				create_grass1(0.3, 0.7, -0.65, 0, 0.15, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(0.7, 0.1, -0.92, -0.22, -0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(0.1, 0.7, -0.25, -0.22, 0.15, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 

				rand_grass()
				create_grass2(0.8, 0.1, -0.88, -0.07, 0, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass2(0.1, 0.8, -0.1, -0.07, 0.3, plant_number, LEAF, e,i,x,y,z, block_info[leaf])

				rand_grass()
				create_fill_grass(-0.65, 0.2, -0.07, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.78, 0.18, -0.1, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.8, 0.1, -0.05, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.8, 0.05, -0.08, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.78, 0.25, -0.2, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.65, 0.25, -0.08, LEAF,x, y, z, block_info[leaf])
				
				
	elif !check_transparent(chunk_pos.x+1,block_y,chunk_pos.z) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z+1) && check_transparent(chunk_pos.x,block_y+1,chunk_pos.z) && \
	check_transparent(chunk_pos.x,block_y,chunk_pos.z-1) && check_transparent(chunk_pos.x-1,block_y,chunk_pos.z) && \
	check_transparent(chunk_pos.x+1,block_y,chunk_pos.z+1):
		create_faces("cube29","BOTTOM", block_data["cube29"]["vertices"],block_data["cube29"]["BOTTOM"]["coords"],block_data["cube29"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("cube29", "FRONT", block_data["cube29"]["vertices"],block_data["cube29"]["FRONT"]["coords"],block_data["cube29"]["FRONT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube29", "BACK", block_data["cube29"]["vertices"],block_data["cube29"]["BACK"]["coords"],block_data["cube29"]["BACK"]["uvs"], x, y, z, block_info[side])
		create_faces("cube29", "TOP", block_data["cube29"]["vertices"],block_data["cube29"]["TOP"]["coords"],block_data["cube29"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("cube29", "LEFT", block_data["cube29"]["vertices"],block_data["cube29"]["LEFT"]["coords"],block_data["cube29"]["LEFT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube29", "RIGHT", block_data["cube29"]["vertices"],block_data["cube29"]["RIGHT"]["coords"],block_data["cube29"]["RIGHT"]["uvs"], x, y, z, block_info[side])

		for e in range(0,plant_number+2):
			for i in range(0,plant_number):
				#block29
				rand_grass()
				create_grass1(0.3, 0.3, -0.36, 0, 0.18, plant_number, LEAF, e,i,x,y,z, block_info[leaf])  
				rand_grass()
				create_grass1(0.3, 0.7, -0.65, 0, 0.15, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(0.7, 0.1, -0.65, -0.22, -0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(0.1, 0.7, -0.9, -0.22, 0.15, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 

				rand_grass()
				create_grass2(0.7, 0.1, -0.65, -0.1, 0.05, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass2(0.1, 0.7, -0.95, -0.1, 0.28, plant_number, LEAF, e,i,x,y,z, block_info[leaf])
##
				rand_grass()
				create_fill_grass(-0.65, 0.15, 0.2, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.55, 0.15, 0.15, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.63, 0.05, 0.05, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.73, 0.02, 0.08, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.78, 0, 0.2, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(0.1, 0.12, 0.95, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(0.14, 0.08, 1, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(0.1, 0.18, 0.95, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.02, 0.28, 0.95, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(0.1, 0.28, 0.8, LEAF,x, y, z, block_info[leaf])
				
	elif !check_transparent(chunk_pos.x-1,block_y,chunk_pos.z) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z-1) && check_transparent(chunk_pos.x,block_y+1,chunk_pos.z) && \
	check_transparent(chunk_pos.x+1,block_y,chunk_pos.z) && check_transparent(chunk_pos.x,block_y,chunk_pos.z+1) && \
	check_transparent(chunk_pos.x-1,block_y,chunk_pos.z-1):
		create_faces("cube30","BOTTOM", block_data["cube30"]["vertices"],block_data["cube30"]["BOTTOM"]["coords"],block_data["cube30"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("cube30", "FRONT", block_data["cube30"]["vertices"],block_data["cube30"]["FRONT"]["coords"],block_data["cube30"]["FRONT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube30", "BACK", block_data["cube30"]["vertices"],block_data["cube30"]["BACK"]["coords"],block_data["cube30"]["BACK"]["uvs"], x, y, z, block_info[side])
		create_faces("cube30", "TOP", block_data["cube30"]["vertices"],block_data["cube30"]["TOP"]["coords"],block_data["cube30"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("cube30", "LEFT", block_data["cube30"]["vertices"],block_data["cube30"]["LEFT"]["coords"],block_data["cube30"]["LEFT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube30", "RIGHT", block_data["cube30"]["vertices"],block_data["cube30"]["RIGHT"]["coords"],block_data["cube30"]["RIGHT"]["uvs"], x, y, z, block_info[side])

		for e in range(0,plant_number+2):
			for i in range(0,plant_number):
				#block30
				rand_grass()
				create_grass1(0.3, 0.3, -0.65, 0, -0.08, plant_number, LEAF, e,i,x,y,z, block_info[leaf])  
				rand_grass()
				create_grass1(0.7, 0.3, -0.95, 0, 0.18, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(0.1, 0.7, -0.2, -0.22, -0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(0.7, 0.1, -0.9, -0.22, 0.55, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
#
				rand_grass()
				create_grass2(0.1, 0.7, -0.1, -0.1, 0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass2(0.7, 0.1, -0.85, -0.1, 0.9, plant_number, LEAF, e,i,x,y,z, block_info[leaf])
###
				rand_grass()
				create_fill_grass(-0.75, 0.15, 0.08, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.8, 0.1, 0.08, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.78, 0.2, 0.17, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.63, 0.2, 0.05, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.63, 0.25, 0.05, LEAF,x, y, z, block_info[leaf])
				
				rand_grass()
				create_fill_grass(0.07, -0.05, 0.96, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.05, -0.05, 0.96, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(0.03, 0.05, 0.92, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(0.05, 0.05, 0.88, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(0.2, -0.05, 0.75, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(0.05, 0.2, 0.88, LEAF,x, y, z, block_info[leaf])
				
	elif !check_transparent(chunk_pos.x+1,block_y,chunk_pos.z) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z-1) && check_transparent(chunk_pos.x,block_y+1,chunk_pos.z) \
	&& check_transparent(chunk_pos.x-1,block_y,chunk_pos.z) && check_transparent(chunk_pos.x,block_y,chunk_pos.z+1) && \
	check_transparent(chunk_pos.x+1,block_y,chunk_pos.z-1):
		create_faces("cube31","BOTTOM", block_data["cube31"]["vertices"],block_data["cube31"]["BOTTOM"]["coords"],block_data["cube31"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("cube31", "FRONT", block_data["cube31"]["vertices"],block_data["cube31"]["FRONT"]["coords"],block_data["cube31"]["FRONT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube31", "BACK", block_data["cube31"]["vertices"],block_data["cube31"]["BACK"]["coords"],block_data["cube31"]["BACK"]["uvs"], x, y, z, block_info[side])
		create_faces("cube31", "TOP", block_data["cube31"]["vertices"],block_data["cube31"]["TOP"]["coords"],block_data["cube31"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("cube31", "LEFT", block_data["cube31"]["vertices"],block_data["cube31"]["LEFT"]["coords"],block_data["cube31"]["LEFT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube31", "RIGHT", block_data["cube31"]["vertices"],block_data["cube31"]["RIGHT"]["coords"],block_data["cube31"]["RIGHT"]["uvs"], x, y, z, block_info[side])

		for e in range(0,plant_number+2):
			for i in range(0,plant_number):
				#block31
				rand_grass()
				create_grass1(0.3, 0.3, -0.65, 0, -0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf])  
				rand_grass()
				create_grass1(0.7, 0.3, -0.68, 0, 0.18, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(0.1, 0.7, -0.92, -0.22, -0.05, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(0.7, 0.1, -0.7, -0.22, 0.6, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(0.7, 0.1, -0.68, -0.35, 0.7, plant_number, LEAF, e,i,x,y,z, block_info[leaf])
				
				rand_grass()
				create_grass2(0.1, 0.7, -1, -0.1, 0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass3(0.7, 0.1, -0.63, -0.1, -0.35, plant_number, LEAF, e,i,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass(0.1, 0.15, 0.08, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(0.14, 0.06, 0.05, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.05, 0.25, 0.05, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(0.15, 0.23, 0.2, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(0.1, 0.28, 0.1, LEAF,x, y, z, block_info[leaf])
				
				rand_grass()
				create_fill_grass2(-0.7, 0.15, -0.15, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.68, 0.15, 0.85, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.75, 0, -0.1, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.75, 0, 0.9, LEAF,x, y, z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.85, -0.05, 0.77, LEAF,x, y, z, block_info[leaf])
				
				
	elif !check_transparent(chunk_pos.x,block_y,chunk_pos.z+1) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z-1) && !check_transparent(chunk_pos.x+1,block_y,chunk_pos.z) && \
	!check_transparent(chunk_pos.x-1,block_y,chunk_pos.z) && check_transparent(chunk_pos.x+1,block_y,chunk_pos.z+1) && check_transparent(chunk_pos.x-1,block_y,chunk_pos.z+1) && \
	check_transparent(chunk_pos.x,block_y+1,chunk_pos.z):
		create_faces("cube32","BOTTOM", block_data["cube32"]["vertices"],block_data["cube32"]["BOTTOM"]["coords"],block_data["cube32"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("cube32", "FRONT", block_data["cube32"]["vertices"],block_data["cube32"]["FRONT"]["coords"],block_data["cube32"]["FRONT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube32", "BACK", block_data["cube32"]["vertices"],block_data["cube32"]["BACK"]["coords"],block_data["cube32"]["BACK"]["uvs"], x, y, z, block_info[side])
		create_faces("cube32", "TOP", block_data["cube32"]["vertices"],block_data["cube32"]["TOP"]["coords"],block_data["cube32"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("cube32", "LEFT", block_data["cube32"]["vertices"],block_data["cube32"]["LEFT"]["coords"],block_data["cube32"]["LEFT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube32", "RIGHT", block_data["cube32"]["vertices"],block_data["cube32"]["RIGHT"]["coords"],block_data["cube32"]["RIGHT"]["uvs"], x, y, z, block_info[side])

		for e in range(0,plant_number+2):
			for i in range(0,plant_number):
				#block32
				rand_grass()
				create_grass1(1, 0.7, -0.85, 0, -0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf])  
				rand_grass()
				create_grass1(0.3, 0.3, -0.6, 0, 0.5, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				
				rand_grass()
				create_fill_grass(-0.8, 0.05, 0.95, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(-0.75, 0.15, 0.9, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(-0.7, 0.25, 0.85, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(-0.7, 0.22, 0.95, LEAF,x,y,z, block_info[leaf])

				rand_grass()
				create_fill_grass(0, 0.22, 0.95, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass(0, 0.25, 0.95, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass(0.1, 0.22, 0.8, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass(0.15, 0.15, 0.95, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.15, 0.15, -0.05, LEAF,x,y,z, block_info[leaf])
				
				rand_grass()
				create_fill_grass2(-0.78, 0.22, -0.25, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.78, 0.22, -0.15, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.57, 0.22, -0.05, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.45, 0.25, -0.05, LEAF,x,y,z, block_info[leaf])
				
				
	elif !check_transparent(chunk_pos.x,block_y,chunk_pos.z+1) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z-1) && !check_transparent(chunk_pos.x+1,block_y,chunk_pos.z) && \
	!check_transparent(chunk_pos.x-1,block_y,chunk_pos.z) && check_transparent(chunk_pos.x+1,block_y,chunk_pos.z-1) && check_transparent(chunk_pos.x-1,block_y,chunk_pos.z-1) && \
	check_transparent(chunk_pos.x,block_y+1,chunk_pos.z):
		create_faces("cube33","BOTTOM", block_data["cube33"]["vertices"],block_data["cube33"]["BOTTOM"]["coords"],block_data["cube33"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("cube33", "FRONT", block_data["cube33"]["vertices"],block_data["cube33"]["FRONT"]["coords"],block_data["cube33"]["FRONT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube33", "BACK", block_data["cube33"]["vertices"],block_data["cube33"]["BACK"]["coords"],block_data["cube33"]["BACK"]["uvs"], x, y, z, block_info[side])
		create_faces("cube33", "TOP", block_data["cube33"]["vertices"],block_data["cube33"]["TOP"]["coords"],block_data["cube33"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("cube33", "LEFT", block_data["cube33"]["vertices"],block_data["cube33"]["LEFT"]["coords"],block_data["cube33"]["LEFT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube33", "RIGHT", block_data["cube33"]["vertices"],block_data["cube33"]["RIGHT"]["coords"],block_data["cube33"]["RIGHT"]["uvs"], x, y, z, block_info[side]) 
		
		for e in range(0,plant_number+2):
			for i in range(0,plant_number):
				#block33
				rand_grass()
				create_fill_grass(-0.8, 0.1, 0.05, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(-0.75, 0.15, 0.1, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(-0.7, 0.25, 0.1, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(-0.7, 0.22, 0.15, LEAF,x,y,z, block_info[leaf])
#
				rand_grass()
				create_fill_grass(0, 0.22, 0.1, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass(0, 0.25, 0.1, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass(0.15, 0.15, 0.1, LEAF,x,y,z, block_info[leaf])
				
				rand_grass()
				create_fill_grass2(-0.78, 0.22, -0.8, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.6, 0.22, -0.92, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.1, 0.22, -0.8, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.1, 0.25, -0.95, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.1, 0.25, -0.7, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.05, 0.25, -0.6, LEAF,x,y,z, block_info[leaf])
				
	elif !check_transparent(chunk_pos.x,block_y,chunk_pos.z+1) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z-1) && !check_transparent(chunk_pos.x+1,block_y,chunk_pos.z) && \
	!check_transparent(chunk_pos.x-1,block_y,chunk_pos.z) && check_transparent(chunk_pos.x+1,block_y,chunk_pos.z+1) && check_transparent(chunk_pos.x+1,block_y,chunk_pos.z-1) && \
	check_transparent(chunk_pos.x,block_y+1,chunk_pos.z):
		create_faces("cube34","BOTTOM", block_data["cube34"]["vertices"],block_data["cube34"]["BOTTOM"]["coords"],block_data["cube34"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("cube34", "FRONT", block_data["cube34"]["vertices"],block_data["cube34"]["FRONT"]["coords"],block_data["cube34"]["FRONT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube34", "BACK", block_data["cube34"]["vertices"],block_data["cube34"]["BACK"]["coords"],block_data["cube34"]["BACK"]["uvs"], x, y, z, block_info[side])
		create_faces("cube34", "TOP", block_data["cube34"]["vertices"],block_data["cube34"]["TOP"]["coords"],block_data["cube34"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("cube34", "LEFT", block_data["cube34"]["vertices"],block_data["cube34"]["LEFT"]["coords"],block_data["cube34"]["LEFT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube34", "RIGHT", block_data["cube34"]["vertices"],block_data["cube34"]["RIGHT"]["coords"],block_data["cube34"]["RIGHT"]["uvs"], x, y, z, block_info[side])
		
		for e in range(0,plant_number+2):
			for i in range(0,plant_number):
				#block34
				rand_grass()
				create_grass1(0.7, 1, -0.9, 0, -0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf])  
				rand_grass()
				create_grass1(0.3, 0.3, -0.38, 0, 0.2, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				
				rand_grass()
				create_fill_grass(0.1, 0.1, 0.05, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(0.1, 0.15, 0.1, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(-0.05, 0.25, 0.1, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(0.12, 0.22, 0.22, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass(0, 0.22, 0.1, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass(0, 0.25, 0.1, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass(0.1, 0.22, 0.1, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass(0.15, 0.15, 0.1, LEAF,x,y,z, block_info[leaf])

	elif !check_transparent(chunk_pos.x,block_y,chunk_pos.z+1) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z-1) && !check_transparent(chunk_pos.x+1,block_y,chunk_pos.z) && \
	!check_transparent(chunk_pos.x-1,block_y,chunk_pos.z) && check_transparent(chunk_pos.x-1,block_y,chunk_pos.z+1) && check_transparent(chunk_pos.x-1,block_y,chunk_pos.z-1) && \
	check_transparent(chunk_pos.x,block_y+1,chunk_pos.z):
		create_faces("cube35","BOTTOM", block_data["cube35"]["vertices"],block_data["cube35"]["BOTTOM"]["coords"],block_data["cube35"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("cube35", "FRONT", block_data["cube35"]["vertices"],block_data["cube35"]["FRONT"]["coords"],block_data["cube35"]["FRONT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube35", "BACK", block_data["cube35"]["vertices"],block_data["cube35"]["BACK"]["coords"],block_data["cube35"]["BACK"]["uvs"], x, y, z, block_info[side])
		create_faces("cube35", "TOP", block_data["cube35"]["vertices"],block_data["cube35"]["TOP"]["coords"],block_data["cube35"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("cube35", "LEFT", block_data["cube35"]["vertices"],block_data["cube35"]["LEFT"]["coords"],block_data["cube35"]["LEFT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube35", "RIGHT", block_data["cube35"]["vertices"],block_data["cube35"]["RIGHT"]["coords"],block_data["cube35"]["RIGHT"]["uvs"], x, y, z, block_info[side])
		
		for e in range(0,plant_number+2):
			for i in range(0,plant_number):
		#block35
				rand_grass()
				create_grass1(0.7, 1, -0.65, 0, -0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf])  
				rand_grass()
				create_grass1(0.3, 0.3, -0.9, 0, 0.25, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				
				rand_grass()
				create_fill_grass(-0.8, 0.1, 0.05, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(-0.75, 0.15, 0.1, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(-0.7, 0.25, 0.1, LEAF,x,y,z, block_info[leaf]) 
				rand_grass()
				create_fill_grass(-0.7, 0.22, 0.15, LEAF,x,y,z, block_info[leaf])
				
#
				rand_grass()
				create_fill_grass(-0.8, 0.22, 0.85, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.65, 0.2, 0.96, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.75, 0.2, 0.96, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass(-0.8, 0.1, 0.98, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.55, 0.28, -0.05, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.8, 0.28, -0.2, LEAF,x,y,z, block_info[leaf])
				
				rand_grass()
				create_fill_grass2(-0.78, 0.22, -0.8, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.6, 0.22, -0.92, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.1, 0.22, -0.8, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(-0.1, 0.25, -0.95, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.1, 0.25, -0.7, LEAF,x,y,z, block_info[leaf])
				rand_grass()
				create_fill_grass2(0.05, 0.25, -0.6, LEAF,x,y,z, block_info[leaf])

	elif check_transparent(chunk_pos.x+1,block_y,chunk_pos.z) && check_transparent(chunk_pos.x,block_y,chunk_pos.z+1) && check_transparent(chunk_pos.x,block_y,chunk_pos.z-1) \
	&& check_transparent(chunk_pos.x,block_y+1,chunk_pos.z) && !check_transparent(chunk_pos.x-1,block_y,chunk_pos.z):
		create_faces("cube13", "TOP",block_data["cube13"]["vertices"],block_data["cube13"]["TOP"]["coords"],block_data["cube13"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("cube13","BOTTOM", block_data["cube13"]["vertices"],block_data["cube13"]["BOTTOM"]["coords"],block_data["cube13"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("cube13", "BACK",block_data["cube13"]["vertices"],block_data["cube13"]["BACK"]["coords"],block_data["cube13"]["BACK"]["uvs"],x, y, z, block_info[side])
		create_faces("cube13", "RIGHT", block_data["cube13"]["vertices"],block_data["cube13"]["RIGHT"]["coords"],block_data["cube13"]["RIGHT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube13", "FRONT", block_data["cube13"]["vertices"],block_data["cube13"]["FRONT"]["coords"],block_data["cube13"]["FRONT"]["uvs"], x, y, z, block_info[side])
		
		for e in range(0,plant_number+2):
			for i in range(0,plant_number):
		#block13
				rand_grass()
				create_grass1(0.7, 0.35, -0.9, -0.05, 0.17, plant_number, LEAF, e,i,x,y,z, block_info[leaf])  
				rand_grass()
				create_grass1(0.7, 0.1, -0.9, -0.26, 0.6, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(0.1, 0.5, -0.25, -0.22, 0.15, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(0.7, 0.1, -0.9, -0.21, -0.05, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass2(0.85, 0.1, -0.85, -0.05, 0, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass2(0.1, 0.7, -0.1, -0.1, 0.23, plant_number, LEAF, e,i,x,y,z, block_info[leaf])
				rand_grass()
				create_grass2(0.85, 0.1, -0.88, -0.05, 0.93, plant_number, LEAF, e,i,x,y,z, block_info[leaf])
	
	elif check_transparent(chunk_pos.x,block_y,chunk_pos.z+1) && check_transparent(chunk_pos.x,block_y,chunk_pos.z-1) && \
	check_transparent(chunk_pos.x-1,block_y,chunk_pos.z) && !check_transparent(chunk_pos.x+1,block_y,chunk_pos.z):
		create_faces("cube14", "TOP",block_data["cube14"]["vertices"],block_data["cube14"]["TOP"]["coords"],block_data["cube14"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("cube14","BOTTOM", block_data["cube14"]["vertices"],block_data["cube14"]["BOTTOM"]["coords"],block_data["cube14"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("cube14", "BACK",block_data["cube14"]["vertices"],block_data["cube14"]["BACK"]["coords"],block_data["cube14"]["BACK"]["uvs"],x, y, z, block_info[side])
		create_faces("cube14", "FRONT", block_data["cube14"]["vertices"],block_data["cube14"]["FRONT"]["coords"],block_data["cube14"]["FRONT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube14", "LEFT", block_data["cube14"]["vertices"],block_data["cube14"]["LEFT"]["coords"],block_data["cube14"]["LEFT"]["uvs"], x, y, z, block_info[side])

		for e in range(0,plant_number+2):
			for i in range(0,plant_number):
				#14
				rand_grass()
				create_grass1(0.7, 0.5, -0.7, -0.05, 0.13, plant_number, LEAF, e,i,x,y,z, block_info[leaf])  
				rand_grass()
				create_grass1(0.7, 0.1, -0.7, -0.26, 0.6, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(0.1, 0.5, -0.88, -0.22, 0.15, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(0.7, 0.1, -0.7, -0.21, -0.05, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass2(0.85, 0.1, -0.75, -0.05, 0, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass2(0.1, 0.7, -1, -0.1, 0.2, plant_number, LEAF, e,i,x,y,z, block_info[leaf])
				rand_grass()
				create_grass2(0.85, 0.1, -0.78, -0.1, 0.9, plant_number, LEAF, e,i,x,y,z, block_info[leaf])
				
	elif check_transparent(chunk_pos.x+1,block_y,chunk_pos.z) && check_transparent(chunk_pos.x-1,block_y,chunk_pos.z) && check_transparent(chunk_pos.x,block_y+1,chunk_pos.z) \
	&& check_transparent(chunk_pos.x,block_y,chunk_pos.z-1) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z+1):
		create_faces("cube15", "TOP",block_data["cube15"]["vertices"],block_data["cube15"]["TOP"]["coords"],block_data["cube15"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("cube15","BOTTOM", block_data["cube15"]["vertices"],block_data["cube15"]["BOTTOM"]["coords"],block_data["cube15"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("cube15", "BACK",block_data["cube15"]["vertices"],block_data["cube15"]["BACK"]["coords"],block_data["cube15"]["BACK"]["uvs"],x, y, z, block_info[side])
		create_faces("cube15", "RIGHT", block_data["cube15"]["vertices"],block_data["cube15"]["RIGHT"]["coords"],block_data["cube15"]["RIGHT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube15", "LEFT", block_data["cube15"]["vertices"],block_data["cube15"]["LEFT"]["coords"],block_data["cube15"]["LEFT"]["uvs"], x, y, z, block_info[side])
	
		for e in range(0,plant_number+2):
			for i in range(0,plant_number):
				#block15
				rand_grass()
				create_grass1(0.4, 0.65, -0.68, -0.02, 0.18, plant_number, LEAF, e,i,x,y,z, block_info[leaf])  
				rand_grass()
				create_grass1(0.5, 0.1, -0.7, -0.22, -0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(0.1, 0.7, -0.88, -0.22, 0.15, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(0.1, 0.7, -0.23, -0.21, 0.15, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass2(0.7, 0.1, -0.76, -0.1, 0.05, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass2(0.1, 0.8, -1, -0.1, 0.2, plant_number, LEAF, e,i,x,y,z, block_info[leaf])
				rand_grass()
				create_grass2(0.1, 0.85, -0.14, -0.05, 0.15, plant_number, LEAF, e,i,x,y,z, block_info[leaf])

	elif check_transparent(chunk_pos.x-1,block_y,chunk_pos.z) && check_transparent(chunk_pos.x+1,block_y,chunk_pos.z) && check_transparent(chunk_pos.x,block_y+1,chunk_pos.z) \
	&& check_transparent(chunk_pos.x,block_y,chunk_pos.z+1) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z-1):
		create_faces("cube16", "TOP",block_data["cube16"]["vertices"],block_data["cube16"]["TOP"]["coords"],block_data["cube16"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("cube16","BOTTOM", block_data["cube16"]["vertices"],block_data["cube16"]["BOTTOM"]["coords"],block_data["cube16"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("cube16", "FRONT",block_data["cube16"]["vertices"],block_data["cube16"]["FRONT"]["coords"],block_data["cube16"]["FRONT"]["uvs"],x, y, z, block_info[side])
		create_faces("cube16", "RIGHT", block_data["cube16"]["vertices"],block_data["cube16"]["RIGHT"]["coords"],block_data["cube16"]["RIGHT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube16", "LEFT", block_data["cube16"]["vertices"],block_data["cube16"]["LEFT"]["coords"],block_data["cube16"]["LEFT"]["uvs"], x, y, z, block_info[side])
		
		for e in range(0,plant_number+2):
			for i in range(0,plant_number):
				#block16
				rand_grass()
				create_grass1(0.3, 0.6, -0.63, 0, -0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf])  
				rand_grass()
				create_grass1(0.5, 0.1, -0.7, -0.22, 0.6, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(0.1, 0.7, -0.88, -0.22, -0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf])
				rand_grass()
				create_grass1(0.1, 0.7, -0.23, -0.21, -0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass2(0.5, 0.1, -0.63, -0.1, 0.9, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass2(0.1, 0.85, 0, -0.1, 0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf])
				rand_grass()
				create_grass2(0.1, 0.8, -1, -0.05, 0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf])
		
	elif !check_transparent(chunk_pos.x,block_y+1,chunk_pos.z) && !check_transparent(chunk_pos.x-1,block_y,chunk_pos.z) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z-1) && \
	check_transparent(chunk_pos.x-1,block_y+1,chunk_pos.z) && check_transparent(chunk_pos.x-1,block_y,chunk_pos.z+1):
		create_faces("fillcube5","BOTTOM", block_data["fillcube5"]["vertices"],block_data["fillcube5"]["BOTTOM"]["coords"],block_data["fillcube5"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("fillcube5", "FRONT", block_data["fillcube5"]["vertices"],block_data["fillcube5"]["FRONT"]["coords"],block_data["fillcube5"]["FRONT"]["uvs"], x, y, z, block_info[side])
		create_faces("fillcube5", "BACK", block_data["fillcube5"]["vertices"],block_data["fillcube5"]["BACK"]["coords"],block_data["fillcube5"]["BACK"]["uvs"], x, y, z, block_info[side])
		create_faces("fillcube5", "TOP", block_data["fillcube5"]["vertices"],block_data["fillcube5"]["TOP"]["coords"],block_data["fillcube5"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("fillcube5", "LEFT", block_data["fillcube5"]["vertices"],block_data["fillcube5"]["LEFT"]["coords"],block_data["fillcube5"]["LEFT"]["uvs"], x, y, z, block_info[side])
		create_faces("fillcube5", "RIGHT", block_data["fillcube5"]["vertices"],block_data["fillcube5"]["RIGHT"]["coords"],block_data["fillcube5"]["RIGHT"]["uvs"], x, y, z, block_info[side])
		
		#fillcube 5	
		rand_grass()
		create_fill_grass(-0.8,0.15,0.9,LEAF,x,y,z, block_info[leaf]) 
		rand_grass()
		create_fill_grass(-0.7,0.15,0.93,LEAF,x,y,z, block_info[leaf]) 
		rand_grass()
		create_fill_grass(-0.82,0.16,0.89,LEAF,x,y,z, block_info[leaf]) 
		rand_grass()
		create_fill_grass(-0.72,0.17,0.91,LEAF,x,y,z, block_info[leaf]) 

	elif !check_transparent(chunk_pos.x,block_y+1,chunk_pos.z) && !check_transparent(chunk_pos.x+1,block_y,chunk_pos.z) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z-1) && \
	check_transparent(chunk_pos.x+1,block_y+1,chunk_pos.z) && check_transparent(chunk_pos.x+1,block_y,chunk_pos.z+1):
		create_faces("fillcube6","BOTTOM", block_data["fillcube6"]["vertices"],block_data["fillcube6"]["BOTTOM"]["coords"],block_data["fillcube6"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("fillcube6", "FRONT", block_data["fillcube6"]["vertices"],block_data["fillcube6"]["FRONT"]["coords"],block_data["fillcube6"]["FRONT"]["uvs"], x, y, z, block_info[side])
		create_faces("fillcube6", "BACK", block_data["fillcube6"]["vertices"],block_data["fillcube6"]["BACK"]["coords"],block_data["fillcube6"]["BACK"]["uvs"], x, y, z, block_info[side])
		create_faces("fillcube6", "TOP", block_data["fillcube6"]["vertices"],block_data["fillcube6"]["TOP"]["coords"],block_data["fillcube6"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("fillcube6", "LEFT", block_data["fillcube6"]["vertices"],block_data["fillcube6"]["LEFT"]["coords"],block_data["fillcube6"]["LEFT"]["uvs"], x, y, z, block_info[side])
		create_faces("fillcube6", "RIGHT", block_data["fillcube6"]["vertices"],block_data["fillcube6"]["RIGHT"]["coords"],block_data["fillcube6"]["RIGHT"]["uvs"], x, y, z, block_info[side])

		#fillcube6
		rand_grass()
		create_fill_grass(0.1,0.15,0.9,LEAF,x,y,z, block_info[leaf]) 
		rand_grass()
		create_fill_grass(0.08,0.15,0.93,LEAF,x,y,z, block_info[leaf]) 
		rand_grass()
		create_fill_grass(0.11,0.16,0.89,LEAF,x,y,z, block_info[leaf]) 
		rand_grass()
		create_fill_grass(0.12,0.17,0.91,LEAF,x,y,z, block_info[leaf]) 

	elif !check_transparent(chunk_pos.x,block_y,chunk_pos.z-1) && !check_transparent(chunk_pos.x,block_y+1,chunk_pos.z) && !check_transparent(chunk_pos.x-1,block_y,chunk_pos.z) && \
	check_transparent(chunk_pos.x,block_y+1,chunk_pos.z-1) && check_transparent(chunk_pos.x+1,block_y,chunk_pos.z-1):
		create_faces("fillcube7","BOTTOM", block_data["fillcube7"]["vertices"],block_data["fillcube7"]["BOTTOM"]["coords"],block_data["fillcube7"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("fillcube7", "FRONT", block_data["fillcube7"]["vertices"],block_data["fillcube7"]["FRONT"]["coords"],block_data["fillcube7"]["FRONT"]["uvs"], x, y, z, block_info[side])
		create_faces("fillcube7", "BACK", block_data["fillcube7"]["vertices"],block_data["fillcube7"]["BACK"]["coords"],block_data["fillcube7"]["BACK"]["uvs"], x, y, z, block_info[side])
		create_faces("fillcube7", "TOP", block_data["fillcube7"]["vertices"],block_data["fillcube7"]["TOP"]["coords"],block_data["fillcube7"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("fillcube7", "LEFT", block_data["fillcube7"]["vertices"],block_data["fillcube7"]["LEFT"]["coords"],block_data["fillcube7"]["LEFT"]["uvs"], x, y, z, block_info[side])
		create_faces("fillcube7", "RIGHT", block_data["fillcube7"]["vertices"],block_data["fillcube7"]["RIGHT"]["coords"],block_data["fillcube7"]["RIGHT"]["uvs"], x, y, z, block_info[side])
		
	#fillcube7
		rand_grass()
		create_fill_grass(0.1,0.15,0.12,LEAF,x,y,z, block_info[leaf]) 
		rand_grass()
		create_fill_grass(0.08,0.15,0.13,LEAF,x,y,z, block_info[leaf]) 
		rand_grass()
		create_fill_grass(0.1,0.16,0.14,LEAF,x,y,z, block_info[leaf]) 
		rand_grass()
		create_fill_grass(0.11,0.17,0.12,LEAF,x,y,z, block_info[leaf]) 
		
	elif !check_transparent(chunk_pos.x,block_y+1,chunk_pos.z) && !check_transparent(chunk_pos.x-1,block_y,chunk_pos.z) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z+1) && \
	check_transparent(chunk_pos.x-1,block_y+1,chunk_pos.z) && check_transparent(chunk_pos.x-1,block_y,chunk_pos.z-1):
		create_faces("fillcube8","BOTTOM", block_data["fillcube8"]["vertices"],block_data["fillcube8"]["BOTTOM"]["coords"],block_data["fillcube8"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("fillcube8", "FRONT", block_data["fillcube8"]["vertices"],block_data["fillcube8"]["FRONT"]["coords"],block_data["fillcube8"]["FRONT"]["uvs"], x, y, z, block_info[side])
		create_faces("fillcube8", "BACK", block_data["fillcube8"]["vertices"],block_data["fillcube8"]["BACK"]["coords"],block_data["fillcube8"]["BACK"]["uvs"], x, y, z, block_info[side])
		create_faces("fillcube8", "TOP", block_data["fillcube8"]["vertices"],block_data["fillcube8"]["TOP"]["coords"],block_data["fillcube8"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("fillcube8", "LEFT", block_data["fillcube8"]["vertices"],block_data["fillcube8"]["LEFT"]["coords"],block_data["fillcube8"]["LEFT"]["uvs"], x, y, z, block_info[side])
		create_faces("fillcube8", "RIGHT", block_data["fillcube8"]["vertices"],block_data["fillcube8"]["RIGHT"]["coords"],block_data["fillcube8"]["RIGHT"]["uvs"], x, y, z, block_info[side])
		
		#fillcube8
		rand_grass()
		create_fill_grass(-0.77,0.15,0.1,LEAF,x,y,z, block_info[leaf]) 
		rand_grass()
		create_fill_grass(-0.8,0.15,0.1,LEAF,x,y,z, block_info[leaf]) 
		rand_grass()
		create_fill_grass(-0.78,0.16,0.1,LEAF,x,y,z, block_info[leaf]) 
		rand_grass()
		create_fill_grass(-0.71,0.18,0.05,LEAF,x,y,z, block_info[leaf]) 

	elif !check_transparent(chunk_pos.x+1,block_y,chunk_pos.z) && check_transparent(chunk_pos.x,block_y,chunk_pos.z+1) \
	&& check_transparent(chunk_pos.x-1,block_y,chunk_pos.z) && !check_transparent(chunk_pos.x,block_y+1,chunk_pos.z) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z-1): 
		create_faces("cube18","BOTTOM", block_data["cube18"]["vertices"],block_data["cube18"]["BOTTOM"]["coords"],block_data["cube18"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("cube18", "FRONT",block_data["cube18"]["vertices"],block_data["cube18"]["FRONT"]["coords"],block_data["cube18"]["FRONT"]["uvs"],x, y, z, block_info[side])
		create_faces("cube18", "RIGHT", block_data["cube18"]["vertices"],block_data["cube18"]["RIGHT"]["coords"],block_data["cube18"]["RIGHT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube18", "LEFT", block_data["cube18"]["vertices"],block_data["cube18"]["LEFT"]["coords"],block_data["cube18"]["LEFT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube18", "BACK", block_data["cube18"]["vertices"],block_data["cube18"]["BACK"]["coords"],block_data["cube18"]["BACK"]["uvs"], x, y, z, block_info[side])


	elif check_transparent(chunk_pos.x+1,block_y,chunk_pos.z) && check_transparent(chunk_pos.x,block_y,chunk_pos.z+1) \
	&& !check_transparent(chunk_pos.x-1,block_y,chunk_pos.z) && !check_transparent(chunk_pos.x,block_y+1,chunk_pos.z) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z-1): 
		create_faces("cube19","BOTTOM", block_data["cube19"]["vertices"],block_data["cube19"]["BOTTOM"]["coords"],block_data["cube19"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("cube19", "FRONT",block_data["cube19"]["vertices"],block_data["cube19"]["FRONT"]["coords"],block_data["cube19"]["FRONT"]["uvs"],x, y, z, block_info[side])
		create_faces("cube19", "RIGHT", block_data["cube19"]["vertices"],block_data["cube19"]["RIGHT"]["coords"],block_data["cube19"]["RIGHT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube19", "LEFT", block_data["cube19"]["vertices"],block_data["cube19"]["LEFT"]["coords"],block_data["cube19"]["LEFT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube19", "BACK", block_data["cube19"]["vertices"],block_data["cube19"]["BACK"]["coords"],block_data["cube19"]["BACK"]["uvs"], x, y, z, block_info[side])


	elif check_transparent(chunk_pos.x,block_y,chunk_pos.z-1) && check_transparent(chunk_pos.x+1,block_y,chunk_pos.z) \
	&& !check_transparent(chunk_pos.x,block_y+1,chunk_pos.z) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z+1) && !check_transparent(chunk_pos.x-1,block_y,chunk_pos.z):
		create_faces("cube20","BOTTOM", block_data["cube20"]["vertices"],block_data["cube20"]["BOTTOM"]["coords"],block_data["cube20"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("cube20", "FRONT",block_data["cube20"]["vertices"],block_data["cube20"]["FRONT"]["coords"],block_data["cube20"]["FRONT"]["uvs"],x, y, z, block_info[side])
		create_faces("cube20", "RIGHT", block_data["cube20"]["vertices"],block_data["cube20"]["RIGHT"]["coords"],block_data["cube20"]["RIGHT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube20", "LEFT", block_data["cube20"]["vertices"],block_data["cube20"]["LEFT"]["coords"],block_data["cube20"]["LEFT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube20", "BACK", block_data["cube20"]["vertices"],block_data["cube20"]["BACK"]["coords"],block_data["cube20"]["BACK"]["uvs"], x, y, z, block_info[side])


	elif !check_transparent(chunk_pos.x+1,block_y,chunk_pos.z) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z+1) \
	&& check_transparent(chunk_pos.x-1,block_y,chunk_pos.z) && !check_transparent(chunk_pos.x,block_y+1,chunk_pos.z) && check_transparent(chunk_pos.x,block_y,chunk_pos.z-1): 
		create_faces("cube21","BOTTOM", block_data["cube21"]["vertices"],block_data["cube21"]["BOTTOM"]["coords"],block_data["cube21"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("cube21", "FRONT",block_data["cube21"]["vertices"],block_data["cube21"]["FRONT"]["coords"],block_data["cube21"]["FRONT"]["uvs"],x, y, z, block_info[side])
		create_faces("cube21", "RIGHT", block_data["cube21"]["vertices"],block_data["cube21"]["RIGHT"]["coords"],block_data["cube21"]["RIGHT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube21", "LEFT", block_data["cube21"]["vertices"],block_data["cube21"]["LEFT"]["coords"],block_data["cube21"]["LEFT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube21", "BACK", block_data["cube21"]["vertices"],block_data["cube21"]["BACK"]["coords"],block_data["cube21"]["BACK"]["uvs"], x, y, z, block_info[side])

	elif !check_transparent(chunk_pos.x, block_y+1, chunk_pos.z) && check_transparent(chunk_pos.x, block_y+2, chunk_pos.z):
		create_faces("default","BOTTOM", block_data["default"]["vertices"],block_data["default"]["BOTTOM"]["coords"],block_data["default"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("default", "FRONT", block_data["default"]["vertices"],block_data["default"]["FRONT"]["coords"],block_data["default"]["FRONT"]["uvs"], x, y, z, block_info[side])
		create_faces("default", "BACK", block_data["default"]["vertices"],block_data["default"]["BACK"]["coords"],block_data["default"]["BACK"]["uvs"], x, y, z, block_info[side])
		create_faces("default", "TOP", block_data["default"]["vertices"],block_data["default"]["TOP"]["coords"],block_data["default"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("default", "LEFT", block_data["default"]["vertices"],block_data["default"]["LEFT"]["coords"],block_data["default"]["LEFT"]["uvs"], x, y, z, block_info[side])
		create_faces("default", "RIGHT", block_data["default"]["vertices"],block_data["default"]["RIGHT"]["coords"],block_data["default"]["RIGHT"]["uvs"], x, y, z, block_info[side])
		
		#default
		for e in range(0,plant_number+2):
			for i in range(0,plant_number):
				rand_grass()
				create_grass1(1, 1, -0.86, 0, -0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf])
				rand_grass()
				create_grass2(1, 1, -0.9, 0.3, 0.12,plant_number, LEAF, e,i,x,y,z, block_info[leaf])

	elif !check_transparent(chunk_pos.x-1,block_y,chunk_pos.z) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z+1) && check_transparent(chunk_pos.x-1, block_y, chunk_pos.z+1) && \
	!check_transparent(chunk_pos.x,block_y,chunk_pos.z-1) && !check_transparent(chunk_pos.x+1,block_y,chunk_pos.z) && check_transparent(chunk_pos.x,block_y+1,chunk_pos.z):
		create_faces("fillcube1","BOTTOM", block_data["fillcube1"]["vertices"],block_data["fillcube1"]["BOTTOM"]["coords"],block_data["fillcube1"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("fillcube1", "FRONT", block_data["fillcube1"]["vertices"],block_data["fillcube1"]["FRONT"]["coords"],block_data["fillcube1"]["FRONT"]["uvs"], x, y, z, block_info[side])
		create_faces("fillcube1", "BACK", block_data["fillcube1"]["vertices"],block_data["fillcube1"]["BACK"]["coords"],block_data["fillcube1"]["BACK"]["uvs"], x, y, z, block_info[side])
		create_faces("fillcube1", "TOP", block_data["fillcube1"]["vertices"],block_data["fillcube1"]["TOP"]["coords"],block_data["fillcube1"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("fillcube1", "LEFT", block_data["fillcube1"]["vertices"],block_data["fillcube1"]["LEFT"]["coords"],block_data["fillcube1"]["LEFT"]["uvs"], x, y, z, block_info[side])
		create_faces("fillcube1", "RIGHT", block_data["fillcube1"]["vertices"],block_data["fillcube1"]["RIGHT"]["coords"],block_data["fillcube1"]["RIGHT"]["uvs"], x, y, z, block_info[side]) 

		#fillcube1
		for e in range(0,plant_number+2):
			for i in range(0,plant_number):
				rand_grass()
				create_grass1(1, 0.7,-0.88,0,-0.08,plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(0.1, 0.1,-0.84,-0.16,0.55,plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(0.7, 0.3,-0.68,0, 0.45,plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				
		rand_grass()
		create_fill_grass(-0.82,0.05,0.95,LEAF,x,y,z, block_info[leaf]) 
		rand_grass()
		create_fill_grass(-0.8,0.08,0.96,LEAF,x,y,z, block_info[leaf]) 
		rand_grass()
		create_fill_grass(-0.76,0.13,0.93,LEAF,x,y,z, block_info[leaf]) 
		rand_grass()
		create_fill_grass(-0.82,0.13,0.88,LEAF,x,y,z, block_info[leaf]) 
		
		rand_grass()
		create_fill_grass(-0.76,0.23,0.9,LEAF,x,y,z, block_info[leaf]) 
		rand_grass()
		create_fill_grass(-0.76,0.23,0.78,LEAF,x,y,z, block_info[leaf]) 
		rand_grass()
		create_fill_grass(-0.68,0.23,0.96,LEAF,x,y,z, block_info[leaf]) 
		rand_grass()
		create_fill_grass(-0.64,0.25,0.88,LEAF,x,y,z, block_info[leaf]) 
		
				
	elif !check_transparent(chunk_pos.x+1,block_y,chunk_pos.z) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z+1) && check_transparent(chunk_pos.x+1, block_y, chunk_pos.z+1) && \
	!check_transparent(chunk_pos.x,block_y,chunk_pos.z-1) && !check_transparent(chunk_pos.x-1,block_y,chunk_pos.z) && check_transparent(chunk_pos.x,block_y+1,chunk_pos.z):
		create_faces("fillcube2","BOTTOM", block_data["fillcube2"]["vertices"],block_data["fillcube2"]["BOTTOM"]["coords"],block_data["fillcube2"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("fillcube2", "FRONT", block_data["fillcube2"]["vertices"],block_data["fillcube2"]["FRONT"]["coords"],block_data["fillcube2"]["FRONT"]["uvs"], x, y, z, block_info[side])
		create_faces("fillcube2", "BACK", block_data["fillcube2"]["vertices"],block_data["fillcube2"]["BACK"]["coords"],block_data["fillcube2"]["BACK"]["uvs"], x, y, z, block_info[side])
		create_faces("fillcube2", "TOP", block_data["fillcube2"]["vertices"],block_data["fillcube2"]["TOP"]["coords"],block_data["fillcube2"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("fillcube2", "LEFT", block_data["fillcube2"]["vertices"],block_data["fillcube2"]["LEFT"]["coords"],block_data["fillcube2"]["LEFT"]["uvs"], x, y, z, block_info[side])
		create_faces("fillcube2", "RIGHT", block_data["fillcube2"]["vertices"],block_data["fillcube2"]["RIGHT"]["coords"],block_data["fillcube2"]["RIGHT"]["uvs"], x, y, z, block_info[side]) 

#fillcube2
		for e in range(0,plant_number+2):
			for i in range(0,plant_number):
				rand_grass()
				create_grass1(1, 0.7,-0.9,0,-0.1,plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(0.7, 0.3,-0.9,0, 0.48,plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(0.1, 0.1,-0.3,-0.15, 0.55,plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				
		rand_grass()
		create_fill_grass(0.1,0.05,0.95,LEAF,x,y,z, block_info[leaf]) 
		rand_grass()
		create_fill_grass(0.05,0.2,0.9,LEAF,x,y,z, block_info[leaf]) 
		rand_grass()
		create_fill_grass(-0.05,0.22,0.9,LEAF,x,y,z, block_info[leaf]) 
		rand_grass()
		create_fill_grass(0.1,0.22,0.85,LEAF,x,y,z, block_info[leaf]) 
		rand_grass()
		create_fill_grass(0.12,0.12,0.93,LEAF,x,y,z, block_info[leaf]) 
				
	elif  !check_transparent(chunk_pos.x-1,block_y,chunk_pos.z) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z-1) && check_transparent(chunk_pos.x-1, block_y, chunk_pos.z-1) && \
	!check_transparent(chunk_pos.x,block_y,chunk_pos.z+1) && !check_transparent(chunk_pos.x+1,block_y,chunk_pos.z) && check_transparent(chunk_pos.x,block_y+1,chunk_pos.z):
		create_faces("fillcube3","BOTTOM", block_data["fillcube3"]["vertices"],block_data["fillcube3"]["BOTTOM"]["coords"],block_data["fillcube3"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("fillcube3", "FRONT", block_data["fillcube3"]["vertices"],block_data["fillcube3"]["FRONT"]["coords"],block_data["fillcube3"]["FRONT"]["uvs"], x, y, z, block_info[side])
		create_faces("fillcube3", "BACK", block_data["fillcube3"]["vertices"],block_data["fillcube3"]["BACK"]["coords"],block_data["fillcube3"]["BACK"]["uvs"], x, y, z, block_info[side])
		create_faces("fillcube3", "TOP", block_data["fillcube3"]["vertices"],block_data["fillcube3"]["TOP"]["coords"],block_data["fillcube3"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("fillcube3", "LEFT", block_data["fillcube3"]["vertices"],block_data["fillcube3"]["LEFT"]["coords"],block_data["fillcube3"]["LEFT"]["uvs"], x, y, z, block_info[side])
		create_faces("fillcube3", "RIGHT", block_data["fillcube3"]["vertices"],block_data["fillcube3"]["RIGHT"]["coords"],block_data["fillcube3"]["RIGHT"]["uvs"], x, y, z, block_info[side]) 
		
		for e in range(0,plant_number+2):
				for i in range(0,plant_number):
					rand_grass()
					create_grass1(1, 0.7,-0.88,0,0.15,plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
					rand_grass()
					create_grass1(0.7, 0.1,-0.65,0, -0.05,plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
#
		rand_grass()
		create_fill_grass(-0.8,0.05,0.05,LEAF,x,y,z, block_info[leaf]) 
		rand_grass()
		create_fill_grass(-0.77,0.15,0.08,LEAF,x,y,z, block_info[leaf]) 
		rand_grass()
		create_fill_grass(-0.7,0.15,0.08,LEAF,x,y,z, block_info[leaf]) 
		rand_grass()
		create_fill_grass(-0.62,0.22,0.08,LEAF,x,y,z, block_info[leaf]) 
		rand_grass()
		create_fill_grass(-0.76,0.22,0.18,LEAF,x,y,z, block_info[leaf]) 
				
	elif  !check_transparent(chunk_pos.x+1,block_y,chunk_pos.z) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z-1) && check_transparent(chunk_pos.x+1, block_y, chunk_pos.z-1) && \
	!check_transparent(chunk_pos.x,block_y,chunk_pos.z+1) && !check_transparent(chunk_pos.x-1,block_y,chunk_pos.z) && check_transparent(chunk_pos.x,block_y+1,chunk_pos.z):
		create_faces("fillcube4","BOTTOM", block_data["fillcube4"]["vertices"],block_data["fillcube4"]["BOTTOM"]["coords"],block_data["fillcube4"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("fillcube4", "FRONT", block_data["fillcube4"]["vertices"],block_data["fillcube4"]["FRONT"]["coords"],block_data["fillcube4"]["FRONT"]["uvs"], x, y, z, block_info[side])
		create_faces("fillcube4", "BACK", block_data["fillcube4"]["vertices"],block_data["fillcube4"]["BACK"]["coords"],block_data["fillcube4"]["BACK"]["uvs"], x, y, z, block_info[side])
		create_faces("fillcube4", "TOP", block_data["fillcube4"]["vertices"],block_data["fillcube4"]["TOP"]["coords"],block_data["fillcube4"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("fillcube4", "LEFT", block_data["fillcube4"]["vertices"],block_data["fillcube4"]["LEFT"]["coords"],block_data["fillcube4"]["LEFT"]["uvs"], x, y, z, block_info[side])
		create_faces("fillcube4", "RIGHT", block_data["fillcube4"]["vertices"],block_data["fillcube4"]["RIGHT"]["coords"],block_data["fillcube4"]["RIGHT"]["uvs"], x, y, z, block_info[side])

		#fillcube4
		for e in range(0,plant_number+2):
			for i in range(0,plant_number):
				rand_grass()
				create_grass1(1, 0.7,-0.88,0,0.1,plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(0.7, 0.3,-0.85,0, -0.05,plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(0.1, 0.1,-0.33,-0.17, 0,plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 

		rand_grass()
		create_fill_grass(0.15,0.05,0.1,LEAF,x,y,z, block_info[leaf]) 
		rand_grass()
		create_fill_grass(0.05,0.18,0.05,LEAF,x,y,z, block_info[leaf]) 
		rand_grass()
		create_fill_grass(0.1,0.18,0.15,LEAF,x,y,z, block_info[leaf]) 
		rand_grass()
		create_fill_grass(0.1,0.21,0.22,LEAF,x,y,z, block_info[leaf]) 

	elif check_transparent(chunk_pos.x-1, block_y, chunk_pos.z) && check_transparent(chunk_pos.x, block_y+1, chunk_pos.z) && check_transparent(chunk_pos.x, block_y, chunk_pos.z+1) && \
	!check_transparent(chunk_pos.x+1,block_y,chunk_pos.z) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z-1):
		create_faces("cube5", "TOP",block_data["cube5"]["vertices"],block_data["cube5"]["TOP"]["coords"],block_data["cube5"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("cube5","BOTTOM", block_data["cube5"]["vertices"],block_data["cube5"]["BOTTOM"]["coords"],block_data["cube5"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("cube5", "FRONT",block_data["cube5"]["vertices"],block_data["cube5"]["FRONT"]["coords"],block_data["cube5"]["FRONT"]["uvs"],x, y, z, block_info[side])
		create_faces("cube5", "BACK", block_data["cube5"]["vertices"],block_data["cube5"]["BACK"]["coords"],block_data["cube5"]["BACK"]["uvs"], x, y, z, block_info[side])
		create_faces("cube5", "LEFT",block_data["cube5"]["vertices"],block_data["cube5"]["LEFT"]["coords"],block_data["cube5"]["LEFT"]["uvs"],x, y, z, block_info[side])
		create_faces("cube5", "RIGHT", block_data["cube5"]["vertices"],block_data["cube5"]["RIGHT"]["coords"],block_data["cube5"]["RIGHT"]["uvs"], x, y, z, block_info[side])

#cube5
		for e in range(0,plant_number+2):
			for i in range(0,plant_number):
				rand_grass()
				create_grass1(0.7,0.7,-0.65,0,-0.1,plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(0.8,0.1,-0.7,-0.2,0.55,plant_number, LEAF, e,i,x,y,z, block_info[leaf])  
				rand_grass()
				create_grass1(0.1,0.8,-0.86,-0.2,-0.1,plant_number, LEAF, e,i,x,y,z, block_info[leaf])	
				
				rand_grass()
				create_grass2(0.8,0.1,-0.65,0.12,0.77,plant_number, LEAF, e,i,x,y,z, block_info[leaf])
				rand_grass()
				create_grass2(0.85,0.1,-0.75,-0.05,0.92,plant_number, LEAF, e,i,x,y,z, block_info[leaf])
				rand_grass()
				create_grass2(0.1,0.85,-0.95,-0.1,0.1,plant_number, LEAF, e,i,x,y,z, block_info[leaf])
		
	elif check_transparent(chunk_pos.x+1, block_y, chunk_pos.z) && check_transparent(chunk_pos.x, block_y+1, chunk_pos.z) && check_transparent(chunk_pos.x, block_y, chunk_pos.z+1) && \
	!check_transparent(chunk_pos.x-1,block_y,chunk_pos.z) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z-1):
		create_faces("cube6", "TOP",block_data["cube6"]["vertices"],block_data["cube6"]["TOP"]["coords"],block_data["cube6"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("cube6","BOTTOM", block_data["cube6"]["vertices"],block_data["cube6"]["BOTTOM"]["coords"],block_data["cube6"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("cube6", "FRONT",block_data["cube6"]["vertices"],block_data["cube6"]["FRONT"]["coords"],block_data["cube6"]["FRONT"]["uvs"],x, y, z, block_info[side])
		create_faces("cube6", "RIGHT", block_data["cube6"]["vertices"],block_data["cube6"]["RIGHT"]["coords"],block_data["cube6"]["RIGHT"]["uvs"], x, y, z, block_info[side])

			#cube6
		for e in range(0,plant_number+2):
			for i in range(0,plant_number):
				rand_grass()
				create_grass1(0.7,0.7,-0.9,0,-0.1,plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(0.8,0.1,-0.9,-0.2,0.6,plant_number, LEAF, e,i,x,y,z, block_info[leaf])  
				rand_grass()
				create_grass1(0.1,0.8,-0.3,-0.2,-0.1,plant_number, LEAF, e,i,x,y,z, block_info[leaf])
				
				rand_grass()
				create_grass2(0.8,0.1,-0.9,0.12,0.77,plant_number, LEAF, e,i,x,y,z, block_info[leaf])
				rand_grass()
				create_grass2(0.85,0.1,-0.85,-0.08,0.92,plant_number, LEAF, e,i,x,y,z, block_info[leaf])
				rand_grass()
				create_grass2(0.1,0.85,-0.1,-0.1,0.1,plant_number, LEAF, e,i,x,y,z, block_info[leaf])
		
	elif check_transparent(chunk_pos.x+1, block_y, chunk_pos.z) && check_transparent(chunk_pos.x, block_y+1, chunk_pos.z) && check_transparent(chunk_pos.x, block_y, chunk_pos.z-1) && \
	!check_transparent(chunk_pos.x,block_y,chunk_pos.z+1) && !check_transparent(chunk_pos.x-1,block_y,chunk_pos.z):
		create_faces("cube7", "TOP",block_data["cube7"]["vertices"],block_data["cube7"]["TOP"]["coords"],block_data["cube7"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("cube7","BOTTOM", block_data["cube7"]["vertices"],block_data["cube7"]["BOTTOM"]["coords"],block_data["cube7"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("cube7", "BACK",block_data["cube7"]["vertices"],block_data["cube7"]["BACK"]["coords"],block_data["cube7"]["BACK"]["uvs"],x, y, z, block_info[side])
		create_faces("cube7", "RIGHT", block_data["cube7"]["vertices"],block_data["cube7"]["RIGHT"]["coords"],block_data["cube7"]["RIGHT"]["uvs"], x, y, z, block_info[side])
	

			#cube7
		for e in range(0,plant_number+2):
			for i in range(0,plant_number):
				rand_grass()
				create_grass1(0.7,0.7,-0.9,0,0.2,plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(0.8,0.1,-0.9,-0.2,-0.05,plant_number, LEAF, e,i,x,y,z, block_info[leaf])  
				rand_grass()
				create_grass1(0.1,0.8,-0.28,-0.2,0.08,plant_number, LEAF, e,i,x,y,z, block_info[leaf])

				rand_grass()
				create_grass2(0.8,0.1,-0.9,0.12,0.18,plant_number, LEAF, e,i,x,y,z, block_info[leaf])
				rand_grass()
				create_grass2(0.85,0.1,-0.85,-0.08,0,plant_number, LEAF, e,i,x,y,z, block_info[leaf])
				rand_grass()
				create_grass2(0.1,0.85,-0.12,-0.1,0.23,plant_number, LEAF, e,i,x,y,z, block_info[leaf])
		
	elif check_transparent(chunk_pos.x-1, block_y, chunk_pos.z) && check_transparent(chunk_pos.x, block_y+1, chunk_pos.z) && !check_transparent(chunk_pos.x, block_y, chunk_pos.z+1) && \
	!check_transparent(chunk_pos.x+1,block_y,chunk_pos.z) && check_transparent(chunk_pos.x,block_y,chunk_pos.z-1):
		create_faces("cube8", "TOP",block_data["cube8"]["vertices"],block_data["cube8"]["TOP"]["coords"],block_data["cube8"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("cube8","BOTTOM", block_data["cube8"]["vertices"],block_data["cube8"]["BOTTOM"]["coords"],block_data["cube8"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("cube8", "BACK",block_data["cube8"]["vertices"],block_data["cube8"]["BACK"]["coords"],block_data["cube8"]["BACK"]["uvs"],x, y, z, block_info[side])
		create_faces("cube8", "LEFT", block_data["cube8"]["vertices"],block_data["cube8"]["LEFT"]["coords"],block_data["cube8"]["LEFT"]["uvs"], x, y, z, block_info[side])
	
			#cube8
		for e in range(0,plant_number+2):
			for i in range(0,plant_number):
				rand_grass()
				create_grass1(0.7,0.7,-0.63,0,0.2,plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(0.8,0.1,-0.75,-0.2,-0.05,plant_number, LEAF, e,i,x,y,z, block_info[leaf])  
				rand_grass()
				create_grass1(0.1,0.8,-0.86,-0.2,0.08,plant_number, LEAF, e,i,x,y,z, block_info[leaf])
				
				rand_grass()
				create_grass2(0.8,0.1,-0.72,0.12,0.15,plant_number, LEAF, e,i,x,y,z, block_info[leaf])
				rand_grass()
				create_grass2(0.85,0.1,-0.72,-0.08,0,plant_number, LEAF, e,i,x,y,z, block_info[leaf])
				rand_grass()
				create_grass2(0.1,0.85,-1.03,-0.1,0.23,plant_number, LEAF, e,i,x,y,z, block_info[leaf])
				
	elif !check_transparent(chunk_pos.x,block_y,chunk_pos.z+1) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z-1) && check_transparent(chunk_pos.x+1,block_y,chunk_pos.z) &&\
	check_transparent(chunk_pos.x-1,block_y,chunk_pos.z) && check_transparent(chunk_pos.x,block_y+1,chunk_pos.z):
		create_faces("cube22","BOTTOM", block_data["cube22"]["vertices"],block_data["cube22"]["BOTTOM"]["coords"],block_data["cube22"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("cube22", "RIGHT", block_data["cube22"]["vertices"],block_data["cube22"]["RIGHT"]["coords"],block_data["cube22"]["RIGHT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube22", "LEFT", block_data["cube22"]["vertices"],block_data["cube22"]["LEFT"]["coords"],block_data["cube22"]["LEFT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube22", "TOP", block_data["cube22"]["vertices"],block_data["cube22"]["TOP"]["coords"],block_data["cube22"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])


		for e in range(0,plant_number+2):
			for i in range(0,plant_number):
				#block22
				rand_grass()
				create_grass1(0.3, 1, -0.6, 0, -0.05, plant_number, LEAF, e,i,x,y,z, block_info[leaf])  
				rand_grass()
				create_grass1(0.2, 1, -0.35, -0.22, -0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(0.1, 1, -0.88, -0.22, -0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				
				rand_grass()
				create_grass2(0.1, 1, -1, -0.07, 0.08, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass2(0.1, 1, -0.12, -0.07, 0.08, plant_number, LEAF, e,i,x,y,z, block_info[leaf])
				rand_grass()
				create_grass2(0.1, 0.7, -0.95, -0.1, 0.2, plant_number, LEAF, e,i,x,y,z, block_info[leaf])
				rand_grass()
				create_grass2(0.7, 0.1, -0.78, -0.1, 0, plant_number, LEAF, e,i,x,y,z, block_info[leaf])

	elif check_transparent(chunk_pos.x,block_y,chunk_pos.z+1) && check_transparent(chunk_pos.x,block_y,chunk_pos.z-1) && check_transparent(chunk_pos.x,block_y+1,chunk_pos.z) &&\
	!check_transparent(chunk_pos.x-1,block_y,chunk_pos.z) && !check_transparent(chunk_pos.x+1,block_y,chunk_pos.z):
		create_faces("cube23","BOTTOM", block_data["cube23"]["vertices"],block_data["cube23"]["BOTTOM"]["coords"],block_data["cube23"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("cube23", "FRONT", block_data["cube23"]["vertices"],block_data["cube23"]["FRONT"]["coords"],block_data["cube23"]["FRONT"]["uvs"], x, y, z, block_info[side])
		create_faces("cube23", "BACK", block_data["cube23"]["vertices"],block_data["cube23"]["BACK"]["coords"],block_data["cube23"]["BACK"]["uvs"], x, y, z, block_info[side])
		create_faces("cube23", "TOP", block_data["cube23"]["vertices"],block_data["cube23"]["TOP"]["coords"],block_data["cube23"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
	
		for e in range(0,plant_number+2):
				for i in range(0,plant_number):
					#block23
					rand_grass()
					create_grass1(1, 0.3, -0.92, 0, 0.15, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
					rand_grass()
					create_grass1(1, 0.1, -0.92, -0.22, -0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
					rand_grass()
					create_grass1(1, 0.1, -0.92, -0.22, 0.6, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
	#				
					rand_grass()
					create_grass2(1, 0.1, -0.92, -0.07, 0, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
					rand_grass()
					create_grass2(1, 0.1, -0.92, -0.07, 0.9, plant_number, LEAF, e,i,x,y,z, block_info[leaf])
					
	elif check_transparent(chunk_pos.x, block_y+1, chunk_pos.z) && check_transparent(chunk_pos.x-1, block_y, chunk_pos.z) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z+1) && \
	!check_transparent(chunk_pos.x,block_y,chunk_pos.z-1) && !check_transparent(chunk_pos.x+1,block_y,chunk_pos.z):
		create_faces("cube1", "TOP",block_data["cube1"]["vertices"],block_data["cube1"]["TOP"]["coords"],block_data["cube1"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("cube1","BOTTOM", block_data["cube1"]["vertices"],block_data["cube1"]["BOTTOM"]["coords"],block_data["cube1"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("cube1", "LEFT",block_data["cube1"]["vertices"],block_data["cube1"]["LEFT"]["coords"],block_data["cube1"]["LEFT"]["uvs"],x, y, z, block_info[side])
		create_faces("cube1", "RIGHT", block_data["cube1"]["vertices"],block_data["cube1"]["RIGHT"]["coords"],block_data["cube1"]["RIGHT"]["uvs"], x, y, z, block_info[side])

			#block1
		for e in range(0,plant_number+2):
			for i in range(0,plant_number):
				rand_grass()
				create_grass1(0.7, 1, -0.8, 0, -0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf])  
				rand_grass()
				create_grass2(0.7, 1, -0.55, 0.3, 0.1,plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				
				rand_grass()
				create_grass2(0.2, 1, -0.85, 0.2, 0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass2(0.2, 1, -1.05, 0.05, 0.1,plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(0.2, 1, -0.9, -0.1, -0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
						
	elif check_transparent(chunk_pos.x, block_y+1, chunk_pos.z) && check_transparent(chunk_pos.x+1, block_y, chunk_pos.z) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z+1) && !check_transparent(chunk_pos.x,block_y,chunk_pos.z-1) && \
	!check_transparent(chunk_pos.x-1,block_y,chunk_pos.z):
		create_faces("cube2", "TOP",block_data["cube2"]["vertices"],block_data["cube2"]["TOP"]["coords"],block_data["cube2"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("cube2","BOTTOM", block_data["cube2"]["vertices"],block_data["cube2"]["BOTTOM"]["coords"],block_data["cube2"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("cube2", "LEFT",block_data["cube2"]["vertices"],block_data["cube2"]["LEFT"]["coords"],block_data["cube2"]["LEFT"]["uvs"],x, y, z, block_info[side])
		create_faces("cube2", "RIGHT", block_data["cube2"]["vertices"],block_data["cube2"]["RIGHT"]["coords"],block_data["cube2"]["RIGHT"]["uvs"], x, y, z, block_info[side])

			#block2
		for e in range(0,plant_number+2):
			for i in range(0,plant_number):
				rand_grass()
				create_grass1(0.7, 1, -0.95, 0, -0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass2(0.7, 1, -0.78, 0.25, 0.1,plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 

				rand_grass()
				create_grass2(0.2, 1, -0.15, 0.2, 0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass2(0.2, 1, 0, 0,0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(0.2, 1, -0.3, -0.15, -0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
		
	elif check_transparent(chunk_pos.x, block_y+1, chunk_pos.z) && check_transparent(chunk_pos.x, block_y, chunk_pos.z+1) && !check_transparent(chunk_pos.x+1,block_y,chunk_pos.z) && !check_transparent(chunk_pos.x-1,block_y,chunk_pos.z):
		create_faces("cube3", "TOP",block_data["cube3"]["vertices"],block_data["cube3"]["TOP"]["coords"],block_data["cube3"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("cube3","BOTTOM", block_data["cube3"]["vertices"],block_data["cube3"]["BOTTOM"]["coords"],block_data["cube3"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("cube3", "FRONT",block_data["cube3"]["vertices"],block_data["cube3"]["FRONT"]["coords"],block_data["cube3"]["FRONT"]["uvs"],x, y, z, block_info[side])
		create_faces("cube3", "BACK", block_data["cube3"]["vertices"],block_data["cube3"]["BACK"]["coords"],block_data["cube3"]["BACK"]["uvs"], x, y, z, block_info[side])


		for e in range(0,plant_number+2):
			for i in range(0,plant_number):
				#block3
				rand_grass()
				create_grass1(1, 0.3, -0.9, 0, -0.12, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				 
				rand_grass()
				create_grass2(1, 0.2, -0.85, 0.1, 0.7,plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass2(1, 0.2, -0.85, -0.05, 0.85,plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(1, 0.2,-0.87, -0.1, 0.3 ,plant_number, LEAF, e,i,x,y,z, block_info[leaf])

	elif check_transparent(chunk_pos.x, block_y+1,chunk_pos.z) && check_transparent(chunk_pos.x, block_y, chunk_pos.z-1) && !check_transparent(chunk_pos.x-1,block_y,chunk_pos.z) && !check_transparent(chunk_pos.x+1,block_y,chunk_pos.z) && \
	!check_transparent(chunk_pos.x,block_y,chunk_pos.z+1):
		create_faces("cube4", "TOP",block_data["cube4"]["vertices"],block_data["cube4"]["TOP"]["coords"],block_data["cube4"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("cube4","BOTTOM", block_data["cube4"]["vertices"],block_data["cube4"]["BOTTOM"]["coords"],block_data["cube4"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("cube4", "FRONT",block_data["cube4"]["vertices"],block_data["cube4"]["FRONT"]["coords"],block_data["cube4"]["FRONT"]["uvs"],x, y, z, block_info[side])
		create_faces("cube4", "BACK", block_data["cube4"]["vertices"],block_data["cube4"]["BACK"]["coords"],block_data["cube4"]["BACK"]["uvs"], x, y, z, block_info[side])
		
		for e in range(0,plant_number+2):
			for i in range(0,plant_number):
				#block4
				rand_grass()
				create_grass1(1, 0.7, -0.88, 0, 0.2, plant_number, LEAF, e,i,x,y,z, block_info[leaf])
				rand_grass()
				create_grass2(1, 0.7, -0.88, 0.3, 0.35,plant_number, LEAF, e,i,x,y,z, block_info[leaf])   

				rand_grass()
				create_grass2(1, 0.2, -0.88, 0.2, 0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass2(1, 0.7, -0.88, 0.3, 0.35,plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass2(1, 0.2, -0.88, 0.05, 0,plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
				rand_grass()
				create_grass1(1, 0.2, -0.88, -0.1, 0,plant_number, LEAF, e,i,x,y,z, block_info[leaf]) 
	else: 
		create_faces("default", "TOP", block_data["default"]["vertices"],block_data["default"]["TOP"]["coords"],block_data["default"]["TOP"]["uvs"], x, y, z, block_info[Global.TOP])
		create_faces("default","BOTTOM", block_data["default"]["vertices"],block_data["default"]["BOTTOM"]["coords"],block_data["default"]["BOTTOM"]["uvs"], x, y, z, block_info[Global.BOTTOM])
		create_faces("default", "FRONT", block_data["default"]["vertices"],block_data["default"]["FRONT"]["coords"],block_data["default"]["FRONT"]["uvs"], x, y, z, block_info[side])
		create_faces("default", "BACK", block_data["default"]["vertices"],block_data["default"]["BACK"]["coords"],block_data["default"]["BACK"]["uvs"], x, y, z, block_info[side])
		create_faces("default", "LEFT", block_data["default"]["vertices"],block_data["default"]["LEFT"]["coords"],block_data["default"]["LEFT"]["uvs"], x, y, z, block_info[side])
		create_faces("default", "RIGHT", block_data["default"]["vertices"],block_data["default"]["RIGHT"]["coords"],block_data["default"]["RIGHT"]["uvs"], x, y, z, block_info[side])

		for e in range(0,plant_number+2):
					for i in range(0,plant_number):
						rand_grass()
						create_grass1(1, 1, -0.86, 0, -0.1, plant_number, LEAF, e,i,x,y,z, block_info[leaf])
						rand_grass()
						create_grass2(1, 1, -0.9, 0.3, 0.12,plant_number, LEAF, e,i,x,y,z, block_info[leaf])
						
func create_faces(cubenr, type, vertices_type, dir, uv_arr, x,y,z,texture_atlas_offset):
	var offset = Vector3(x, y, z)
	var uv_offset = texture_atlas_offset / Global.TEXTURE_ATLAS_SIZE
	
	
	var array_size = dir.size()-1; 
		
	if 0 <= array_size:
		a_ = vertices_type[dir[0]]+offset; 
	if 1 <= array_size:
		b_ = vertices_type[dir[1]]+offset; 
	if 2 <= array_size:
		c_ = vertices_type[dir[2]]+offset;
	if 3 <= array_size:
		d_ = vertices_type[dir[3]]+offset; 
	if 4 <= array_size:
		e_ = vertices_type[dir[4]]+offset; 
	if 5 <= array_size:
		f_ = vertices_type[dir[5]]+offset; 
	if 6 <= array_size:
		g_ = vertices_type[dir[6]]+offset; 
	if 7 <= array_size:
		h_ = vertices_type[dir[7]]+offset; 
	if 8 <= array_size:
		i_ = vertices_type[dir[8]]+offset; 
	if 9 <= array_size:
		j_ = vertices_type[dir[9]]+offset; 
	if 10 <= array_size:
		k_ = vertices_type[dir[10]]+offset; 
	if 11 <= array_size:
		l_ = vertices_type[dir[11]]+offset; 
	if 12 <= array_size:
		m_ = vertices_type[dir[12]]+offset; 
	if 13 <= array_size:
		n_ = vertices_type[dir[13]]+offset; 
	if 14 <= array_size:
		o_ = vertices_type[dir[14]]+offset; 
	if 15 <= array_size:
		p_ = vertices_type[dir[15]]+offset; 
	if 16 <= array_size:
		q_ = vertices_type[dir[16]]+offset; 
	if 17 <= array_size:
		r_ = vertices_type[dir[17]]+offset; 
	if 18 <= array_size:
		s_ = vertices_type[dir[18]]+offset; 
	if 19 <= array_size:
		t_ = vertices_type[dir[19]]+offset; 
	if 20 <= array_size:
		u_ = vertices_type[dir[20]]+offset; 
	if 21 <= array_size:
		v_ = vertices_type[dir[21]]+offset; 
	if 22 <= array_size:
		w_ = vertices_type[dir[22]]+offset; 
	if 23 <= array_size:
		x_ = vertices_type[dir[23]]+offset; 
	if 24 <= array_size:
		y_ = vertices_type[dir[24]]+offset; 
	if 25 <= array_size:
		z_ = vertices_type[dir[25]]+offset; 
	if 26 <= array_size:
		aa_ = vertices_type[dir[26]]+offset; 
	if 27 <= array_size:
		ab_ = vertices_type[dir[27]]+offset; 
		
	if 0 <= array_size:
		uv_a = uv_arr[0]+uv_offset; 
	if 1 <= array_size:
		uv_b = uv_arr[1]+uv_offset; 
	if 2 <= array_size:
		uv_c = uv_arr[2]+uv_offset;
	if 3 <= array_size:
		uv_d = uv_arr[3]+uv_offset; 
	if 4 <= array_size:
		uv_e = uv_arr[4]+uv_offset; 
	if 5 <= array_size:
		uv_f = uv_arr[5]+uv_offset; 
	if 6 <= array_size:
		uv_g = uv_arr[6]+uv_offset; 
	if 7 <= array_size:
		uv_h = uv_arr[7]+uv_offset; 
	if 8 <= array_size:
		uv_i = uv_arr[8]+uv_offset; 
	if 9 <= array_size:
		uv_j = uv_arr[9]+uv_offset; 
	if 10 <= array_size:
		uv_k = uv_arr[10]+uv_offset; 
	if 11 <= array_size:
		uv_l = uv_arr[11]+uv_offset; 
	if 12 <= array_size:
		uv_m =uv_arr[12]+uv_offset; 
	if 13 <= array_size:
		uv_n = uv_arr[13]+uv_offset; 
	if 14 <= array_size:
		uv_o = uv_arr[14]+uv_offset; 
	if 15 <= array_size:
		uv_p = uv_arr[15]+uv_offset; 
	if 16 <= array_size:
		uv_q = uv_arr[16]+uv_offset; 
	if 17 <= array_size:
		uv_r = uv_arr[17]+uv_offset; 
	if 18 <= array_size:
		uv_s = uv_arr[18]+uv_offset; 
	if 19 <= array_size:
		uv_t = uv_arr[19]+uv_offset; 
	if 20 <= array_size:
		uv_u = uv_arr[20]+uv_offset; 
	if 21 <= array_size:
		uv_v = uv_arr[21]+uv_offset; 
	if 22 <= array_size:
		uv_w = uv_arr[22]+uv_offset 
	if 23 <= array_size:
		uv_x = uv_arr[23]+uv_offset; 
	if 24 <= array_size:
		uv_y = uv_arr[24]+uv_offset; 
	if 25 <= array_size:
		uv_z =uv_arr[25]+uv_offset; 
	if 26 <= array_size:
		uv_aa = uv_arr[26]+uv_offset
	if 27 <= array_size:
		uv_ab = uv_arr[27]+uv_offset
		
	var triangles={
	"cube1":{
			"BOTTOM":{
				"triangles":[
					[b_, c_, a_, uv_b, uv_c, uv_a],
					[d_, c_, b_, uv_d, uv_c, uv_b]
					]
			},
			"LEFT":{
				"triangles":[
					[b_, c_, a_,uv_b, uv_c, uv_a],
					[d_, c_, b_,uv_d, uv_c, uv_b]
					]
			},
			"RIGHT":{
				"triangles":[
					[a_, c_, b_,uv_a, uv_c, uv_b],
					[b_, c_, d_,uv_b, uv_c, uv_d]
					]
			},
			"TOP":{
				"triangles":[
					[b_, e_, a_,uv_b, uv_e, uv_a],
					[f_, e_, b_,uv_f, uv_e, uv_b],
					[f_, b_, c_,uv_f, uv_b, uv_c],
					[g_, f_, c_,uv_g, uv_f, uv_c],
					[c_, d_, g_,uv_c, uv_d, uv_g],
					[h_, g_, d_,uv_h, uv_g, uv_d]
					]
			}},
	"cube2":{
			"BOTTOM":{
				"triangles":[
					[a_, c_, b_, uv_a, uv_c, uv_b],
					[b_, c_, d_,uv_b, uv_c, uv_d]
					]
			},
			"LEFT":{
				"triangles":[
					[b_, c_, a_,uv_b, uv_c, uv_a],
					[d_, c_, b_,uv_d, uv_c, uv_b]
					]
			},
			"RIGHT":{
				"triangles":[
					[a_, c_, b_,uv_a, uv_c, uv_b],
					[b_, c_, d_,uv_b, uv_c, uv_d]
					]
			},
			"TOP":{
				"triangles":[
					[a_, e_, b_,uv_a, uv_e, uv_b],
					[b_, e_, f_,uv_b, uv_e, uv_f],
					[c_, b_, f_,uv_c, uv_b, uv_f],
					[c_, f_, g_,uv_c, uv_f, uv_g],
					[g_, d_, c_,uv_g, uv_d, uv_c],
					[d_, g_, h_,uv_d, uv_g, uv_h]
					]
			}},

	"cube3":{
			"BOTTOM":{
				"triangles":[
					[b_, c_, a_,uv_b, uv_c, uv_a],
					[d_, c_, b_,uv_d, uv_c, uv_b]
					]
			},
			"FRONT":{
				"triangles":[
					[b_, c_, a_,uv_b, uv_c, uv_a],
					[d_, c_, b_,uv_d, uv_c, uv_b]
					]
			},
			"BACK":{
				"triangles":[
					[a_, c_, b_,uv_a, uv_c, uv_b],
					[b_, c_, d_,uv_b, uv_c, uv_d]
					]
			},
			"TOP":{
				"triangles":[
					[b_, e_, a_,uv_b, uv_e, uv_a],
					[f_, e_, b_,uv_f, uv_e, uv_b],
					[f_, b_, c_,uv_f, uv_b, uv_c],
					[g_, f_, c_,uv_g, uv_f, uv_c],
					[c_, d_, g_,uv_c, uv_d, uv_g],
					[h_, g_, d_,uv_h, uv_g, uv_d]
					]
			}},
	"cube4":{
			"BOTTOM":{
				"triangles":[
						[a_, c_, b_,uv_a, uv_c, uv_b],
						[b_, c_, d_,uv_b, uv_c, uv_d]
					]
			},
			"FRONT":{
				"triangles":[
						[b_, c_, a_,uv_b, uv_c, uv_a],
						[d_, c_, b_,uv_d, uv_c, uv_b]
					]
			},
			"BACK":{
				"triangles":[
					[a_, c_, b_,uv_a, uv_c, uv_b],
					[b_, c_, d_,uv_b, uv_c, uv_d]
					]
			},
			"TOP":{
				"triangles":[
					[a_, e_, b_,uv_a, uv_e, uv_b],
					[b_, e_, f_,uv_b, uv_e, uv_f],
					[c_, b_, f_,uv_c, uv_b, uv_f],
					[c_, f_, g_,uv_c, uv_f, uv_g],
					[g_, d_, c_,uv_g, uv_d, uv_c],
					[d_, g_, h_,uv_d, uv_g, uv_h]
					]
			}},
	"cube5":{
			"BOTTOM":{
				"triangles":[
						[f_, b_, a_,uv_f, uv_b, uv_a],
						[a_, c_, d_,uv_a, uv_c, uv_d],
						[a_, d_, e_,uv_a, uv_d, uv_e],
						[a_, e_, f_,uv_a, uv_e, uv_f]
					]
			},
			"FRONT":{
				"triangles":[
						[h_, b_, a_,uv_h, uv_b, uv_a],
						[h_, g_, b_,uv_h, uv_g, uv_b],
						[g_, c_, b_,uv_g, uv_c, uv_b],
						[g_, f_, c_,uv_g, uv_f, uv_c],
						[f_, d_, c_,uv_f, uv_d, uv_c],
						[f_, e_, d_,uv_f, uv_e, uv_d]
					]
			},
			"BACK":{
				"triangles":[
						[a_, b_ ,c_,uv_a, uv_b, uv_c],
						[a_, c_, d_,uv_a, uv_c, uv_d],
						[a_, d_, e_,uv_a, uv_d, uv_e],
						[a_, e_, f_,uv_a, uv_e, uv_f]
					]
			},
			"LEFT":{
				"triangles":[
						[b_, c_, a_,uv_b, uv_c, uv_a],
						[d_, c_, b_,uv_d, uv_c, uv_b]
					]
			},
			"RIGHT":{
				"triangles":[
						[f_, b_, a_,uv_f, uv_b, uv_a],
						[a_, e_, f_,uv_a, uv_e, uv_f],
						[a_, d_, e_,uv_a, uv_d, uv_e],
						[a_, c_, d_,uv_a, uv_c, uv_d]
					]
			},
			"TOP":{
				"triangles":[
						[h_, b_, a_,uv_h, uv_b, uv_a],
						[a_, g_, h_,uv_a, uv_g, uv_h],
						[b_, h_, m_,uv_b, uv_h, uv_m],
						[m_, c_, b_,uv_m, uv_c, uv_b],
						[c_, m_, n_,uv_c, uv_m, uv_n],
						[n_, d_, c_,uv_n, uv_d, uv_c],
						[n_, m_, l_,uv_n, uv_m, uv_l],
						[l_, m_, k_,uv_l, uv_m, uv_k],
						[h_, k_, m_,uv_h, uv_k, uv_m],
						[h_, i_, k_,uv_h, uv_i, uv_k],
						[k_, i_, l_,uv_k, uv_i, uv_l],
						[i_, j_, l_,uv_i, uv_j, uv_l],
						[i_, h_, g_,uv_i, uv_h, uv_g],
						[i_, g_, f_,uv_i, uv_g, uv_f],
						[f_, j_, i_,uv_f, uv_j, uv_i],
						[j_, f_, e_,uv_j, uv_f, uv_e]
					]
			}},
		"cube6":{
			"BOTTOM":{
				"triangles":[
						[f_, b_, a_,uv_f, uv_b, uv_a],
						[a_, c_, d_,uv_a, uv_c, uv_d],
						[a_, d_, e_,uv_a, uv_d, uv_e],
						[a_, e_, f_,uv_a, uv_e, uv_f]
					]
			},
			"FRONT":{
				"triangles":[
						[a_, b_, h_,uv_a, uv_b, uv_h],
						[b_, g_, h_,uv_b, uv_g, uv_h],
						[b_, c_, g_,uv_b, uv_c, uv_g],
						[c_, f_, g_,uv_c, uv_f, uv_g],
						[c_, d_, f_,uv_c, uv_d, uv_f],
						[d_, e_, f_,uv_d, uv_e, uv_f]
					]
			},
			"BACK":{
				"triangles":[
						[c_, b_ ,a_,uv_c, uv_b, uv_a],
						[d_, c_, a_,uv_d, uv_c, uv_a],
						[e_, d_, a_,uv_e, uv_d, uv_a],
						[f_, e_, a_,uv_f, uv_e, uv_a]
					]
			},
			"LEFT":{
				"triangles":[
						[a_, b_, f_,uv_a, uv_b, uv_f],
						[f_, e_, a_,uv_f, uv_e, uv_a],
						[e_, d_, a_,uv_e, uv_d, uv_a],
						[d_, c_, a_,uv_d, uv_c, uv_a]
					]
			},
			"RIGHT":{
				"triangles":[
						[a_, c_, b_,uv_a, uv_c, uv_b],
						[b_, c_, d_,uv_b, uv_c, uv_d]
					]
			},
			"TOP":{
				"triangles":[
						[a_, b_, h_,uv_a, uv_b, uv_h],
						[h_, g_, a_,uv_h, uv_g, uv_a],
						[m_, h_, b_,uv_m, uv_h, uv_b],
						[b_, c_, m_,uv_b, uv_c, uv_m],
						[n_, m_, c_,uv_n, uv_m, uv_c],
						[c_, d_, n_,uv_c, uv_d, uv_n],
						[l_, m_, n_,uv_l, uv_m, uv_n],
						[k_, m_, l_,uv_k, uv_m, uv_l],
						[m_, k_, h_,uv_m, uv_k, uv_h],
						[k_, i_, h_,uv_k, uv_i, uv_h],
						[l_, i_, k_,uv_l, uv_i, uv_k],
						[l_, j_, i_,uv_l, uv_j, uv_i],
						[g_, h_, i_,uv_g, uv_h, uv_i],
						[f_, g_, i_,uv_f, uv_g, uv_i],
						[i_, j_, f_,uv_i, uv_j, uv_f],
						[e_, f_, j_,uv_e, uv_f, uv_j]
					]
			}},
		"cube7":{
			"BOTTOM":{
				"triangles":[
						[a_, b_, f_,uv_a, uv_b, uv_f],
						[d_, c_, a_,uv_d, uv_c, uv_a],
						[e_, d_, a_,uv_e, uv_d, uv_a],
						[f_, e_, a_,uv_f, uv_e, uv_a]
					]
			},
			"FRONT":{
				"triangles":[
						[a_, b_ ,c_,uv_a, uv_b, uv_c],
						[a_, c_, d_,uv_a, uv_c, uv_d],
						[a_, d_, e_,uv_a, uv_d, uv_e],
						[a_, e_, f_,uv_a, uv_e, uv_f]
					]
			},
			"BACK":{
				"triangles":[
						[h_, b_, a_,uv_h, uv_b, uv_a],
						[h_, g_, b_,uv_h, uv_g, uv_b],
						[g_, c_, b_,uv_g, uv_c, uv_b],
						[g_, f_, c_,uv_g, uv_f, uv_c],
						[f_, d_, c_,uv_f, uv_d, uv_c],
						[f_, e_, d_,uv_f, uv_e, uv_d]
					]
			},
			"LEFT":{
				"triangles":[
						[f_, b_, a_,uv_f, uv_b, uv_a],
						[a_, e_, f_,uv_a, uv_e, uv_f],
						[a_, d_, e_,uv_a, uv_d, uv_e],
						[a_, c_, d_,uv_a, uv_c, uv_d]
					]
			},
			"RIGHT":{
				"triangles":[
						[b_, c_, a_,uv_b, uv_c, uv_a],
						[d_, c_, b_,uv_d, uv_c, uv_b]
					]
			},
			"TOP":{
				"triangles":[
						[h_, b_, a_,uv_h, uv_b, uv_a],
						[a_, g_, h_,uv_a, uv_g, uv_h],
						[b_, h_, m_,uv_b, uv_h, uv_m],
						[m_, c_, b_,uv_m, uv_c, uv_b],
						[c_, m_, n_,uv_c, uv_m, uv_n],
						[n_, d_, c_,uv_n, uv_d, uv_c],
						[n_, m_, l_,uv_n, uv_m, uv_l],
						[l_, m_, k_,uv_l, uv_m, uv_k],
						[h_, k_, m_,uv_h, uv_k, uv_m],
						[h_, i_, k_,uv_h, uv_i, uv_k],
						[k_, i_, l_,uv_k, uv_i, uv_l],
						[i_, j_, l_,uv_i, uv_j, uv_l],
						[i_, h_, g_,uv_i, uv_h, uv_g],
						[i_, g_, f_,uv_i, uv_g, uv_f],
						[f_, j_, i_,uv_f, uv_j, uv_i],
						[j_, f_, e_,uv_j, uv_f, uv_e]
					]
			}},
		"cube8":{
			"BOTTOM":{
				"triangles":[
						[f_, b_, a_,uv_f, uv_b, uv_a],
						[a_, c_, d_,uv_a, uv_c, uv_d],
						[a_, d_, e_,uv_a, uv_d, uv_e],
						[a_, e_, f_,uv_a, uv_e, uv_f]
					]
			},
			"FRONT":{
				"triangles":[
						[c_, b_ ,a_,uv_c, uv_b, uv_a],
						[d_, c_, a_,uv_d, uv_c, uv_a],
						[e_, d_, a_,uv_e, uv_d, uv_a],
						[f_, e_, a_,uv_f, uv_e, uv_a]
					]
			},
			"BACK":{
				"triangles":[
						[a_, b_, h_,uv_a, uv_b, uv_h],
						[b_, g_, h_,uv_b, uv_g, uv_h],
						[b_, c_, g_,uv_b, uv_c, uv_g],
						[c_, f_, g_,uv_c, uv_f, uv_g],
						[c_, d_, f_,uv_c, uv_d, uv_f],
						[d_, e_, f_,uv_d, uv_e, uv_f]
					]
			},
			"LEFT":{
				"triangles":[
						[a_, c_, b_,uv_a, uv_c, uv_b],
						[b_, c_, d_,uv_b, uv_c, uv_d]
					]
			},
			"RIGHT":{
				"triangles":[
						[a_, b_, f_,uv_a, uv_b, uv_f],
						[f_, e_, a_,uv_f, uv_e, uv_a],
						[e_, d_, a_,uv_e, uv_d, uv_a],
						[d_, c_, a_,uv_d, uv_c, uv_a]
					]
			},
			"TOP":{
				"triangles":[
						[a_, b_, h_,uv_a, uv_b, uv_h],
						[h_, g_, a_,uv_h, uv_g, uv_a],
						[m_, h_, b_,uv_m, uv_h, uv_b],
						[b_, c_, m_,uv_b, uv_c, uv_m],
						[n_, m_, c_,uv_n, uv_m, uv_c],
						[c_, d_, n_,uv_c, uv_d, uv_n],
						[l_, m_, n_,uv_l, uv_m, uv_n],
						[k_, m_, l_,uv_k, uv_m, uv_l],
						[m_, k_, h_,uv_m, uv_k, uv_h],
						[k_, i_, h_,uv_k, uv_i, uv_h],
						[l_, i_, k_,uv_l, uv_i, uv_l],
						[l_, j_, i_,uv_l, uv_j, uv_i],
						[g_, h_, i_,uv_g, uv_h, uv_i],
						[f_, g_, i_,uv_f, uv_g, uv_i],
						[i_, j_, f_,uv_i, uv_j, uv_f],
						[e_, f_, j_,uv_e, uv_f, uv_j],
					]
			}},
		"cube13":{
			"BOTTOM":{
				"triangles":[
						[e_, b_, a_,uv_e, uv_b, uv_a],
						[b_, e_, f_,uv_b, uv_e, uv_f],
						[f_, c_, b_,uv_f, uv_c, uv_b],
						[f_, d_, c_,uv_f, uv_d, uv_c],
						[d_, f_, g_,uv_d, uv_f, uv_g],
						[d_, g_, h_,uv_d, uv_g, uv_h]
					]
			},
			"FRONT":{
				"triangles":[
						[g_, b_ ,a_,uv_g, uv_b, uv_a],
						[h_, g_, a_,uv_h, uv_g, uv_a],
						[g_, c_, b_,uv_g, uv_c, uv_b],
						[g_, f_, c_,uv_g, uv_f, uv_c],
						[f_, d_, c_,uv_f, uv_d, uv_c],
						[f_, e_, d_,uv_f, uv_e, uv_d]
					]
			},
			"BACK":{
				"triangles":[
						[a_, b_ ,g_,uv_a, uv_b, uv_g],
						[a_, g_, h_,uv_a, uv_g, uv_h],
						[b_, c_, g_,uv_b, uv_c, uv_g],
						[c_, f_, g_,uv_c, uv_f, uv_g],
						[c_, d_, f_,uv_c, uv_d, uv_f],
						[d_, e_, f_,uv_d, uv_e, uv_f]
					]
			},
			"LEFT":{
				"triangles":[
						[a_, b_, e_,uv_a, uv_b, uv_e],
						[b_, c_, e_,uv_b, uv_c, uv_e],
						[c_, d_, e_,uv_c, uv_d, uv_e],
						[f_, e_, d_,uv_f, uv_e, uv_d],
						[g_, f_, d_,uv_g, uv_f, uv_d],
						[h_, g_, d_,uv_h, uv_g, uv_d]
					]
			},
			"RIGHT":{
				"triangles":[
						[a_, c_, d_,uv_a, uv_c, uv_d],
						[d_, b_, a_,uv_d, uv_b, uv_a]
					]
			},
			"TOP":{
				"triangles":[
						[m_, n_, o_,uv_m, uv_n, uv_o],
						[m_, o_, p_,uv_m, uv_o, uv_p],
						[m_, p_ ,q_,uv_m, uv_p, uv_q],
						[l_, m_ ,q_,uv_l, uv_m, uv_q],
						[q_, k_ , l_,uv_q, uv_k, uv_l],
						[q_, r_, k_,uv_q, uv_r, uv_k],
						[q_, s_, r_,uv_q, uv_s, uv_r],
						[s_, q_, p_,uv_s, uv_q, uv_p],
						[s_, p_ , o_,uv_s, uv_p, uv_o],
						[o_, t_, s_,uv_o, uv_t, uv_s],
						[s_, t_, i_,uv_s, uv_t, uv_i],
						[i_, t_, j_,uv_i, uv_t, uv_j],
						[r_, s_, h_,uv_r, uv_s, uv_h],
						[s_, i_, h_,uv_s, uv_i, uv_h],
						[k_, r_, a_,uv_k, uv_r, uv_a],
						[r_, h_, a_,uv_r, uv_h, uv_a],
						[h_, b_, a_,uv_h, uv_b, uv_a],
						[g_, h_, i_,uv_g, uv_h, uv_i],
						[h_, g_, b_,uv_h, uv_g, uv_b],
						[f_, g_, i_,uv_f, uv_g, uv_i],
						[f_, i_, j_,uv_f, uv_i, uv_j],
						[e_, f_, j_,uv_e, uv_f, uv_j],
						[g_, c_, b_,uv_g, uv_c, uv_b],
						[g_, f_, c_,uv_g, uv_f, uv_c],
						[c_, f_, e_,uv_c, uv_f, uv_e],
						[e_, d_, c_,uv_e, uv_d, uv_c]
					]
			}},
		"cube14":{
			"BOTTOM":{
				"triangles":[
						[a_, b_, e_,uv_a, uv_b, uv_e],
						[f_, e_, b_,uv_f, uv_e, uv_b],
						[b_, c_, f_,uv_b, uv_c, uv_f],
						[c_, d_, f_,uv_c, uv_d, uv_f],
						[g_, f_, d_,uv_g, uv_f, uv_d],
						[h_, g_, d_,uv_h, uv_g, uv_d]
					]
			},
			"FRONT":{
				"triangles":[
						[a_, b_ ,g_,uv_a, uv_b, uv_g],
						[a_, g_, h_,uv_a, uv_g, uv_h],
						[b_, c_, g_,uv_b, uv_c, uv_g],
						[c_, f_, g_,uv_c, uv_f, uv_g],
						[c_, d_, f_,uv_c, uv_d, uv_f],
						[d_, e_, f_,uv_d, uv_e, uv_f]
					]
			},
			"BACK":{
				"triangles":[
						[g_, b_ ,a_,uv_g, uv_b, uv_a],
						[h_, g_, a_,uv_h, uv_g, uv_a],
						[g_, c_, b_,uv_g, uv_c, uv_b],
						[g_, f_, c_,uv_g, uv_f, uv_c],
						[f_, d_, c_,uv_f, uv_d, uv_c],
						[f_, e_, d_,uv_f, uv_e, uv_d]
					]
			},
			"LEFT":{
				"triangles":[
						[d_, c_, a_,uv_d, uv_c, uv_a],
						[a_, b_, d_,uv_a, uv_b, uv_d]
					]
			},
			"RIGHT":{
				"triangles":[
						[e_, b_, a_,uv_e, uv_b, uv_a],
						[e_, c_, b_,uv_e, uv_c, uv_b],
						[e_, d_, c_,uv_e, uv_d, uv_c],
						[d_, e_, f_,uv_d, uv_e, uv_f],
						[d_, f_, g_,uv_d, uv_f, uv_g],
						[d_, g_, h_,uv_d, uv_g, uv_h]
					]
			},
			"TOP":{
				"triangles":[
						[o_, n_, m_,uv_o, uv_n, uv_m],
						[p_, o_, m_,uv_p, uv_o, uv_m],
						[q_, p_ ,m_,uv_q, uv_p, uv_m],
						[q_, m_ ,l_,uv_q, uv_m, uv_l],
						[l_, k_ , q_,uv_l, uv_k, uv_q],
						[k_, r_, q_,uv_k, uv_r, uv_q],
						[r_, s_, q_,uv_r, uv_s, uv_q],
						[p_, q_, s_,uv_p, uv_q, uv_s],
						[o_, p_ , s_,uv_o, uv_p, uv_s],
						[s_, t_, o_,uv_s, uv_t, uv_o],
						[i_, t_, s_,uv_i, uv_t, uv_s],
						[j_, t_, i_,uv_j, uv_t, uv_i],
						[h_, s_, r_,uv_h, uv_s, uv_r],
						[h_, i_, s_,uv_h, uv_i, uv_s],
						[a_, r_, k_,uv_a, uv_r, uv_k],
						[a_, h_, r_,uv_a, uv_h, uv_r],
						[a_, b_, h_,uv_a, uv_b, uv_h],
						[i_, h_, g_,uv_i, uv_h, uv_g],
						[b_, g_, h_,uv_b, uv_g, uv_h],
						[i_, g_, f_,uv_i, uv_g, uv_f],
						[j_, i_, f_,uv_j, uv_i, uv_f],
						[j_, f_, e_,uv_j, uv_f, uv_e],
						[b_, c_, g_,uv_b, uv_c, uv_g],
						[c_, f_, g_,uv_c, uv_f, uv_g],
						[e_, f_, c_,uv_e, uv_f, uv_c],
						[c_, d_, e_,uv_c, uv_d, uv_e]
					]
			}},
		"cube15":{
			"BOTTOM":{
				"triangles":[
						[e_, b_, a_,uv_e, uv_b, uv_a],
						[b_, e_, f_,uv_b, uv_e, uv_f],
						[f_, c_, b_,uv_f, uv_c, uv_b],
						[f_, d_, c_,uv_f, uv_d, uv_c],
						[d_, f_, g_,uv_d, uv_f, uv_g],
						[d_, g_, h_,uv_d, uv_g, uv_h]
					]
			},
			"FRONT":{
				"triangles":[
						[a_, b_, e_,uv_a, uv_b, uv_e],
						[b_, c_, e_,uv_b, uv_c, uv_e],
						[c_, d_, e_,uv_c, uv_d, uv_e],
						[f_, e_, d_,uv_f, uv_e, uv_d],
						[g_, f_, d_,uv_g, uv_f, uv_d],
						[h_, g_, d_,uv_h, uv_g, uv_d]
					]
			},
			"BACK":{
				"triangles":[
						[a_, c_, d_,uv_a, uv_c, uv_d],
						[d_, b_, a_,uv_d, uv_b, uv_a]
					]
			},
			"LEFT":{
				"triangles":[
						[a_, b_ ,g_,uv_a, uv_b, uv_g],
						[a_, g_, h_,uv_a, uv_g, uv_h],
						[b_, c_, g_,uv_b, uv_c, uv_g],
						[c_, f_, g_,uv_c, uv_f, uv_g],
						[c_, d_, f_,uv_c, uv_d, uv_f],
						[d_, e_, f_,uv_d, uv_e, uv_f]
					]
			},
			"RIGHT":{
				"triangles":[
						[g_, b_ ,a_,uv_g, uv_b, uv_a],
						[h_, g_, a_,uv_h, uv_g, uv_a],
						[g_, c_, b_,uv_g, uv_c, uv_b],
						[g_, f_, c_,uv_g, uv_f, uv_c],
						[f_, d_, c_,uv_f, uv_d, uv_c],
						[f_, e_, d_,uv_f, uv_e, uv_d]
					]
			},
			"TOP":{
				"triangles":[
						[m_, n_, o_,uv_m, uv_n, uv_o],
						[m_, o_, p_,uv_m, uv_o, uv_p],
						[m_, p_ ,q_,uv_m, uv_p, uv_q],
						[l_, m_ ,q_,uv_l, uv_m, uv_q],
						[q_, k_ , l_,uv_q, uv_k, uv_l],
						[q_, r_, k_,uv_q, uv_r, uv_k],
						[q_, s_, r_,uv_q, uv_s, uv_r],
						[s_, q_, p_,uv_s, uv_q, uv_p],
						[s_, p_ , o_,uv_s, uv_p, uv_o],
						[o_, t_, s_,uv_o, uv_t, uv_s],
						[s_, t_, i_,uv_s, uv_t, uv_i],
						[i_, t_, j_,uv_i, uv_t, uv_j],
						[r_, s_, h_,uv_r, uv_s, uv_h],
						[s_, i_, h_,uv_s, uv_i, uv_h],
						[k_, r_, a_,uv_k, uv_r, uv_a],
						[r_, h_, a_,uv_r, uv_h, uv_a],
						[h_, b_, a_,uv_h, uv_b, uv_a],
						[g_, h_, i_,uv_g, uv_h, uv_i],
						[h_, g_, b_,uv_h, uv_g, uv_b],
						[f_, g_, i_,uv_f, uv_g, uv_i],
						[f_, i_, j_,uv_f, uv_i, uv_j],
						[e_, f_, j_,uv_e, uv_f, uv_j],
						[g_, c_, b_,uv_g, uv_c, uv_b],
						[g_, f_, c_,uv_g, uv_f, uv_c],
						[c_, f_, e_,uv_c, uv_f, uv_e],
						[e_, d_, c_,uv_e, uv_d, uv_c]
					]
			}},
		"cube16":{
			"BOTTOM":{
				"triangles":[
						[e_, b_, a_,uv_e, uv_b, uv_a],
						[b_, e_, f_,uv_b, uv_e, uv_f],
						[f_, c_, b_,uv_f, uv_c, uv_b],
						[f_, d_, c_,uv_f, uv_d, uv_c],
						[d_, f_, g_,uv_d, uv_f, uv_g],
						[d_, g_, h_,uv_d, uv_g, uv_h]
					]
			},
			"FRONT":{
				"triangles":[
						[a_, c_, d_,uv_a, uv_c, uv_d],
						[d_, b_, a_,uv_d, uv_b, uv_a]
					]
			},
			"BACK":{
				"triangles":[
						[a_, b_, e_,uv_a, uv_b, uv_e],
						[b_, c_, e_,uv_b, uv_c, uv_e],
						[c_, d_, e_,uv_c, uv_d, uv_e],
						[f_, e_, d_,uv_f, uv_e, uv_d],
						[g_, f_, d_,uv_g, uv_f, uv_d],
						[h_, g_, d_,uv_h, uv_g, uv_d]
					]
			},
			"LEFT":{
				"triangles":[
						[g_, b_ ,a_,uv_g, uv_b, uv_a],
						[h_, g_, a_,uv_h, uv_g, uv_a],
						[g_, c_, b_,uv_g, uv_c, uv_b],
						[g_, f_, c_,uv_g, uv_f, uv_c],
						[f_, d_, c_,uv_f, uv_d, uv_c],
						[f_, e_, d_,uv_f, uv_e, uv_d]
					]
			},
			"RIGHT":{
				"triangles":[
						[a_, b_ ,g_,uv_a, uv_b, uv_g],
						[a_, g_, h_,uv_a, uv_g, uv_h],
						[b_, c_, g_,uv_b, uv_c, uv_g],
						[c_, f_, g_,uv_c, uv_f, uv_g],
						[c_, d_, f_,uv_c, uv_d, uv_f],
						[d_, e_, f_,uv_d, uv_e, uv_f]
					]
			},
			"TOP":{
				"triangles":[
						[m_, n_, o_,uv_m, uv_n, uv_o],
						[m_, o_, p_,uv_m, uv_o, uv_p],
						[m_, p_ ,q_,uv_m, uv_p, uv_q],
						[l_, m_ ,q_,uv_l, uv_m, uv_q],
						[q_, k_ , l_,uv_q, uv_k, uv_l],
						[q_, r_, k_,uv_q, uv_r, uv_k],
						[q_, s_, r_,uv_q, uv_s, uv_r],
						[s_, q_, p_,uv_s, uv_q, uv_p],
						[s_, p_ , o_,uv_s, uv_p, uv_o],
						[o_, t_, s_,uv_o, uv_t, uv_s],
						[s_, t_, i_,uv_s, uv_t, uv_i],
						[i_, t_, j_,uv_i, uv_t, uv_j],
						[r_, s_, h_,uv_r, uv_s, uv_h],
						[s_, i_, h_,uv_s, uv_i, uv_h],
						[k_, r_, a_,uv_k, uv_r, uv_a],
						[r_, h_, a_,uv_r, uv_h, uv_a],
						[h_, b_, a_,uv_h, uv_b, uv_a],
						[g_, h_, i_,uv_g, uv_h, uv_i],
						[h_, g_, b_,uv_h, uv_g, uv_b],
						[f_, g_, i_,uv_f, uv_g, uv_i],
						[f_, i_, j_,uv_f, uv_i, uv_j],
						[e_, f_, j_,uv_e, uv_f, uv_j],
						[g_, c_, b_,uv_g, uv_c, uv_b],
						[g_, f_, c_,uv_g, uv_f, uv_c],
						[c_, f_, e_,uv_c, uv_f, uv_e],
						[e_, d_, c_,uv_e, uv_d, uv_c]
					]
			}},
		"cube17":{
			"BOTTOM":{
				"triangles":[
						[g_, b_, a_,uv_g, uv_b, uv_a],
						[b_, g_, h_,uv_b, uv_g, uv_h],
						[h_, c_, b_,uv_h,uv_c, uv_b],
						[c_, h_, i_,uv_c, uv_h, uv_i],
						[i_, d_, c_,uv_i, uv_d, uv_c],
						[d_, i_, j_,uv_d, uv_i, uv_j],
						[j_, k_, d_,uv_j, uv_k, uv_d],
						[k_, e_, d_,uv_k, uv_e, uv_d],
						[k_, f_, e_,uv_k, uv_f, uv_e],
						[f_, k_, l_,uv_f, uv_k, uv_l]
					]
			},
			"FRONT":{
				"triangles":[
						[a_, l_, k_,uv_a, uv_l, uv_k],
						[k_, b_, a_,uv_k, uv_b, uv_a],
						[k_, c_, b_,uv_k, uv_c, uv_b],
						[c_, k_, j_,uv_c, uv_k, uv_j],
						[j_, i_, c_,uv_j, uv_i, uv_c],
						[i_, d_, c_,uv_i, uv_d, uv_c],
						[i_, e_, d_,uv_i, uv_e, uv_d],
						[i_, h_, e_,uv_i, uv_h, uv_e],
						[h_, g_,e_,uv_h, uv_g, uv_e],
						[g_, f_, e_,uv_g, uv_f, uv_e]
					]
			},
			"BACK":{
				"triangles":[
						[a_, b_, l_,uv_a, uv_b, uv_l],
						[b_, k_, l_,uv_b, uv_k, uv_l],
						[j_, k_, b_,uv_j, uv_k, uv_b],
						[b_, c_, j_,uv_b, uv_c, uv_j],
						[c_, d_, j_,uv_c, uv_d, uv_j],
						[d_, i_, j_,uv_d, uv_i, uv_j],
						[d_, e_, i_,uv_d, uv_e, uv_i],
						[h_, i_, e_,uv_h, uv_i, uv_e],
						[g_, h_, e_,uv_g, uv_h, uv_e],
						[e_, f_, g_,uv_e, uv_f, uv_g]
					]
			},
			"LEFT":{
				"triangles":[
						[a_, b_ ,c_,uv_a, uv_b, uv_c],
						[d_, c_, b_,uv_d, uv_c, uv_b]
					]
			},
			"RIGHT":{
				"triangles":[
						[c_, b_ ,a_,uv_c, uv_b, uv_a],
						[b_, c_, d_,uv_b, uv_c, uv_d]
					]
			},
			"TOP":{
				"triangles":[
						[n_, m_, aa_,uv_n, uv_m, uv_aa],
						[m_, ab_, aa_, uv_m, uv_ab, uv_aa],
						[aa_, z_, n_,uv_aa, uv_z, uv_n],
						[g_, n_, z_,uv_g, uv_n, uv_z],
						[f_, g_, z_,uv_f, uv_g, uv_z],
						[z_, t_, f_,uv_z, uv_t, uv_f],
						[t_, z_, y_,uv_t, uv_z, uv_y],
						[aa_, y_, z_,uv_aa, uv_y, uv_z],
						[t_, y_, s_,uv_t, uv_y, uv_s],
						[x_, r_, s_,uv_x, uv_r, uv_s],
						[y_, x_, s_,uv_y, uv_x, uv_s],
						[aa_, x_, y_,uv_aa, uv_x, uv_y],
						[w_, x_, aa_,uv_w, uv_x, uv_aa],
						[ab_, w_, aa_,uv_ab, uv_w, uv_aa],
						[r_, x_, w_,uv_r, uv_x, uv_w],
						[r_, w_, q_,uv_r, uv_w, uv_q],
						[w_, v_, q_,uv_w, uv_v, uv_q],
						[v_, p_, q_,uv_v, uv_p, uv_q],
						[ab_, v_, w_,uv_ab, uv_v, uv_w],
						[u_, v_, ab_,uv_u, uv_v, uv_ab],
						[v_,u_,p_,uv_v, uv_u, uv_p],
						[u_,o_,p_,uv_u, uv_o, uv_p],
						[m_, u_, ab_,uv_m, uv_u, uv_ab],
						[l_,u_,m_,uv_l, uv_u, uv_m],
						[l_,o_,u_,uv_l, uv_o, uv_u],
						[a_, o_, l_,uv_a, uv_o, uv_l],
						[l_, b_, a_,uv_l, uv_b, uv_a],
						[b_, l_ , k_,uv_b, uv_l, uv_k],
						[l_,m_ ,k_ ,uv_l, uv_m, uv_k],
						[j_, k_ , m_,uv_j, uv_k, uv_m],
						[c_, k_, j_,uv_c, uv_k, uv_j],
						[k_, c_, b_,uv_k, uv_c, uv_b],
						[j_, m_ , n_,uv_j, uv_m, uv_n],
						[i_, j_, n_,uv_i, uv_j, uv_n],
						[j_, d_, c_,uv_j, uv_d, uv_c],
						[j_, i_, d_,uv_j, uv_i, uv_d],
						[h_, i_, n_,uv_h, uv_i, uv_n],
						[g_, h_, n_,uv_g, uv_h, uv_n],
						[i_, h_, e_,uv_i, uv_h, uv_e],
						[i_, e_, d_,uv_i, uv_e, uv_d],
						[h_, g_, e_,uv_h, uv_g, uv_e],
						[g_, f_, e_,uv_g, uv_f, uv_e]
				]
		}},
		"cube18":{
			"BOTTOM":{
				"triangles":[
						[f_, b_, a_,uv_f, uv_b, uv_a],
						[e_,f_,a_,uv_e, uv_f, uv_a],
						[d_, e_, a_,uv_d, uv_e, uv_a],
						[c_,d_,a_,uv_c, uv_d, uv_a]
					]
			},
			"FRONT":{
				"triangles":[
						[h_, g_, a_,uv_h, uv_g, uv_a],
						[g_, b_, a_,uv_g, uv_b, uv_a],
						[g_, f_, b_,uv_g, uv_f, uv_b],
						[f_, c_, b_,uv_f, uv_c, uv_b],
						[f_, e_, c_,uv_f, uv_e, uv_c],
						[e_, d_, c_,uv_e, uv_d, uv_c]
					]
			},
			"BACK":{
				"triangles":[
						[a_, b_, c_,uv_a, uv_b, uv_c],
						[a_, c_, d_,uv_a, uv_c, uv_d]
					]
			},
			"LEFT":{
				"triangles":[
						[b_, c_, a_,uv_b, uv_c, uv_a],
						[d_, c_, b_,uv_d, uv_c, uv_b]
					]
			},
			"RIGHT":{
				"triangles":[
						[c_,b_,a_,uv_c, uv_b, uv_a],
						[b_, c_, d_,uv_b, uv_c, uv_d]
					]
			}},
		"cube19":{
			"BOTTOM":{
				"triangles":[
						[a_, b_, f_,uv_a, uv_b, uv_f],
						[a_,f_,e_,uv_a, uv_f, uv_e],
						[a_, e_, d_,uv_a, uv_e, uv_d],
						[a_,d_,c_,uv_a, uv_d, uv_c]
					]
			},
			"FRONT":{
				"triangles":[
						[a_, g_, h_,uv_a, uv_g, uv_h],
						[a_, b_, g_,uv_a, uv_b, uv_g],
						[b_, f_, g_,uv_b, uv_f, uv_g],
						[b_, c_, f_,uv_b, uv_c, uv_f],
						[c_, e_, f_,uv_c, uv_e, uv_f],
						[c_, d_, e_,uv_c, uv_d, uv_e]
					]
			},
			"BACK":{
				"triangles":[
						[c_, b_, a_,uv_c, uv_b, uv_a],
						[d_, c_, a_,uv_d, uv_c, uv_a]
					]
			},
			"LEFT":{
				"triangles":[
						[a_,b_,c_,uv_a, uv_b, uv_c],
						[d_,c_,b_,uv_d, uv_c, uv_b]
					]
			},
			"RIGHT":{
				"triangles":[
					[a_, c_, b_,uv_a, uv_c, uv_b],
					[b_, c_, d_,uv_b, uv_c, uv_d]
					]
			}},
	"cube20":{
			"BOTTOM":{
				"triangles":[
						[a_, b_, f_,uv_a, uv_b, uv_f],
						[a_,f_,e_,uv_a, uv_f, uv_e],
						[a_, e_, d_,uv_a, uv_e, uv_d],
						[a_,d_,c_,uv_a, uv_d, uv_c]
					]
			},
			"FRONT":{
				"triangles":[
						[b_, c_, a_,uv_b, uv_c, uv_a],
						[d_, c_, b_,uv_d, uv_c, uv_b]
					]
			},
			"BACK":{
				"triangles":[
						[c_,b_,a_,uv_c, uv_b, uv_a],
						[b_,c_,d_,uv_b, uv_c, uv_d]
					]
			},
			"LEFT":{
				"triangles":[
						[c_, b_, a_,uv_c, uv_b, uv_a],
						[d_, c_, a_,uv_d, uv_c, uv_a]
					]
			},
			"RIGHT":{
				"triangles":[
						[a_, g_, h_,uv_a, uv_g, uv_h],
						[a_, b_, g_,uv_a, uv_b, uv_g],
						[b_, f_, g_,uv_b, uv_f, uv_g],
						[b_, c_, f_,uv_b, uv_c, uv_f],
						[c_, e_, f_,uv_c, uv_e, uv_f],
						[c_, d_, e_,uv_c, uv_d, uv_e]
					]
			}},
	"cube21":{
			"BOTTOM":{
				"triangles":[
						[f_, b_, a_,uv_f, uv_b, uv_a],
						[e_,f_,a_,uv_e, uv_f, uv_a],
						[d_, e_, a_,uv_d, uv_e, uv_a],
						[c_,d_,a_,uv_c, uv_d, uv_a]
					]
			},
			"FRONT":{
				"triangles":[
						[a_, c_, b_,uv_a, uv_c, uv_b],
						[b_, c_, d_,uv_b, uv_c, uv_d]
					]
			},
			"BACK":{
				"triangles":[
						[a_,b_,c_,uv_a, uv_b, uv_c],
						[d_,c_,b_,uv_d, uv_c, uv_b]
					]
			},
			"LEFT":{
				"triangles":[
						[h_, g_, a_,uv_h, uv_g, uv_a],
						[g_, b_, a_,uv_g, uv_b, uv_a],
						[g_, f_, b_,uv_g, uv_f, uv_b],
						[f_, c_, b_,uv_f, uv_c, uv_b],
						[f_, e_, c_,uv_f, uv_e, uv_c],
						[e_, d_, c_,uv_e, uv_d, uv_c]
					]
			},
			"RIGHT":{
				"triangles":[
						[a_, b_, c_,uv_a, uv_b, uv_c],
						[a_, c_, d_,uv_a, uv_c, uv_d]
					]
			}},
	"cube22":{
			"BOTTOM":{
				"triangles":[
						[a_, c_, b_,uv_a, uv_c, uv_b],
						[b_, c_, d_,uv_b, uv_c, uv_d]
					]
			},
			"FRONT":{
				"triangles":[
						[h_,b_,a_,uv_h, uv_b, uv_a],
						[h_,g_,b_,uv_h, uv_g, uv_b],
						[b_,g_,f_,uv_b, uv_g, uv_f],
						[f_,e_,b_,uv_f, uv_e, uv_b],
						[e_,c_,b_,uv_e, uv_c, uv_b],
						[e_,d_,c_,uv_e, uv_d, uv_c]
					]
			},
			"BACK":{
				"triangles":[
						[a_,b_,h_,uv_a, uv_b, uv_h],
						[b_,g_,h_,uv_b, uv_g, uv_h],
						[f_,g_,b_,uv_f, uv_g, uv_b],
						[b_,e_,f_,uv_b, uv_e, uv_f],
						[b_,c_,e_,uv_b, uv_c, uv_e],
						[c_,d_,e_,uv_c, uv_d, uv_e]
					]
			},
			"LEFT":{
				"triangles":[
					[b_, c_, a_,uv_b, uv_c, uv_a],
					[d_, c_, b_,uv_d, uv_c, uv_b]
					]
			},
			"RIGHT":{
				"triangles":[
						[a_, c_, b_,uv_a, uv_c, uv_b],
						[b_, c_, d_,uv_b, uv_c, uv_d]
					]
			},
			"TOP":{
				"triangles":[
						[g_,b_,a_,uv_g, uv_b, uv_a],
						[b_,g_,h_,uv_b, uv_g, uv_h],
						[h_,c_,b_,uv_h, uv_c, uv_b],
						[c_,h_,i_,uv_c, uv_h, uv_i],
						[i_,d_,c_,uv_i, uv_d, uv_c],
						[d_,i_,j_,uv_d, uv_i, uv_j],
						[e_,d_,j_,uv_e, uv_d, uv_j],
						[j_,k_,e_,uv_j, uv_k, uv_e],
						[k_,f_,e_,uv_k, uv_f, uv_e],
						[f_,k_,l_,uv_f, uv_k, uv_l]
					]
			}},
		"cube23":{
			"BOTTOM":{
				"triangles":[
						[b_, c_, a_,uv_b, uv_c, uv_a],
						[d_, c_, b_,uv_d, uv_c, uv_b]
					]
			},
			"FRONT":{
				"triangles":[
						[b_, c_, a_,uv_b, uv_c, uv_a],
						[d_, c_, b_,uv_d, uv_c, uv_b]
					]
			},
			"BACK":{
				"triangles":[
						[a_, c_, b_,uv_a, uv_c, uv_b],
						[b_, c_, d_,uv_b, uv_c, uv_d]
					]
			},
			"LEFT":{
				"triangles":[
						[h_,b_,a_,uv_h, uv_b, uv_a],
						[h_,g_,b_,uv_h, uv_g, uv_b],
						[b_,g_,f_,uv_b, uv_g, uv_f],
						[f_,e_,b_,uv_f, uv_e, uv_b],
						[e_,c_,b_,uv_e, uv_c, uv_b],
						[e_,d_,c_,uv_e, uv_d, uv_c]
					]
			},
			"RIGHT":{
				"triangles":[
					[a_,b_,h_,uv_a, uv_b, uv_h],
					[b_,g_,h_,uv_b, uv_g, uv_h],
					[f_,g_,b_,uv_f, uv_g, uv_b],
					[b_,e_,f_,uv_b, uv_e, uv_f],
					[b_,c_,e_,uv_b, uv_c, uv_e],
					[c_,d_,e_,uv_c, uv_d, uv_e]
					]
			},
			"TOP":{
				"triangles":[
						[a_,b_,g_,uv_a, uv_b, uv_g],
						[h_,g_,b_,uv_h, uv_g, uv_b],
						[b_,c_,h_,uv_b, uv_c, uv_h],
						[i_,h_,c_,uv_i, uv_h, uv_c],
						[c_,d_,i_,uv_c, uv_d, uv_i],
						[j_,i_,d_,uv_j, uv_i, uv_d],
						[j_,d_,e_,uv_j, uv_d, uv_e],
						[e_,k_,j_,uv_e, uv_k, uv_j],
						[e_,f_,k_,uv_e, uv_f, uv_k],
						[l_,k_,f_,uv_l, uv_k, uv_f]
					]
			}},
		"cube28":{
			"BOTTOM":{
				"triangles":[
						[e_, b_, a_,uv_e, uv_b, uv_a],
						[c_,b_,e_,uv_c, uv_b, uv_e],
						[e_,d_,c_,uv_e, uv_d, uv_c],
						[e_,f_,d_,uv_e, uv_f, uv_d]
					]
			},
			"FRONT":{
				"triangles":[
						[g_,b_,a_,uv_g, uv_b, uv_a],
						[b_,g_,f_,uv_b, uv_g, uv_f],
						[f_,h_,b_,uv_f, uv_h, uv_b],
						[b_,h_,e_,uv_b, uv_h, uv_e],
						[b_,e_,c_,uv_b, uv_e, uv_c],
						[e_,d_,c_,uv_e, uv_d, uv_c]
					]
			},
			"BACK":{
				"triangles":[
						[a_,b_,h_,uv_a, uv_b, uv_h],
						[h_,b_,g_,uv_h, uv_b, uv_g],
						[b_,c_,g_,uv_b, uv_c, uv_g],
						[c_,f_,g_,uv_c, uv_f, uv_g],
						[c_,e_,f_,uv_c, uv_e, uv_f],
						[d_,e_,c_,uv_d, uv_e, uv_c]
					]
			},
			"LEFT":{
				"triangles":[
						[b_,e_,a_,uv_b, uv_e, uv_a],
						[b_,c_,e_,uv_b, uv_c, uv_e],
						[c_,d_,e_,uv_c, uv_d, uv_e],
						[e_,d_,h_,uv_e, uv_d, uv_h],
						[d_,f_,h_,uv_d, uv_f, uv_h],
						[f_,g_,h_,uv_f, uv_g, uv_h]
					]
			},
			"RIGHT":{
				"triangles":[
					[a_, c_, d_,uv_a, uv_c, uv_d],
					[d_, b_, a_,uv_d, uv_b, uv_a]
					]
			},
			"TOP":{
				"triangles":[
						[n_,m_,t_,uv_n, uv_m, uv_t],
						[m_,t_,o_,uv_m, uv_t, uv_o],
						[n_,o_,j_,uv_n, uv_o, uv_j],
						[j_,i_,n_,uv_j, uv_i, uv_n],
						[m_,i_,l_,uv_m, uv_i, uv_l],
						[l_,i_,h_,uv_l, uv_i, uv_h],
						[k_,l_,h_,uv_k, uv_l, uv_h],
						[h_,a_,k_,uv_h, uv_a, uv_k],
						[g_,h_,i_,uv_g, uv_h, uv_i],
						[f_,g_,i_,uv_f, uv_g, uv_i],
						[e_,i_,j_,uv_e, uv_i, uv_j],
						[e_,f_,i_,uv_e, uv_f, uv_i],
						[e_,d_,f_,uv_e, uv_d, uv_f],
						[c_,f_,d_,uv_c, uv_f, uv_d],
						[g_,f_,c_,uv_g, uv_f, uv_c],
						[c_,b_,g_,uv_c, uv_b, uv_g],
						[a_,h_,g_,uv_a, uv_h, uv_g],
						[g_,b_,a_,uv_g, uv_b, uv_a],
						[t_,p_,n_,uv_t, uv_p, uv_n],
						[n_,p_,q_,uv_n, uv_p, uv_q],
						[s_,q_,p_,uv_s, uv_q, uv_p],
						[s_,r_,q_,uv_s, uv_r, uv_q],
						[q_,o_,n_,uv_q, uv_o, uv_n],
						[q_,r_,o_,uv_q, uv_r, uv_o],
						[n_, i_, m_,uv_n, uv_i, uv_m]
					]
			}},
		"cube29":{
			"BOTTOM":{
				"triangles":[
						[a_, b_, e_,uv_a, uv_b, uv_e],
						[e_,b_,c_,uv_e, uv_b, uv_c],
						[c_,d_,e_,uv_c, uv_d, uv_e],
						[d_,f_,e_,uv_d, uv_f, uv_e]
					]
			},
			"FRONT":{
				"triangles":[
						[a_,b_,g_,uv_a, uv_b, uv_g],
						[f_,g_,b_,uv_f, uv_g, uv_b],
						[b_,h_,f_,uv_b, uv_h, uv_f],
						[e_,h_,b_,uv_e, uv_h, uv_b],
						[c_,e_,b_,uv_c, uv_e, uv_b],
						[c_,d_,e_,uv_c, uv_d, uv_e]
					]
			},
			"BACK":{
				"triangles":[
						[h_,b_,a_,uv_h, uv_b, uv_a],
						[g_,b_,h_,uv_g, uv_b, uv_h],
						[g_,c_,b_,uv_g, uv_c, uv_b],
						[g_,f_,c_,uv_g, uv_f, uv_c],
						[f_,e_,c_,uv_f, uv_e, uv_c],
						[c_,e_,d_,uv_c, uv_e, uv_d]
					]
			},
			"LEFT":{
				"triangles":[
						[d_, c_, a_,uv_d, uv_c, uv_a],
						[a_, b_, d_,uv_a, uv_b, uv_d]
					]
			},
			"RIGHT":{
				"triangles":[
						[a_,e_,b_,uv_a, uv_e, uv_b],
						[e_,c_,b_,uv_e, uv_c, uv_b],
						[e_,d_,c_,uv_e, uv_d, uv_c],
						[h_,d_,e_,uv_h, uv_d, uv_e],
						[h_,f_,d_,uv_h, uv_f, uv_d],
						[h_,g_,f_,uv_h, uv_g, uv_f]
					]
			},
			"TOP":{
				"triangles":[
						[t_,m_,n_,uv_t, uv_m, uv_n],
						[o_,t_,m_,uv_o, uv_t, uv_m],
						[j_,o_,n_,uv_j, uv_o, uv_n],
						[n_,i_,j_,uv_n, uv_i, uv_j],
						[l_,i_,m_,uv_l, uv_i, uv_m],
						[h_,i_,l_,uv_h, uv_i, uv_l],
						[h_,l_,k_,uv_h, uv_l, uv_k],
						[k_,a_,h_,uv_k, uv_a, uv_h],
						[i_,h_,g_,uv_i, uv_h, uv_g],
						[i_,g_,f_,uv_i, uv_g, uv_f],
						[j_,i_,e_,uv_j, uv_i, uv_e],
						[i_,f_,e_,uv_i, uv_f, uv_e],
						[f_,d_,e_,uv_f, uv_d, uv_e],
						[d_,f_,c_,uv_d, uv_f, uv_c],
						[c_,f_,g_,uv_c, uv_f, uv_g],
						[g_,b_,c_,uv_g, uv_b, uv_c],
						[g_,h_,a_,uv_g, uv_h, uv_a],
						[a_,b_,g_,uv_a, uv_b, uv_g],
						[n_,p_,t_,uv_n, uv_p, uv_t],
						[q_,p_,n_,uv_q, uv_p, uv_n],
						[p_,q_,s_,uv_p, uv_q, uv_s],
						[q_,r_,s_,uv_q, uv_r, uv_s],
						[n_,o_,q_,uv_n, uv_o, uv_q],
						[o_,r_,q_,uv_o, uv_r, uv_q],
						[m_, i_, n_,uv_m, uv_i, uv_n]
					]
			}},
		"cube30":{
			"BOTTOM":{
				"triangles":[
						[a_, b_, e_,uv_a, uv_b, uv_e],
						[e_,b_,c_,uv_e, uv_b, uv_c],
						[c_,d_,e_,uv_c, uv_d, uv_e],
						[d_,f_,e_,uv_d, uv_f, uv_e]
					]
			},
			"FRONT":{
				"triangles":[
						[h_,b_,a_,uv_h, uv_b, uv_a],
						[g_,b_,h_,uv_g, uv_b, uv_h],
						[g_,c_,b_,uv_g, uv_c, uv_b],
						[g_,f_,c_,uv_g, uv_f, uv_c],
						[f_,e_,c_,uv_f, uv_e, uv_c],
						[c_,e_,d_,uv_c, uv_e, uv_d]
					]
			},
			"BACK":{
				"triangles":[
						[a_,b_,g_,uv_a, uv_b, uv_g],
						[f_,g_,b_,uv_f, uv_g, uv_b],
						[b_,h_,f_,uv_b, uv_h, uv_f],
						[e_,h_,b_,uv_e, uv_h, uv_b],
						[c_,e_,b_,uv_c, uv_e, uv_b],
						[c_,d_,e_,uv_c, uv_d, uv_e]
					]
			},
			"LEFT":{
				"triangles":[
						[a_,e_,b_,uv_a, uv_e, uv_b],
						[e_,c_,b_,uv_e, uv_c, uv_b],
						[e_,d_,c_,uv_e, uv_d, uv_c],
						[h_,d_,e_,uv_h, uv_d, uv_e],
						[h_,f_,d_,uv_h, uv_f, uv_d],
						[h_,g_,f_,uv_h, uv_g, uv_f]
					]
			},
			"RIGHT":{
				"triangles":[
						[d_, c_, a_,uv_d, uv_c, uv_a],
						[a_, b_, d_,uv_a, uv_b, uv_d]
					]
			},
			"TOP":{
				"triangles":[
						[t_,m_,n_,uv_t, uv_m, uv_n],
						[o_,t_,m_,uv_o, uv_t, uv_m],
						[j_,o_,n_,uv_j, uv_o, uv_n],
						[n_,i_,j_,uv_n, uv_i, uv_j],
						[l_,i_,m_,uv_l, uv_i, uv_m],
						[h_,i_,l_,uv_h, uv_i, uv_l],
						[h_,l_,k_,uv_h, uv_l, uv_k],
						[k_,a_,h_,uv_k, uv_a, uv_h],
						[i_,h_,g_,uv_i, uv_h, uv_g],
						[i_,g_,f_,uv_i, uv_g, uv_f],
						[j_,i_,e_,uv_j, uv_i, uv_e],
						[i_,f_,e_,uv_i, uv_f, uv_e],
						[f_,d_,e_,uv_f, uv_d, uv_e],
						[d_,f_,c_,uv_d, uv_f, uv_c],
						[c_,f_,g_,uv_c, uv_f, uv_g],
						[g_,b_,c_,uv_g, uv_b, uv_c],
						[g_,h_,a_,uv_g, uv_h, uv_a],
						[a_,b_,g_,uv_a, uv_b, uv_g],
						[n_,p_,t_,uv_n, uv_p, uv_t],
						[q_,p_,n_,uv_q, uv_p, uv_n],
						[p_,q_,s_,uv_p, uv_q, uv_s],
						[q_,r_,s_,uv_q, uv_r, uv_s],
						[n_,o_,q_,uv_n, uv_o, uv_q],
						[o_,r_,q_,uv_o, uv_r, uv_q],
						[m_, i_, n_,uv_m, uv_i, uv_n]
					]
			}},
		"cube31":{
			"BOTTOM":{
				"triangles":[
						[e_, b_, a_,uv_e, uv_b, uv_a],
						[c_,b_,e_,uv_c, uv_b, uv_e],
						[e_,d_,c_,uv_e, uv_d, uv_c],
						[e_,f_,d_,uv_e, uv_f, uv_d]
					]
			},
			"FRONT":{
				"triangles":[
						[a_,b_,h_,uv_a, uv_b, uv_h],
						[h_,b_,g_,uv_h, uv_b, uv_g],
						[b_,c_,g_,uv_b, uv_c, uv_g],
						[c_,f_,g_,uv_c, uv_f, uv_g],
						[c_,e_,f_,uv_c, uv_e, uv_f],
						[d_,e_,c_,uv_d, uv_e, uv_c]
					]
			},
			"BACK":{
				"triangles":[
						[g_,b_,a_,uv_g, uv_b, uv_a],
						[b_,g_,f_,uv_b, uv_g, uv_f],
						[f_,h_,b_,uv_f, uv_h, uv_b],
						[b_,h_,e_,uv_b, uv_h, uv_e],
						[b_,e_,c_,uv_b, uv_e, uv_c],
						[e_,d_,c_,uv_e, uv_d, uv_c]
					]
			},
			"LEFT":{
				"triangles":[
						[a_, c_, d_,uv_a, uv_c, uv_d],
						[d_, b_, a_,uv_d, uv_b, uv_a]
					]
			},
			"RIGHT":{
				"triangles":[
						[b_,e_,a_,uv_b, uv_e, uv_a],
						[b_,c_,e_,uv_b, uv_c, uv_e],
						[c_,d_,e_,uv_c, uv_d, uv_e],
						[e_,d_,h_,uv_e, uv_d, uv_h],
						[d_,f_,h_,uv_d, uv_f, uv_h],
						[f_,g_,h_,uv_f, uv_g, uv_h]
						]
			},
			"TOP":{
				"triangles":[
						[n_,m_,t_,uv_n, uv_m, uv_t],
						[m_,t_,o_,uv_m, uv_t, uv_o],
						[n_,o_,j_,uv_n, uv_o, uv_j],
						[j_,i_,n_,uv_j, uv_i, uv_n],
						[m_,i_,l_,uv_m, uv_i, uv_l],
						[l_,i_,h_,uv_l, uv_i, uv_h],
						[k_,l_,h_,uv_k, uv_l, uv_h],
						[h_,a_,k_,uv_h, uv_a, uv_k],
						[g_,h_,i_,uv_g, uv_h, uv_i],
						[f_,g_,i_,uv_f, uv_g, uv_i],
						[e_,i_,j_,uv_e, uv_i, uv_j],
						[e_,f_,i_,uv_e, uv_f, uv_i],
						[e_,d_,f_,uv_e, uv_d, uv_f],
						[c_,f_,d_,uv_c, uv_f, uv_d],
						[g_,f_,c_,uv_g, uv_f, uv_c],
						[c_,b_,g_,uv_c, uv_b, uv_g],
						[a_,h_,g_,uv_a, uv_h, uv_g],
						[g_,b_,a_,uv_g, uv_b, uv_a],
						[t_,p_,n_,uv_t, uv_p, uv_n],
						[n_,p_,q_,uv_n, uv_p, uv_q],
						[s_,q_,p_,uv_s, uv_q, uv_p],
						[s_,r_,q_,uv_s, uv_r, uv_q],
						[q_,o_,n_,uv_q, uv_o, uv_n],
						[q_,r_,o_,uv_q, uv_r, uv_o],
						[n_, i_, m_,uv_n, uv_i, uv_m]
					]
			}},
		"cube32":{
			"BOTTOM":{
				"triangles":[
						[a_, c_, b_,uv_a, uv_b, uv_c],
						[b_, c_, d_,uv_a, uv_c, uv_d]
					]
			},
			"FRONT":{
				"triangles":[
						[h_,b_,a_,uv_h, uv_b, uv_a],
						[h_,g_,b_,uv_h, uv_g, uv_b],
						[b_,g_,f_,uv_b, uv_g, uv_f],
						[b_,f_,e_,uv_b, uv_f, uv_e],
						[b_,e_,c_,uv_b, uv_e, uv_c],
						[c_,e_,d_,uv_c, uv_e, uv_d]
					]
			},
			"BACK":{
				"triangles":[
						[a_, b_ ,c_,uv_a, uv_b, uv_c],
						[a_, c_, d_,uv_a, uv_c, uv_d]
					]
			},
			"LEFT":{
				"triangles":[
						[a_, b_, f_,uv_a, uv_b, uv_f],
						[a_, f_, e_,uv_a, uv_f, uv_e],
						[a_, e_, d_,uv_a, uv_e, uv_d],
						[a_, d_, c_,uv_a, uv_d, uv_c]
					]
			},
			"RIGHT":{
				"triangles":[
						[a_,c_,d_,uv_a, uv_c, uv_d],
						[a_,d_,f_,uv_a, uv_d, uv_f],
						[a_,f_,e_,uv_a, uv_f, uv_e],
						[a_,e_,b_,uv_a, uv_e, uv_b]
						]
			},
			"TOP":{
				"triangles":[
						[i_,g_,h_,uv_i, uv_g, uv_h],
						[g_,i_,j_,uv_g, uv_i, uv_j],
						[f_,g_,j_,uv_f, uv_g, uv_j],
						[j_,b_,f_,uv_j, uv_b, uv_f],
						[f_,b_,a_,uv_f, uv_b, uv_a],
						[a_,e_,f_,uv_a, uv_e, uv_f],
						[k_,e_,a_,uv_k, uv_e, uv_a],
						[k_,d_,e_,uv_k, uv_d, uv_e],
						[d_,k_,l_,uv_d, uv_k, uv_l],
						[l_,c_,d_,uv_l, uv_c, uv_d]
					]
			}},
		"cube33":{
			"BOTTOM":{
				"triangles":[
						[b_, c_, a_,uv_b, uv_c, uv_a],
						[d_, c_, b_,uv_d, uv_c, uv_b]
					]
			},
			"FRONT":{
				"triangles":[
						[c_, b_ ,a_,uv_c, uv_b, uv_a],
						[d_, c_, a_,uv_d, uv_c, uv_a]
					]
			},
			"BACK":{
				"triangles":[
						[a_,b_,h_,uv_a, uv_b, uv_h],
						[b_,g_,h_,uv_b, uv_g, uv_h],
						[f_,g_,b_,uv_f, uv_g, uv_b],
						[e_,f_,b_,uv_e, uv_f, uv_b],
						[c_,e_,b_,uv_c, uv_e, uv_b],
						[d_,e_,c_,uv_d, uv_e, uv_c]
					]
			},
			"LEFT":{
				"triangles":[
						[f_, b_, a_,uv_f, uv_b, uv_a],
						[e_, f_, a_,uv_e, uv_f, uv_a],
						[d_, e_, a_,uv_d, uv_e, uv_a],
						[c_, d_, a_,uv_c, uv_d, uv_a]
					]
			},
			"RIGHT":{
				"triangles":[
						[d_,c_,a_,uv_d, uv_c, uv_a],
						[f_,d_,a_,uv_f, uv_d, uv_a],
						[e_,f_,a_,uv_e, uv_f, uv_a],
						[b_,e_,a_,uv_b, uv_e, uv_a]
						]
			},
			"TOP":{
				"triangles":[
						[h_,g_,i_,uv_h, uv_g, uv_i],
						[j_,i_,g_,uv_j, uv_i, uv_g],
						[j_,g_,f_,uv_j, uv_g, uv_f],
						[f_,b_,j_,uv_f, uv_b, uv_j],
						[a_,b_,f_,uv_a, uv_b, uv_f],
						[f_,e_,a_,uv_f, uv_e, uv_a],
						[a_,e_,k_,uv_a, uv_e, uv_k],
						[e_,d_,k_,uv_e, uv_d, uv_k],
						[l_,k_,d_,uv_l, uv_k, uv_d],
						[d_,c_,l_,uv_d, uv_c, uv_l]
					]
			}},
	"cube34":{
			"BOTTOM":{
				"triangles":[
						[b_, c_, a_,uv_b, uv_c, uv_a],
						[d_, c_, b_,uv_d, uv_c, uv_b]
						
					]
			},
			"RIGHT":{
				"triangles":[
						[c_, b_ ,a_,uv_c, uv_b, uv_a],
						[d_, c_, a_,uv_d, uv_c, uv_a]
					]
			},
			"LEFT":{
				"triangles":[
						[a_,b_,h_,uv_a, uv_b, uv_h],
						[b_,g_,h_,uv_b, uv_g, uv_h],
						[f_,g_,b_,uv_f, uv_g, uv_b],
						[e_,f_,b_,uv_e, uv_f, uv_b],
						[c_,e_,b_,uv_c, uv_e, uv_b],
						[d_,e_,c_,uv_d, uv_e, uv_c]
					]
			},
			"FRONT":{
				"triangles":[
						[f_, b_, a_,uv_f, uv_b, uv_a],
						[e_, f_, a_,uv_e, uv_f, uv_a],
						[d_, e_, a_,uv_d, uv_e, uv_a],
						[c_, d_, a_,uv_c, uv_d, uv_a]
						
					]
			},
			"BACK":{
				"triangles":[
						[d_,c_,a_,uv_d, uv_c, uv_a],
						[f_,d_,a_,uv_f, uv_d, uv_a],
						[e_,f_,a_,uv_e, uv_f, uv_a],
						[b_,e_,a_,uv_b, uv_e, uv_a]
						]
			},
			"TOP":{
				"triangles":[
						[h_,g_,i_,uv_h, uv_g, uv_i],
						[j_,i_,g_,uv_j, uv_i, uv_g],
						[j_,g_,f_,uv_j, uv_g, uv_f],
						[f_,b_,j_,uv_f, uv_b, uv_j],
						[a_,b_,f_,uv_a, uv_b, uv_f],
						[f_,e_,a_,uv_f, uv_e, uv_a],
						[a_,e_,k_,uv_a, uv_e, uv_k],
						[e_,d_,k_,uv_e, uv_d, uv_k],
						[l_,k_,d_,uv_l, uv_k, uv_d],
						[d_,c_,l_,uv_d, uv_c, uv_l]
					]
			}},
		"cube35":{
			"BOTTOM":{
				"triangles":[
						[a_, c_, b_,uv_a, uv_b, uv_c],
						[b_, c_, d_,uv_a, uv_c, uv_d]
					]
			},
			"RIGHT":{
				"triangles":[
						[h_,b_,a_,uv_h, uv_b, uv_a],
						[h_,g_,b_,uv_h, uv_g, uv_b],
						[b_,g_,f_,uv_b, uv_g, uv_f],
						[b_,f_,e_,uv_b, uv_f, uv_e],
						[b_,e_,c_,uv_b, uv_e, uv_c],
						[c_,e_,d_,uv_c, uv_e, uv_d]
					]
			},
			"LEFT":{
				"triangles":[
						[a_, b_ ,c_,uv_a, uv_b, uv_c],
						[a_, c_, d_,uv_a, uv_c, uv_d]
					]
			},
			"FRONT":{
				"triangles":[
						[a_, b_, f_,uv_a, uv_b, uv_f],
						[a_, f_, e_,uv_a, uv_f, uv_e],
						[a_, e_, d_,uv_a, uv_e, uv_d],
						[a_, d_, c_,uv_a, uv_d, uv_c]
					]
			},
			"BACK":{
				"triangles":[
						[a_,c_,d_,uv_a, uv_c, uv_d],
						[a_,d_,f_,uv_a, uv_d, uv_f],
						[a_,f_,e_,uv_a, uv_f, uv_e],
						[a_,e_,b_,uv_a, uv_e, uv_b]
						]
			},
			"TOP":{
				"triangles":[
						[i_,g_,h_,uv_i, uv_g, uv_h],
						[g_,i_,j_,uv_g, uv_i, uv_j],
						[f_,g_,j_,uv_f, uv_g, uv_j],
						[j_,b_,f_,uv_j, uv_b, uv_f],
						[f_,b_,a_,uv_f, uv_b, uv_a],
						[a_,e_,f_,uv_a, uv_e, uv_f],
						[k_,e_,a_,uv_k, uv_e, uv_a],
						[k_,d_,e_,uv_k, uv_d, uv_e],
						[d_,k_,l_,uv_d, uv_k, uv_l],
						[l_,c_,d_,uv_l, uv_c, uv_d]
					]
			}},
		"cube36":{
			"BOTTOM":{
				"triangles":[
						[a_, c_, b_,uv_a, uv_c, uv_b],
						[b_, c_, d_,uv_b, uv_c, uv_d]
					]
			},
			"FRONT":{
				"triangles":[
						[b_,a_,h_,uv_b, uv_a, uv_h],
						[b_,h_,g_,uv_b, uv_h, uv_g],
						[b_,g_,f_,uv_b, uv_g, uv_f],
						[b_,f_,e_,uv_b, uv_f, uv_e],
						[b_,e_,c_,uv_b, uv_e, uv_c],
						[c_,e_,d_,uv_c, uv_e, uv_d]
					]
			},
			"BACK":{
				"triangles":[
						[h_,a_,b_,uv_h, uv_a, uv_b],
						[g_,h_,b_,uv_g, uv_h, uv_b],
						[f_,g_,b_,uv_f, uv_g, uv_b],
						[e_,f_,b_,uv_e, uv_f, uv_b],
						[c_,e_,b_,uv_c, uv_e, uv_b],
						[d_,e_,c_,uv_d, uv_e, uv_c]
					]
			},
			"LEFT":{
				"triangles":[
						[f_,e_,a_,uv_f, uv_e, uv_a],
						[g_,f_,a_,uv_g, uv_f, uv_a],
						[h_,g_,a_,uv_h, uv_g, uv_a],
						[d_,h_,a_,uv_d, uv_h, uv_a],
						[b_,d_,a_,uv_b, uv_d, uv_a],
						[d_,b_,c_,uv_d, uv_b, uv_c]
					]
			},
			"RIGHT":{
				"triangles":[
							[a_,e_,f_,uv_a, uv_e, uv_f],
							[a_,f_,h_,uv_a, uv_f, uv_h],
							[a_,h_,g_,uv_a, uv_h, uv_g],
							[a_,g_,c_,uv_a, uv_g, uv_c],
							[a_,c_,b_,uv_a, uv_c, uv_b],
							[c_,d_,b_,uv_c, uv_d, uv_b]
						]
			},
			"TOP":{
				"triangles":[
						[o_,p_,q_,uv_o, uv_p, uv_q],
						[o_,q_,r_,uv_o, uv_q, uv_r],
						[n_,o_,r_,uv_n, uv_o, uv_r],
						[h_,n_,r_,uv_h, uv_n, uv_r],
						[g_,f_,e_,uv_g, uv_f, uv_e],
						[h_,g_,e_,uv_h, uv_g, uv_e],
						[e_,d_,h_,uv_e, uv_d, uv_h],
						[n_,h_,d_,uv_n, uv_h, uv_d],
						[m_,n_,d_,uv_m, uv_n, uv_d],
						[d_,i_,m_,uv_d, uv_i, uv_m],
						[d_,c_,i_,uv_d, uv_c, uv_i],
						[s_,m_,i_,uv_s, uv_m, uv_i],
						[m_,s_,l_,uv_m, uv_s, uv_l],
						[s_,t_,l_,uv_s, uv_t, uv_l],
						[t_,k_,l_,uv_t, uv_k, uv_l],
						[c_,b_,i_,uv_c, uv_b, uv_i],
						[j_,i_,b_,uv_j, uv_i, uv_b],
						[b_,a_,j_,uv_b, uv_a, uv_j]
					]
			}},
		"cube37":{
			"BOTTOM":{
				"triangles":[
						[a_, c_, b_,uv_a, uv_c, uv_b],
						[b_, c_, d_,uv_b, uv_c, uv_d]
					]
			},
			"FRONT":{
				"triangles":[
						[b_,a_,f_,uv_b, uv_a, uv_f],
						[b_,f_,e_,uv_b, uv_f, uv_e],
						[b_,e_,d_,uv_b, uv_e, uv_d],
						[b_,d_,c_,uv_b, uv_d, uv_c]
					]
			},
			"BACK":{
				"triangles":[
						[h_,a_,b_,uv_h, uv_a, uv_b],
						[g_,h_,b_,uv_g, uv_h, uv_b],
						[f_,g_,b_,uv_f, uv_g, uv_b],
						[e_,f_,b_,uv_e, uv_f, uv_b],
						[c_,e_,b_,uv_c, uv_e, uv_b],
						[d_,e_,c_,uv_d, uv_e, uv_c]
					]
			},
			"LEFT":{
				"triangles":[
						[f_,e_,a_,uv_f, uv_e, uv_a],
						[g_,f_,a_,uv_g, uv_f, uv_a],
						[h_,g_,a_,uv_h, uv_g, uv_a],
						[d_,h_,a_,uv_d, uv_g, uv_a],
						[b_,d_,a_,uv_b, uv_d, uv_a],
						[c_,d_,b_,uv_c, uv_d, uv_b]
					]
			},
			"RIGHT":{
				"triangles":[
						[b_,a_,e_,uv_b, uv_a, uv_e],
						[d_,b_,e_,uv_d, uv_b, uv_e],
						[c_,d_,e_,uv_c, uv_d, uv_e],
						[f_,c_,e_,uv_f, uv_c, uv_e]
						]
			},
			"TOP":{
				"triangles":[
						[n_,o_,m_,uv_n, uv_o, uv_m],
						[o_,p_,m_,uv_o, uv_p, uv_m],
						[m_,p_,l_,uv_m,uv_p, uv_l],
						[p_,h_,l_,uv_p, uv_h, uv_l],
						[l_,h_,d_,uv_l, uv_h, uv_d],
						[l_,d_,c_,uv_l, uv_d, uv_c],
						[l_,c_,i_,uv_l, uv_c, uv_i],
						[l_,i_,k_,uv_l, uv_i, uv_k],
						[h_,g_,e_,uv_h, uv_g, uv_e],
						[h_,e_,d_,uv_h, uv_e, uv_d],
						[g_,f_,e_,uv_g, uv_f, uv_e],
						[c_,b_,i_,uv_c, uv_b, uv_i],
						[i_,b_,j_,uv_i, uv_b, uv_j],
						[b_,a_,j_,uv_b, uv_a, uv_j]
					]
			}},
		"cube38":{
			"BOTTOM":{
				"triangles":[
					[b_, c_, a_,uv_b, uv_c, uv_a],
					[d_, c_, b_,uv_d, uv_c, uv_b]
					]
			},
			"FRONT":{
				"triangles":[
						[f_,a_,b_,uv_f, uv_a, uv_b],
						[e_,f_,b_,uv_e, uv_f, uv_b],
						[d_,e_,b_,uv_d, uv_e, uv_b],
						[c_,d_,b_,uv_c, uv_d, uv_b]
					]
			},
			"BACK":{
				"triangles":[
						[b_,a_,h_,uv_b, uv_a, uv_h],
						[b_,h_,g_,uv_b, uv_h, uv_g],
						[b_,g_,f_,uv_b, uv_g, uv_f],
						[b_,f_,e_,uv_b, uv_f, uv_e],
						[b_,e_,c_,uv_b, uv_e, uv_c],
						[c_,e_,d_,uv_c, uv_e, uv_d]
					]
			},
			"LEFT":{
				"triangles":[
						[e_,a_,b_,uv_e, uv_a, uv_b],
						[e_,b_,d_,uv_e, uv_b, uv_c],
						[e_,d_,c_,uv_e, uv_d, uv_c],
						[e_,c_,f_,uv_e, uv_c, uv_f],
					]
			},
			"RIGHT":{
				"triangles":[
						[a_,e_,f_,uv_a, uv_e, uv_f],
						[a_,f_,g_,uv_a, uv_f, uv_g],
						[a_,g_,h_,uv_a, uv_g, uv_h],
						[a_,h_,d_,uv_a, uv_h, uv_d],
						[a_,d_,b_,uv_a, uv_d, uv_b],
						[b_,d_,c_,uv_b, uv_d, uv_c]
						]
			},
			"TOP":{
				"triangles":[
						[m_,o_,n_,uv_m, uv_o, uv_n],
						[m_,p_,o_,uv_m, uv_p, uv_o],
						[l_,p_,m_,uv_l,uv_p, uv_m],
						[l_,h_,p_,uv_l, uv_h, uv_p],
						[d_,h_,l_,uv_d, uv_h, uv_l],
						[c_,d_,l_,uv_c, uv_d, uv_l],
						[i_,c_,l_,uv_i, uv_c, uv_l],
						[k_,i_,l_,uv_k, uv_i, uv_l],
						[h_,d_,e_,uv_h, uv_d, uv_e],
						[h_,e_,g_,uv_h, uv_e, uv_g],
						[e_,f_,g_,uv_e, uv_f, uv_g],
						[i_,b_,c_,uv_i, uv_b, uv_c],
						[j_,b_,i_,uv_j, uv_b, uv_i],
						[j_,a_,b_,uv_j, uv_a, uv_b]
					]
			}},
		"cube39":{
			"BOTTOM":{
				"triangles":[
					[b_, c_, a_,uv_b, uv_c, uv_a],
					[d_, c_, b_,uv_d, uv_c, uv_b]
					]
			},
			"FRONT":{
				"triangles":[
						[f_,a_,b_,uv_f, uv_a, uv_b],
						[e_,f_,b_,uv_e, uv_f, uv_b],
						[d_,e_,b_,uv_d, uv_e, uv_b],
						[c_,d_,b_,uv_c, uv_d, uv_b],
					]
			},
			"BACK":{
				"triangles":[
						[b_,a_,h_,uv_b, uv_a, uv_h],
						[b_,h_,g_,uv_b, uv_h, uv_g],
						[b_,g_,f_,uv_b, uv_g, uv_f],
						[b_,f_,e_,uv_b, uv_f, uv_e],
						[b_,e_,c_,uv_b, uv_e, uv_c],
						[c_,e_,d_,uv_c, uv_e, uv_d],
					]
			},
			"LEFT":{
				"triangles":[
						[e_,a_,b_,uv_e, uv_a, uv_b],
						[e_,b_,d_,uv_e, uv_b, uv_c],
						[e_,d_,c_,uv_e, uv_d, uv_c],
						[e_,c_,f_,uv_e, uv_c, uv_f],
					]
			},
			"RIGHT":{
				"triangles":[
						[a_,e_,f_,uv_a, uv_e, uv_f],
						[a_,f_,g_,uv_a, uv_f, uv_g],
						[a_,g_,h_,uv_a, uv_g, uv_h],
						[a_,h_,d_,uv_a, uv_h, uv_d],
						[a_,d_,b_,uv_a, uv_d, uv_b],
						[b_,d_,c_,uv_b, uv_d, uv_c],
						]
			},
			"TOP":{
				"triangles":[
						[m_,o_,n_,uv_m, uv_o, uv_n],
						[m_,p_,o_,uv_m, uv_p, uv_o],
						[l_,p_,m_,uv_l,uv_p, uv_m],
						[l_,h_,p_,uv_l, uv_h, uv_p],
						[d_,h_,l_,uv_d, uv_h, uv_l],
						[c_,d_,l_,uv_c, uv_d, uv_l],
						[i_,c_,l_,uv_i, uv_c, uv_l],
						[k_,i_,l_,uv_k, uv_i, uv_l],
						[h_,d_,e_,uv_h, uv_d, uv_e],
						[h_,e_,g_,uv_h, uv_e, uv_g],
						[e_,f_,g_,uv_e, uv_f, uv_g],
						[i_,b_,c_,uv_i, uv_b, uv_c],
						[j_,b_,i_,uv_j, uv_b, uv_i],
						[j_,a_,b_,uv_j, uv_a, uv_b],
					]
			}},
		"cube40":{
			"BOTTOM":{
				"triangles":[
					[b_, c_, a_,uv_b, uv_c, uv_a],
					[d_, c_, b_,uv_d, uv_c, uv_b]
					]
			},
			"FRONT":{
				"triangles":[
						[b_,a_,h_,uv_b, uv_a, uv_h],
						[b_,h_,g_,uv_b, uv_h, uv_g],
						[b_,g_,f_,uv_b, uv_g, uv_f],
						[b_,f_,e_,uv_b, uv_f, uv_e],
						[b_,e_,c_,uv_b, uv_e, uv_c],
						[c_,e_,d_,uv_c, uv_e, uv_d]
					]
			},
			"BACK":{
				"triangles":[
						[f_,a_,b_,uv_f, uv_a, uv_b],
						[e_,f_,b_,uv_e, uv_f, uv_b],
						[d_,e_,b_,uv_d, uv_e, uv_b],
						[c_,d_,b_,uv_c, uv_d, uv_b],
					]
			},
			"LEFT":{
				"triangles":[
						[a_,e_,f_,uv_a, uv_e, uv_f],
						[a_,f_,g_,uv_a, uv_f, uv_g],
						[a_,g_,h_,uv_a, uv_g, uv_h],
						[a_,h_,d_,uv_a, uv_h, uv_d],
						[a_,d_,b_,uv_a, uv_d, uv_b],
						[b_,d_,c_,uv_b, uv_d, uv_c],
					]
			},
			"RIGHT":{
				"triangles":[
						[e_,a_,b_,uv_e, uv_a, uv_b],
						[e_,b_,d_,uv_e, uv_b, uv_c],
						[e_,d_,c_,uv_e, uv_d, uv_c],
						[e_,c_,f_,uv_e, uv_c, uv_f],
						]
			},
			"TOP":{
				"triangles":[
						[m_,o_,n_,uv_m, uv_o, uv_n],
						[m_,p_,o_,uv_m, uv_p, uv_o],
						[l_,p_,m_,uv_l,uv_p, uv_m],
						[l_,h_,p_,uv_l, uv_h, uv_p],
						[d_,h_,l_,uv_d, uv_h, uv_l],
						[c_,d_,l_,uv_c, uv_d, uv_l],
						[i_,c_,l_,uv_i, uv_c, uv_l],
						[k_,i_,l_,uv_k, uv_i, uv_l],
						[h_,d_,e_,uv_h, uv_d, uv_e],
						[h_,e_,g_,uv_h, uv_e, uv_g],
						[e_,f_,g_,uv_e, uv_f, uv_g],
						[i_,b_,c_,uv_i, uv_b, uv_c],
						[j_,b_,i_,uv_j, uv_b, uv_i],
						[j_,a_,b_,uv_j, uv_a, uv_b],
					]
			}},
		"cube41":{
			"BOTTOM":{
				"triangles":[
						[a_, c_, b_,uv_a, uv_c, uv_b],
						[b_, c_, d_,uv_b, uv_c, uv_d],
					]
			},
			"FRONT":{
				"triangles":[
						[b_,a_,h_,uv_b, uv_a, uv_h],
						[b_,h_,g_,uv_b, uv_h, uv_g],
						[b_,g_,f_,uv_b, uv_g, uv_f],
						[b_,f_,c_,uv_b, uv_f, uv_c],
						[f_,e_,c_,uv_f, uv_e, uv_c],
						[e_,d_,c_,uv_e, uv_d, uv_c],
					]
			},
			"BACK":{
				"triangles":[
						[a_,b_,d_,uv_a, uv_b, uv_d],
						[b_,c_,d_,uv_b, uv_c, uv_d],
					]
			},
			"LEFT":{
				"triangles":[
						[e_,a_,d_,uv_e, uv_a, uv_d],
						[e_,d_,c_,uv_e, uv_d, uv_c],
						[e_,c_,b_,uv_e, uv_c, uv_b],
						[e_,b_,f_,uv_e, uv_b, uv_f],
						[f_,b_,h_,uv_f, uv_b, uv_h],
						[f_,h_,g_,uv_f, uv_h, uv_g],
					]
			},
			"RIGHT":{
				"triangles":[
						[b_,a_,e_,uv_b, uv_a, uv_e],
						[c_,b_,e_,uv_c, uv_b, uv_e],
						[d_,c_,e_,uv_d, uv_c, uv_e],
						[f_,d_,e_,uv_f, uv_d, uv_e],
						[f_,g_,d_,uv_f, uv_g, uv_d],
						[f_,h_,g_,uv_f, uv_h, uv_g],
						]
			},
			"TOP":{
				"triangles":[
						[j_,d_,c_,uv_j, uv_d, uv_c],
						[j_,n_,d_,uv_j, uv_n, uv_d],
						[j_,c_,i_,uv_j, uv_c, uv_i],
						[i_,c_,o_,uv_i, uv_c, uv_o],
						[k_,m_,n_,uv_k, uv_m , uv_n],
						[j_,k_,n_,uv_j, uv_k, uv_n],
						[l_,m_,k_,uv_l, uv_m, uv_k],
						[h_,i_,o_,uv_h, uv_i, uv_o],
						[h_,o_,p_,uv_h, uv_o, uv_p],
						[g_,h_,p_,uv_g, uv_h, uv_p],
						[c_,d_,e_,uv_c, uv_d, uv_e],
						[c_,e_,b_,uv_c, uv_e, uv_b],
						[b_,e_,a_,uv_b, uv_e, uv_a],
						[a_,e_,f_,uv_a, uv_e, uv_f],
					]
			}},
		"cube42":{
			"BOTTOM":{
				"triangles":[
					[b_, c_, a_,uv_b, uv_c, uv_a],
					[d_, c_, b_,uv_d, uv_c, uv_b],
					]
			},
			"FRONT":{
				"triangles":[
						[d_,b_,a_,uv_d, uv_b, uv_a],
						[d_,c_,b_,uv_d, uv_c, uv_b],
					]
			},
			"BACK":{
				"triangles":[
						[h_,a_,b_,uv_h, uv_a, uv_b],
						[g_,h_,b_,uv_g, uv_h, uv_b],
						[f_,g_,b_,uv_f, uv_g, uv_b],
						[c_,f_,b_,uv_c, uv_f, uv_b],
						[c_,e_,f_,uv_c, uv_e, uv_f],
						[c_,d_,e_,uv_c, uv_d, uv_e],
					]
			},
			"LEFT":{
				"triangles":[
						[d_,a_,e_,uv_d, uv_a, uv_e],
						[c_,d_,e_,uv_c, uv_d, uv_e],
						[b_,c_,e_,uv_b, uv_c, uv_e],
						[f_,b_,e_,uv_f, uv_b, uv_e],
						[h_,b_,f_,uv_h, uv_b, uv_f],
						[g_,h_,f_,uv_g, uv_h, uv_f],
					]
			},
			"RIGHT":{
				"triangles":[
						[e_,a_,b_,uv_e, uv_a, uv_b],
						[e_,b_,c_,uv_e, uv_b, uv_c],
						[e_,c_,d_,uv_e, uv_c, uv_d],
						[e_,d_,f_,uv_e, uv_d, uv_f],
						[d_,g_,f_,uv_d, uv_g, uv_f],
						[g_,h_,f_,uv_g, uv_h, uv_f],
						]
			},
			"TOP":{
				"triangles":[
						[c_,d_,j_,uv_c, uv_d, uv_j],
						[d_,n_,j_,uv_d, uv_n, uv_j],
						[i_,c_,j_,uv_i, uv_c, uv_j],
						[o_,c_,i_,uv_o, uv_c, uv_i],
						[n_,m_,k_,uv_n, uv_m , uv_k],
						[n_,k_,j_,uv_n, uv_k, uv_j],
						[k_,m_,l_,uv_k, uv_m, uv_l],
						[o_,i_,h_,uv_o, uv_i, uv_h],
						[p_,o_,h_,uv_p, uv_o, uv_h],
						[p_,h_,g_,uv_p, uv_h, uv_g],
						[e_,d_,c_,uv_e, uv_d, uv_c],
						[b_,e_,c_,uv_b, uv_e, uv_c],
						[a_,e_,b_,uv_a, uv_e, uv_b],
						[f_,e_,a_,uv_f, uv_e, uv_a],
					]
			}},
		"cube43":{
			"BOTTOM":{
				"triangles":[
					[a_, c_, b_,uv_a, uv_c, uv_b],
					[b_, c_, d_,uv_b, uv_c, uv_d],
					]
			},
			"FRONT":{
				"triangles":[
						[e_,a_,d_,uv_e, uv_a, uv_d],
						[e_,d_,c_,uv_e, uv_d, uv_c],
						[e_,c_,b_,uv_e, uv_c, uv_b],
						[e_,b_,f_,uv_e, uv_b, uv_f],
						[f_,b_,h_,uv_f, uv_b, uv_h],
						[f_,h_,g_,uv_f, uv_h, uv_g],
					]
			},
			"BACK":{
				"triangles":[
						[b_,a_,e_,uv_b, uv_a, uv_e],
						[c_,b_,e_,uv_c, uv_b, uv_e],
						[d_,c_,e_,uv_d, uv_c, uv_e],
						[f_,d_,e_,uv_f, uv_d, uv_e],
						[f_,g_,d_,uv_f, uv_g, uv_d],
						[f_,h_,g_,uv_f, uv_h, uv_g],
					]
			},
			"LEFT":{
				"triangles":[
						[a_,b_,d_,uv_a, uv_b, uv_d],
						[b_,c_,d_,uv_b, uv_c, uv_d],
					]
			},
			"RIGHT":{
				"triangles":[
						[b_,a_,h_,uv_b, uv_a, uv_h],
						[b_,h_,g_,uv_b, uv_h, uv_g],
						[b_,g_,f_,uv_b, uv_g, uv_f],
						[b_,f_,c_,uv_b, uv_f, uv_c],
						[f_,e_,c_,uv_f, uv_e, uv_c],
						[e_,d_,c_,uv_e, uv_d, uv_c],
						]
			},
			"TOP":{
				"triangles":[
						[j_,d_,c_,uv_j, uv_d, uv_c],
						[j_,n_,d_,uv_j, uv_n, uv_d],
						[j_,c_,i_,uv_j, uv_c, uv_i],
						[i_,c_,o_,uv_i, uv_c, uv_o],
						[k_,m_,n_,uv_k, uv_m , uv_n],
						[j_,k_,n_,uv_j, uv_k, uv_n],
						[l_,m_,k_,uv_l, uv_m, uv_k],
						[h_,i_,o_,uv_h, uv_i, uv_o],
						[h_,o_,p_,uv_h, uv_o, uv_p],
						[g_,h_,p_,uv_g, uv_h, uv_p],
						[c_,d_,e_,uv_c, uv_d, uv_e],
						[c_,e_,b_,uv_c, uv_e, uv_b],
						[b_,e_,a_,uv_b, uv_e, uv_a],
						[a_,e_,f_,uv_a, uv_e, uv_f],
					]
			}},
		"cube44":{
			"BOTTOM":{
				"triangles":[
					[b_, c_, a_,uv_b, uv_c, uv_a],
					[d_, c_, b_,uv_d, uv_c, uv_b],
					]
			},
			"FRONT":{
				"triangles":[
						[d_,a_,e_,uv_d, uv_a, uv_e],
						[c_,d_,e_,uv_c, uv_d, uv_e],
						[b_,c_,e_,uv_b, uv_c, uv_e],
						[f_,b_,e_,uv_f, uv_b, uv_e],
						[h_,b_,f_,uv_h, uv_b, uv_f],
						[g_,h_,f_,uv_g, uv_h, uv_f],
					]
			},
			"BACK":{
				"triangles":[
						[e_,a_,b_,uv_e, uv_a, uv_b],
						[e_,b_,c_,uv_e, uv_b, uv_c],
						[e_,c_,d_,uv_e, uv_c, uv_d],
						[e_,d_,f_,uv_e, uv_d, uv_f],
						[d_,g_,f_,uv_d, uv_g, uv_f],
						[g_,h_,f_,uv_g, uv_h, uv_f],
					]
			},
			"LEFT":{
				"triangles":[
						[h_,a_,b_,uv_h, uv_a, uv_b],
						[g_,h_,b_,uv_g, uv_h, uv_b],
						[f_,g_,b_,uv_f, uv_g, uv_b],
						[c_,f_,b_,uv_c, uv_f, uv_b],
						[c_,e_,f_,uv_c, uv_e, uv_f],
						[c_,d_,e_,uv_c, uv_d, uv_e],
					]
			},
			"RIGHT":{
				"triangles":[
						[d_,b_,a_,uv_d, uv_b, uv_a],
						[d_,c_,b_,uv_d, uv_c, uv_b],
						]
			},
			"TOP":{
				"triangles":[
						[c_,d_,j_,uv_c, uv_d, uv_j],
						[d_,n_,j_,uv_d, uv_n, uv_j],
						[i_,c_,j_,uv_i, uv_c, uv_j],
						[o_,c_,i_,uv_o, uv_c, uv_i],
						[n_,m_,k_,uv_n, uv_m , uv_k],
						[n_,k_,j_,uv_n, uv_k, uv_j],
						[k_,m_,l_,uv_k, uv_m, uv_l],
						[o_,i_,h_,uv_o, uv_i, uv_h],
						[p_,o_,h_,uv_p, uv_o, uv_h],
						[p_,h_,g_,uv_p, uv_h, uv_g],
						[e_,d_,c_,uv_e, uv_d, uv_c],
						[b_,e_,c_,uv_b, uv_e, uv_c],
						[a_,e_,b_,uv_a, uv_e, uv_b],
						[f_,e_,a_,uv_f, uv_e, uv_a],
					]
				}},
		"cube45":{
			"BOTTOM":{
				"triangles":[
					[a_, c_, b_,uv_a, uv_c, uv_b],
					[b_, c_, d_,uv_b, uv_c, uv_d]
					]
			},
			"FRONT":{
				"triangles":[
						[b_,a_,f_,uv_b, uv_a, uv_f],
						[b_,f_,e_,uv_b, uv_f, uv_e],
						[b_,e_,d_,uv_b, uv_e, uv_d],
						[b_,d_,c_,uv_b, uv_d, uv_c],
					]
			},
			"BACK":{
				"triangles":[
					[b_,d_,a_,uv_b, uv_d, uv_a],
					[c_,d_,b_,uv_c, uv_d, uv_b],
					]
			},
			"LEFT":{
				"triangles":[
						[e_,a_,d_,uv_e, uv_a, uv_d],
						[e_,d_,c_,uv_e, uv_d, uv_c],
						[e_,c_,b_,uv_e, uv_c, uv_b],
						[e_,b_,h_,uv_e, uv_b, uv_h],
						[e_,h_,f_,uv_e, uv_h, uv_f],
						[f_,h_,g_,uv_f, uv_h, uv_g],
					]
			},
			"RIGHT":{
				"triangles":[
						[b_,a_,e_,uv_b, uv_a, uv_e],
						[c_,b_,e_,uv_c, uv_b, uv_e],
						[d_,c_,e_,uv_d, uv_c, uv_e],
						[f_,d_,e_,uv_f, uv_d, uv_e],
						]
			},
			"TOP":{
				"triangles":[
						[i_,j_,k_,uv_i, uv_j, uv_k],
						[i_,k_,l_,uv_i, uv_k, uv_l],
						[h_,i_,l_,uv_h, uv_i, uv_l],
						[h_,l_,d_,uv_h, uv_l, uv_d],
						[g_,h_,d_,uv_g, uv_h, uv_d],
						[g_,d_,c_,uv_g, uv_d, uv_c],
						[c_,d_,e_,uv_c, uv_d, uv_e],
						[c_,e_,b_,uv_c, uv_e, uv_b],
						[b_,e_,a_,uv_b, uv_e, uv_a],
						[e_,f_,a_,uv_e, uv_f, uv_a],
					]
				}},
		"cube46":{
			"BOTTOM":{
				"triangles":[
					[b_, c_, a_,uv_b, uv_c, uv_a],
					[d_, c_, b_,uv_d, uv_c, uv_b],
					]
			},
			"FRONT":{
				"triangles":[
						[f_,a_,b_,uv_f, uv_a, uv_b],
						[e_,f_,b_,uv_e, uv_f, uv_b],
						[d_,e_,b_,uv_d, uv_e, uv_b],
						[c_,d_,b_,uv_c, uv_d, uv_b],
					]
			},
			"BACK":{
				"triangles":[
					[a_,d_,b_,uv_a, uv_d, uv_b],
					[b_,d_,c_,uv_b, uv_d, uv_c],
					]
			},
			"LEFT":{
				"triangles":[
						[e_,a_,b_,uv_e, uv_a, uv_b],
						[e_,b_,c_,uv_e, uv_b, uv_c],
						[e_,c_,d_,uv_e, uv_c, uv_d],
						[e_,d_,f_,uv_e, uv_d, uv_f],
					]
			},
			"RIGHT":{
				"triangles":[
						[d_,a_,e_,uv_d, uv_a, uv_e],
						[c_,d_,e_,uv_c, uv_d, uv_e],
						[b_,c_,e_,uv_b, uv_c, uv_e],
						[h_,b_,e_,uv_h, uv_b, uv_e],
						[f_,h_,e_,uv_f, uv_h, uv_e],
						[g_,h_,f_,uv_g, uv_h, uv_f],
						]
			},
			"TOP":{
				"triangles":[
						[k_,j_,i_,uv_k, uv_j, uv_i],
						[l_,k_,i_,uv_l, uv_k, uv_i],
						[l_,i_,h_,uv_l, uv_i, uv_h],
						[d_,l_,h_,uv_d, uv_l, uv_h],
						[d_,h_,g_,uv_d, uv_h, uv_g],
						[c_,d_,g_,uv_c, uv_d, uv_g],
						[e_,d_,c_,uv_e, uv_d, uv_c],
						[b_,e_,c_,uv_b, uv_e, uv_c],
						[a_,e_,b_,uv_a, uv_e, uv_b],
						[a_,f_,e_,uv_a, uv_f, uv_e],
					]
				}},
		"cube47":{
			"BOTTOM":{
				"triangles":[
					[b_, c_, a_,uv_b, uv_c, uv_a],
					[d_, c_, b_,uv_d, uv_c, uv_b],
					]
			},
			"FRONT":{
				"triangles":[
						[d_,a_,e_,uv_d, uv_a, uv_e],
						[c_,d_,e_,uv_c, uv_d, uv_e],
						[b_,c_,e_,uv_b, uv_c, uv_e],
						[h_,b_,e_,uv_h, uv_b, uv_e],
						[f_,h_,e_,uv_f, uv_h, uv_e],
						[g_,h_,f_,uv_g, uv_h, uv_f],
					]
			},
			"BACK":{
				"triangles":[
					[e_,a_,b_,uv_e, uv_a, uv_b],
					[e_,b_,c_,uv_e, uv_b, uv_c],
					[e_,c_,d_,uv_e, uv_c, uv_d],
					[e_,d_,f_,uv_e, uv_d, uv_f],
					]
			},
			"LEFT":{
				"triangles":[
						[f_,a_,b_,uv_f, uv_a, uv_b],
						[e_,f_,b_,uv_e, uv_f, uv_b],
						[d_,e_,b_,uv_d, uv_e, uv_b],
						[c_,d_,b_,uv_c, uv_d, uv_b],
					]
			},
			"RIGHT":{
				"triangles":[
						[a_,d_,b_,uv_a, uv_d, uv_b],
						[b_,d_,c_,uv_b, uv_d, uv_c],
						]
			},
			"TOP":{
				"triangles":[
						[k_,j_,i_,uv_k, uv_j, uv_i],
						[l_,k_,i_,uv_l, uv_k, uv_i],
						[l_,i_,h_,uv_l, uv_i, uv_h],
						[d_,l_,h_,uv_d, uv_l, uv_h],
						[d_,h_,g_,uv_d, uv_h, uv_g],
						[c_,d_,g_,uv_c, uv_d, uv_g],
						[e_,d_,c_,uv_e, uv_d, uv_c],
						[b_,e_,c_,uv_b, uv_e, uv_c],
						[a_,e_,b_,uv_a, uv_e, uv_b],
						[a_,f_,e_,uv_a, uv_f, uv_e],
					]
				}},
		"cube48":{
			"BOTTOM":{
				"triangles":[
					[a_, c_, b_,uv_a, uv_c, uv_b],
					[b_, c_, d_,uv_b, uv_c, uv_d],
					]
			},
			"FRONT":{
				"triangles":[
						[b_,a_,e_,uv_b, uv_a, uv_e],
						[c_,b_,e_,uv_c, uv_b, uv_e],
						[d_,c_,e_,uv_d, uv_c, uv_e],
						[f_,d_,e_,uv_f, uv_d, uv_e],
					]
			},
			"BACK":{
				"triangles":[
					[e_,a_,d_,uv_e, uv_a, uv_d],
					[e_,d_,c_,uv_e, uv_d, uv_c],
					[e_,c_,b_,uv_e, uv_c, uv_b],
					[e_,b_,h_,uv_e, uv_b, uv_h],
					[e_,h_,f_,uv_e, uv_h, uv_f],
					[f_,h_,g_,uv_f, uv_h, uv_g],
					]
			},
			"LEFT":{
				"triangles":[
						[b_,a_,f_,uv_b, uv_a, uv_f],
						[b_,f_,e_,uv_b, uv_f, uv_e],
						[b_,e_,d_,uv_b, uv_e, uv_d],
						[b_,d_,c_,uv_b, uv_d, uv_c],
					]
			},
			"RIGHT":{
				"triangles":[
						[b_,d_,a_,uv_b, uv_d, uv_a],
						[c_,d_,b_,uv_c, uv_d, uv_b],
						]
			},
			"TOP":{
				"triangles":[
						[i_,j_,k_,uv_i, uv_j, uv_k],
						[i_,k_,l_,uv_i, uv_k, uv_l],
						[h_,i_,l_,uv_h, uv_i, uv_l],
						[h_,l_,d_,uv_h, uv_l, uv_d],
						[g_,h_,d_,uv_g, uv_h, uv_d],
						[g_,d_,c_,uv_g, uv_d, uv_c],
						[c_,d_,e_,uv_c, uv_d, uv_e],
						[c_,e_,b_,uv_c, uv_e, uv_b],
						[b_,e_,a_,uv_b, uv_e, uv_a],
						[e_,f_,a_,uv_e, uv_f, uv_a],
					]
				}},
		"cube49":{
			"BOTTOM":{
				"triangles":[
					[a_, c_, b_,uv_a, uv_b, uv_c],
					[b_, c_, d_,uv_a, uv_c, uv_d],
					]
			},
			"FRONT":{
				"triangles":[
						[e_,a_,d_,uv_e, uv_a, uv_d],
						[e_,d_,c_,uv_e, uv_d, uv_c],
						[e_,c_,b_,uv_e, uv_c, uv_b],
						[e_,b_,h_,uv_e, uv_b, uv_h],
						[e_,h_,f_,uv_e, uv_h, uv_f],
						[f_,h_,g_,uv_f, uv_h, uv_g],
					]
			},
			"BACK":{
				"triangles":[
					[b_,a_,e_,uv_b, uv_a, uv_e],
					[c_,b_,e_,uv_c, uv_b, uv_e],
					[d_,c_,e_,uv_d, uv_c, uv_e],
					[f_,d_,e_,uv_f, uv_d, uv_e],
					]
			},
			"LEFT":{
				"triangles":[
						[b_,d_,a_,uv_b, uv_d, uv_a],
						[c_,d_,b_,uv_c, uv_d, uv_b],
					]
			},
			"RIGHT":{
				"triangles":[
						[b_,a_,f_,uv_b, uv_a, uv_f],
						[b_,f_,e_,uv_b, uv_f, uv_e],
						[b_,e_,d_,uv_b, uv_e, uv_d],
						[b_,d_,c_,uv_b, uv_d, uv_c],
						]
			},
			"TOP":{
				"triangles":[
						[i_,j_,k_,uv_i, uv_j, uv_k],
						[i_,k_,l_,uv_i, uv_k, uv_l],
						[h_,i_,l_,uv_h, uv_i, uv_l],
						[h_,l_,d_,uv_h, uv_l, uv_d],
						[g_,h_,d_,uv_g, uv_h, uv_d],
						[g_,d_,c_,uv_g, uv_d, uv_c],
						[c_,d_,e_,uv_c, uv_d, uv_e],
						[c_,e_,b_,uv_c, uv_e, uv_b],
						[b_,e_,a_,uv_b, uv_e, uv_a],
						[e_,f_,a_,uv_e, uv_f, uv_a],
					]
				}},
		"cube50":{
			"BOTTOM":{
				"triangles":[
					[b_, c_, a_,uv_b, uv_c, uv_a],
					[d_, c_, b_,uv_d, uv_c, uv_b],
					]
			},
			"FRONT":{
				"triangles":[
						[d_,a_,e_,uv_d, uv_a, uv_e],
						[c_,d_,e_,uv_c, uv_d, uv_e],
						[b_,c_,e_,uv_b, uv_c, uv_e],
						[h_,b_,e_,uv_h, uv_b, uv_e],
						[f_,h_,e_,uv_f, uv_h, uv_e],
						[g_,h_,f_,uv_g, uv_h, uv_f],
					]
			},
			"BACK":{
				"triangles":[
					[e_,a_,b_,uv_e, uv_a, uv_b],
					[e_,b_,c_,uv_e, uv_b, uv_c],
					[e_,c_,d_,uv_e, uv_c, uv_d],
					[e_,d_,f_,uv_e, uv_d, uv_f],
					]
			},
			"LEFT":{
				"triangles":[
						[f_,a_,b_,uv_f, uv_a, uv_b],
						[e_,f_,b_,uv_e, uv_f, uv_b],
						[d_,e_,b_,uv_d, uv_e, uv_b],
						[c_,d_,b_,uv_c, uv_d, uv_b],
					]
			},
			"RIGHT":{
				"triangles":[
						[a_,d_,b_,uv_a, uv_d, uv_b],
						[b_,d_,c_,uv_b, uv_d, uv_c],
						]
			},
			"TOP":{
				"triangles":[
						[k_,j_,i_,uv_k, uv_j, uv_i],
						[l_,k_,i_,uv_l, uv_k, uv_i],
						[l_,i_,h_,uv_l, uv_i, uv_h],
						[d_,l_,h_,uv_d, uv_l, uv_h],
						[d_,h_,g_,uv_d, uv_h, uv_g],
						[c_,d_,g_,uv_c, uv_d, uv_g],
						[e_,d_,c_,uv_e, uv_d, uv_c],
						[b_,e_,c_,uv_b, uv_e, uv_c],
						[a_,e_,b_,uv_a, uv_e, uv_b],
						[a_,f_,e_,uv_a, uv_f, uv_e],
					]
			}},
		"cube51":{
			"BOTTOM":{
				"triangles":[
					[a_, c_, b_,uv_a, uv_b, uv_c],
					[b_, c_, d_,uv_a, uv_c, uv_d],
					]
			},
			"FRONT":{
				"triangles":[
						[b_,d_,a_,uv_b, uv_d, uv_a],
						[c_,d_,b_,uv_c, uv_d, uv_b],
					]
			},
			"BACK":{
				"triangles":[
					[b_,a_,f_,uv_b, uv_a, uv_f],
					[b_,f_,e_,uv_b, uv_f, uv_e],
					[b_,e_,d_,uv_b, uv_e, uv_d],
					[b_,d_,c_,uv_b, uv_d, uv_c],
					]
			},
			"LEFT":{
				"triangles":[
						[b_,a_,e_,uv_b, uv_a, uv_e],
						[c_,b_,e_,uv_c, uv_b, uv_e],
						[d_,c_,e_,uv_d, uv_c, uv_e],
						[f_,d_,e_,uv_f, uv_d, uv_e],
					]
			},
			"RIGHT":{
				"triangles":[
						[e_,a_,d_,uv_e, uv_a, uv_d],
						[e_,d_,c_,uv_e, uv_d, uv_c],
						[e_,c_,b_,uv_e, uv_c, uv_b],
						[e_,b_,h_,uv_e, uv_b, uv_h],
						[e_,h_,f_,uv_e, uv_h, uv_f],
						[f_,h_,g_,uv_f, uv_h, uv_g],
						]
			},
			"TOP":{
				"triangles":[
						[i_,j_,k_,uv_i, uv_j, uv_k],
						[i_,k_,l_,uv_i, uv_k, uv_l],
						[h_,i_,l_,uv_h, uv_i, uv_l],
						[h_,l_,d_,uv_h, uv_l, uv_d],
						[g_,h_,d_,uv_g, uv_h, uv_d],
						[g_,d_,c_,uv_g, uv_d, uv_c],
						[c_,d_,e_,uv_c, uv_d, uv_e],
						[c_,e_,b_,uv_c, uv_e, uv_b],
						[b_,e_,a_,uv_b, uv_e, uv_a],
						[e_,f_,a_,uv_e, uv_f, uv_a],
					]
				}},
		"cube52":{
			"BOTTOM":{
				"triangles":[
					[b_, c_, a_,uv_b, uv_c, uv_a],
					[d_, c_, b_,uv_d, uv_c, uv_b],
					]
			},
			"FRONT":{
				"triangles":[
						[a_,d_,b_,uv_a, uv_d, uv_b],
						[b_,d_,c_,uv_b, uv_d, uv_c],
					]
			},
			"BACK":{
				"triangles":[
					[f_,a_,b_,uv_f, uv_a, uv_b],
					[e_,f_,b_,uv_e, uv_f, uv_b],
					[d_,e_,b_,uv_d, uv_e, uv_b],
					[c_,d_,b_,uv_c, uv_d, uv_b],
					]
			},
			"LEFT":{
				"triangles":[
						[d_,a_,e_,uv_d, uv_a, uv_e],
						[c_,d_,e_,uv_c, uv_d, uv_e],
						[b_,c_,e_,uv_b, uv_c, uv_e],
						[h_,b_,e_,uv_h, uv_b, uv_e],
						[f_,h_,e_,uv_f, uv_h, uv_e],
						[g_,h_,f_,uv_g, uv_h, uv_f],
					]
			},
			"RIGHT":{
				"triangles":[
						[e_,a_,b_,uv_e, uv_a, uv_b],
						[e_,b_,c_,uv_e, uv_b, uv_c],
						[e_,c_,d_,uv_e, uv_c, uv_d],
						[e_,d_,f_,uv_e, uv_d, uv_f],
						]
			},
			"TOP":{
				"triangles":[
						[k_,j_,i_,uv_k, uv_j, uv_i],
						[l_,k_,i_,uv_l, uv_k, uv_i],
						[l_,i_,h_,uv_l, uv_i, uv_h],
						[d_,l_,h_,uv_d, uv_l, uv_h],
						[d_,h_,g_,uv_d, uv_h, uv_g],
						[c_,d_,g_,uv_c, uv_d, uv_g],
						[e_,d_,c_,uv_e, uv_d, uv_c],
						[b_,e_,c_,uv_b, uv_e, uv_c],
						[a_,e_,b_,uv_a, uv_e, uv_b],
						[a_,f_,e_,uv_a, uv_f, uv_e],
					]
				}},
		"fillcube1":{
			"BOTTOM":{
				"triangles":[
					[a_, c_, b_,uv_a, uv_c, uv_b],
					[b_, c_, d_,uv_b, uv_c, uv_d],
					]
			},
			"FRONT":{
				"triangles":[
						[f_, b_ ,a_,uv_f, uv_b, uv_a],
						[f_, e_, b_,uv_f, uv_e, uv_b],
						[b_, e_, d_,uv_b, uv_e, uv_d],
						[d_, c_, b_,uv_d, uv_c, uv_b],
					]
			},
			"BACK":{
				"triangles":[
					[a_, b_ ,c_,uv_a, uv_b, uv_c],
					[a_, c_, d_,uv_a, uv_c, uv_d],
					]
			},
			"LEFT":{
				"triangles":[
						[a_, b_, f_,uv_a, uv_b, uv_f],
						[a_, f_, e_,uv_a, uv_f, uv_e],
						[a_, e_, d_,uv_a, uv_e, uv_d],
						[a_, d_, c_,uv_a, uv_d, uv_c],
					]
			},
			"RIGHT":{
				"triangles":[
						[a_, c_, b_,uv_a, uv_c, uv_b],
						[b_, c_, d_,uv_b, uv_c, uv_d],
						]
			},
			"TOP":{
				"triangles":[
						[a_, c_, d_,uv_a, uv_c, uv_d],
						[a_, d_, h_,uv_a, uv_d, uv_h],
						[h_, b_, a_,uv_h, uv_b, uv_a],
						[d_, e_, h_,uv_d, uv_e, uv_h],
						[e_, g_, h_,uv_e, uv_g, uv_h],
						[f_, g_, e_,uv_f, uv_g, uv_e],
					]
				}},
		"fillcube2":{
			"BOTTOM":{
				"triangles":[
					[b_, c_, a_,uv_b, uv_c, uv_a],
					[d_, c_, b_,uv_d, uv_c, uv_b],
					]
			},
			"FRONT":{
				"triangles":[
						[a_, b_ ,f_,uv_a, uv_b, uv_f],
						[b_, e_, f_,uv_b, uv_e, uv_f],
						[d_, e_, b_,uv_d, uv_e, uv_b],
						[b_, c_, d_,uv_b, uv_c, uv_d],
					]
			},
			"BACK":{
				"triangles":[
					[c_, b_ ,a_,uv_c, uv_b, uv_a],
					[d_, c_, a_,uv_d, uv_c, uv_a],
					]
			},
			"LEFT":{
				"triangles":[
						[b_, c_, a_,uv_b, uv_c, uv_a],
						[d_, c_, b_,uv_d, uv_c, uv_b],
					]
			},
			"RIGHT":{
				"triangles":[
						[f_, b_, a_,uv_f, uv_b, uv_a],
						[e_, f_, a_,uv_e, uv_f, uv_a],
						[d_, e_, a_,uv_d, uv_e, uv_a],
						[c_, d_, a_,uv_c, uv_d, uv_a],
						]
			},
			"TOP":{
				"triangles":[
						[d_, c_, a_,uv_d, uv_c, uv_a],
						[h_, d_, a_,uv_h, uv_d, uv_a],
						[a_, b_, h_,uv_a, uv_b, uv_h],
						[h_, e_, d_,uv_h, uv_e, uv_d],
						[h_, g_, e_,uv_h, uv_g, uv_e],
						[e_, g_, f_,uv_e, uv_g, uv_f],
					]
				}},
		"fillcube3":{
			"BOTTOM":{
				"triangles":[
					[b_, c_, a_,uv_b, uv_c, uv_a],
					[d_, c_, b_,uv_d, uv_c, uv_b],
					]
			},
			"FRONT":{
				"triangles":[
						[c_, b_ ,a_,uv_c, uv_b, uv_a],
						[d_, c_, a_,uv_d, uv_c, uv_a],
					]
			},
			"BACK":{
				"triangles":[
					[a_, b_ ,f_,uv_a, uv_b, uv_f],
					[b_, e_, f_,uv_b, uv_e, uv_f],
					[d_, e_, b_,uv_d, uv_e, uv_b],
					[b_, c_, d_,uv_b, uv_c, uv_d],
					]
			},
			"LEFT":{
				"triangles":[
						[f_, b_, a_,uv_f, uv_b, uv_a],
						[e_, f_, a_,uv_e, uv_f, uv_a],
						[d_, e_, a_,uv_d, uv_e, uv_a],
						[c_, d_, a_,uv_c, uv_d, uv_a],
					]
			},
			"RIGHT":{
				"triangles":[
						[b_, c_, a_,uv_b, uv_c, uv_a],
						[d_, c_, b_,uv_d, uv_c, uv_b],
						]
			},
			"TOP":{
				"triangles":[
						[d_, c_, a_,uv_d, uv_c, uv_a],
						[h_, d_, a_,uv_h, uv_d, uv_a],
						[a_, b_, h_,uv_a, uv_b, uv_h],
						[h_, e_, d_,uv_h, uv_e, uv_d],
						[h_, g_, e_,uv_h, uv_g, uv_e],
						[e_, g_, f_,uv_e, uv_g, uv_f],
					]
				}},
		"fillcube4":{
			"BOTTOM":{
				"triangles":[
					[a_, c_, b_,uv_a, uv_c, uv_b],
					[b_, c_, d_,uv_b, uv_c, uv_d],
					]
			},
			"FRONT":{
				"triangles":[
						[a_, b_ ,c_,uv_a, uv_b, uv_c],
						[a_, c_, d_,uv_a, uv_c, uv_d],
					]
			},
			"BACK":{
				"triangles":[
					[f_, b_ ,a_,uv_f, uv_b, uv_a],
					[f_, e_, b_,uv_f, uv_e, uv_b],
					[b_, e_, d_,uv_b, uv_e, uv_d],
					[d_, c_, b_,uv_d, uv_c, uv_b],
					]
			},
			"LEFT":{
				"triangles":[
						[a_, c_, b_,uv_a, uv_c, uv_b],
						[b_, c_, d_,uv_b, uv_c, uv_d],
					]
			},
			"RIGHT":{
				"triangles":[
						[a_, b_, f_,uv_a, uv_b, uv_f],
						[a_, f_, e_,uv_a, uv_f, uv_e],
						[a_, e_, d_,uv_a, uv_e, uv_d],
						[a_, d_, c_,uv_a, uv_d, uv_c],
						]
			},
			"TOP":{
				"triangles":[
						[a_, c_, d_,uv_a, uv_c, uv_d],
						[a_, d_, h_,uv_a, uv_d, uv_h],
						[h_, b_, a_,uv_h, uv_b, uv_a],
						[d_, e_, h_,uv_d, uv_e, uv_h],
						[e_, g_, h_,uv_e, uv_g, uv_h],
						[f_, g_, e_,uv_f, uv_g, uv_e],
					]
				}},
		"fillcube5":{
			"BOTTOM":{
				"triangles":[
					[a_, c_, b_,uv_a, uv_c, uv_b],
					[b_, c_, d_,uv_b, uv_c, uv_d],
				]
			},
			"FRONT":{
				"triangles":[
						[f_, b_, a_,uv_f, uv_b, uv_a],
						[e_, b_, f_,uv_e, uv_b, uv_f],
						[d_, b_, e_,uv_d, uv_b, uv_e],
						[c_, b_, d_,uv_c, uv_b, uv_d],
						[e_,f_,g_,uv_e, uv_f, uv_g],
						[i_,g_,f_,uv_i, uv_g, uv_f],
						[d_,e_,h_,uv_d, uv_e, uv_h],
						[e_,g_,h_,uv_e, uv_g, uv_h],
						[j_,h_,g_,uv_j, uv_h, uv_g],
						[g_,i_,j_,uv_g, uv_i, uv_j],
					]
			},
			"BACK":{
				"triangles":[
					[b_, d_, a_,uv_b, uv_d, uv_a],
					[b_, c_, d_,uv_b, uv_c, uv_d],
					]
			},
			"LEFT":{
				"triangles":[
						[a_, b_, f_,uv_a, uv_b, uv_f],
						[a_,f_,e_,uv_a, uv_f, uv_e],
						[a_,e_,d_,uv_a, uv_e, uv_d],
						[a_,d_,c_,uv_a, uv_d, uv_c],
					]
			},
			"RIGHT":{
				"triangles":[
						[c_, b_, a_,uv_c, uv_b, uv_a],
						[b_, c_, d_,uv_b, uv_c, uv_d],
						]
			},
			"TOP":{
				"triangles":[
						[c_,d_,a_,uv_c, uv_d, uv_a],
						[a_,d_,e_,uv_a, uv_d, uv_e],
						[a_,e_,f_,uv_a, uv_e, uv_f],
						[f_,b_,a_,uv_f, uv_b, uv_a],
					]
				}},
		"fillcube6":{
			"BOTTOM":{
				"triangles":[
					[b_, c_, a_,uv_b, uv_c, uv_a],
					[d_, c_, b_,uv_d, uv_c, uv_b],
					]
			},
			"FRONT":{
				"triangles":[
						[a_, b_, f_,uv_a, uv_b, uv_f],
						[f_, b_, e_,uv_f, uv_b, uv_e],
						[e_, b_, d_,uv_e, uv_b, uv_d],
						[d_, b_, c_,uv_d, uv_b, uv_c],
						[g_,f_,e_,uv_g, uv_f, uv_e],
						[f_,g_,i_,uv_f, uv_g, uv_i],
						[h_,e_,d_,uv_h, uv_e, uv_d],
						[h_,g_,e_,uv_h, uv_g, uv_e],
						[g_,h_,j_,uv_g, uv_h, uv_j],
						[j_,i_,g_,uv_j, uv_i, uv_g],
					]
			},
			"BACK":{
				"triangles":[
					[a_, d_, b_,uv_a, uv_d, uv_b],
					[d_, c_, b_,uv_d, uv_c, uv_b],
					]
			},
			"LEFT":{
				"triangles":[
						[a_, b_, c_,uv_a, uv_b, uv_c],
						[d_, c_, b_,uv_d, uv_c, uv_b],
					]
			},
			"RIGHT":{
				"triangles":[
						[f_, b_, a_,uv_f, uv_b, uv_a],
						[e_,f_,a_,uv_e, uv_f, uv_a],
						[d_,e_,a_,uv_d, uv_e, uv_a],
						[c_,d_,a_,uv_c, uv_d, uv_a],
						]
			},
			"TOP":{
				"triangles":[
						[a_,d_,c_,uv_a, uv_d, uv_c],
						[e_,d_,a_,uv_e, uv_d, uv_a],
						[f_,e_,a_,uv_f, uv_e, uv_a],
						[a_,b_,f_,uv_a, uv_b, uv_f],
					]
				}},
		"fillcube7":{
			"BOTTOM":{
				"triangles":[
					[a_, c_, b_,uv_a, uv_c, uv_b],
					[b_, c_, d_,uv_b, uv_c, uv_d],
					]
			},
			"FRONT":{
				"triangles":[
						[b_, d_, a_,uv_b, uv_d, uv_a],
						[b_, c_, d_,uv_b, uv_c, uv_d],
					]
			},
			"BACK":{
				"triangles":[
					[f_, b_, a_,uv_f, uv_b, uv_a],
					[e_, b_, f_,uv_e, uv_b, uv_f],
					[d_, b_, e_,uv_d, uv_b, uv_e],
					[c_, b_, d_,uv_c, uv_b, uv_d],
					[e_,f_,g_,uv_e, uv_f, uv_g],
					[i_,g_,f_,uv_i, uv_g, uv_f],
					[d_,e_,h_,uv_d, uv_e, uv_h],
					[e_,g_,h_,uv_e, uv_g, uv_h],
					[j_,h_,g_,uv_j, uv_h, uv_g],
					[g_,i_,j_,uv_g, uv_i, uv_j],
					]
			},
			"LEFT":{
				"triangles":[
						[c_, b_, a_,uv_c, uv_b, uv_a],
						[b_, c_, d_,uv_b, uv_c, uv_d],
					]
			},
			"RIGHT":{
				"triangles":[
						[a_, b_, f_,uv_a, uv_b, uv_f],
						[a_,f_,e_,uv_a, uv_f, uv_e],
						[a_,e_,d_,uv_a, uv_e, uv_d],
						[a_,d_,c_,uv_a, uv_d, uv_c],
						]
			},
			"TOP":{
				"triangles":[
						[c_,d_,a_,uv_c, uv_d, uv_a],
						[a_,d_,e_,uv_a, uv_d, uv_e],
						[a_,e_,f_,uv_a, uv_e, uv_f],
						[f_,b_,a_,uv_f, uv_b, uv_a],
					]
				}},
		"fillcube8":{
			"BOTTOM":{
				"triangles":[
					[b_, c_, a_,uv_b, uv_c, uv_a],
					[d_, c_, b_,uv_d, uv_c, uv_b],
					]
			},
			"FRONT":{
				"triangles":[
						[a_, d_, b_,uv_a, uv_d, uv_b],
						[d_, c_, b_,uv_d, uv_c, uv_b],
					]
			},
			"BACK":{
				"triangles":[
					[a_, b_, f_,uv_a, uv_b, uv_f],
					[f_, b_, e_,uv_f, uv_b, uv_e],
					[e_, b_, d_,uv_e, uv_b, uv_d],
					[d_, b_, c_,uv_d, uv_b, uv_c],
					[g_,f_,e_,uv_g, uv_f, uv_e],
					[f_,g_,i_,uv_f, uv_g, uv_i],
					[h_,e_,d_,uv_h, uv_e, uv_d],
					[h_,g_,e_,uv_h, uv_g, uv_e],
					[g_,h_,j_,uv_g, uv_h, uv_j],
					[j_,i_,g_,uv_j, uv_i, uv_g],
					]
			},
			"LEFT":{
				"triangles":[
						[f_, b_, a_,uv_f, uv_b, uv_a],
						[e_,f_,a_,uv_e, uv_f, uv_a],
						[d_,e_,a_,uv_d, uv_e, uv_a],
						[c_,d_,a_,uv_c, uv_d, uv_a],
					]
			},
			"RIGHT":{
				"triangles":[
						[a_, b_, c_,uv_a, uv_b, uv_c],
						[d_, c_, b_,uv_d, uv_c, uv_b],
						]
			},
			"TOP":{
				"triangles":[
						[a_,d_,c_,uv_a, uv_d, uv_c],
						[e_,d_,a_,uv_e, uv_d, uv_a],
						[f_,e_,a_,uv_f, uv_e, uv_a],
						[a_,b_,f_,uv_a, uv_b, uv_f],
					]
				}},
		"default":{
			"BOTTOM":{
				"triangles":[
					[c_, b_, a_,uv_c, uv_b, uv_a],
					[b_, c_, d_,uv_b, uv_c, uv_d]
					]
			},
			"FRONT":{
				"triangles":[
					[c_, b_, a_,uv_c, uv_b, uv_a],
					[b_, c_, d_,uv_b, uv_c, uv_d]
					]
			},
			"BACK":{
				"triangles":[
					[a_, b_, c_,uv_a, uv_b, uv_c],
					[d_, c_, b_,uv_d, uv_c, uv_b]
					]
			},
			"LEFT":{
				"triangles":[
					[a_, b_, c_,uv_a, uv_b, uv_c],
					[d_, c_, b_,uv_d, uv_c, uv_b]
					]
			},
			"RIGHT":{
				"triangles":[
					[c_, b_, a_,uv_c, uv_b, uv_a],
					[b_, c_, d_,uv_b, uv_c, uv_d]
					]
			},
			"TOP":{
				"triangles":[
					[a_, b_, c_,uv_a, uv_b, uv_c],
					[d_, c_, b_,uv_d, uv_c, uv_b]
					]
				}},
		}
	
	var tri_amount =  triangles[cubenr][type]["triangles"].size(); 

	for i in range(0, tri_amount):
			var uv_array = triangles[cubenr][type]["triangles"][i]
			st.add_triangle_fan([uv_array[0],uv_array[1], uv_array[2]], [uv_array[3], uv_array[4], uv_array[5]])
			


func create_grass1(a1p, a2p, ox, oy, oz, plant_number, g_, e,i,x, y, z,texture_atlas_offset): 
		rng.randomize(); 
		var number = rng.randf_range(1.1, 1.3)
		var rand_scale_top = Vector3(number, number, number)
		var rand_scale_bottom = Vector3(number, 1, number)
		
		var uv_offset = texture_atlas_offset / Global.GRASS_TEXTURE_ATLAS_SIZE
		var height = 1.0 / Global.GRASS_TEXTURE_ATLAS_SIZE.y 
		var width = 1.0 / Global.GRASS_TEXTURE_ATLAS_SIZE.x
	
		var k = float(plant_number+2)
		var l = float(plant_number) 
		
		var offset = Vector3(x, y, z)
		
		var x_offset = ox
		var z_offset = oz
		var y_offset = oy
		
		var area2 = (a2p/k)*e 
		var area1 = (a1p/l)*i 
		
				
		var a = rand_scale_bottom * grass_vertices[g_[0]] + Vector3(area1+x_offset ,y_offset ,area2+z_offset) +offset
		var b =  rand_scale_bottom * grass_vertices[g_[1]] +Vector3(area1+x_offset ,y_offset,area2+z_offset) + offset 
		var c =  rand_scale_top * grass_vertices[g_[2]] +Vector3(area1 + x_offset,y_offset,area2+z_offset)+ offset
		var d =  rand_scale_top * grass_vertices[g_[3]] +Vector3(area1+x_offset ,y_offset,area2+z_offset)+ offset
		var e_ =  rand_scale_bottom * grass_vertices[g_[4]] +Vector3(area1+x_offset ,y_offset,area2+z_offset)+ offset
		var f =  rand_scale_top * grass_vertices[g_[5]] +Vector3(area1+x_offset ,y_offset,area2+z_offset)+ offset
		var g =  rand_scale_bottom * grass_vertices[g_[6]] +Vector3(area1+x_offset ,y_offset,area2+z_offset)+ offset
		var h =  rand_scale_top * grass_vertices[g_[7]] +Vector3(area1+x_offset ,y_offset,area2+z_offset)+ offset
		var i_ =  rand_scale_bottom * grass_vertices[g_[8]] +Vector3(area1+x_offset ,y_offset,area2+z_offset)+ offset
		var j =  rand_scale_top * grass_vertices[g_[9]] +Vector3(area1+x_offset ,y_offset,area2+z_offset)+ offset
		var k_ =  rand_scale_bottom * grass_vertices[g_[10]] +Vector3(area1+x_offset ,y_offset,area2+z_offset)+ offset
		var l_ =  rand_scale_top * grass_vertices[g_[11]] +Vector3(area1+x_offset ,y_offset,area2+z_offset)+ offset
		var m =  rand_scale_bottom * grass_vertices[g_[12]] +Vector3(area1+x_offset ,y_offset,area2+z_offset)+ offset
		var n =  rand_scale_top * grass_vertices[g_[13]] +Vector3(area1+x_offset ,y_offset,area2+z_offset)+ offset
		var o =  rand_scale_bottom * grass_vertices[g_[14]] +Vector3(area1+x_offset ,y_offset,area2+z_offset)+ offset
		var p =  rand_scale_top * grass_vertices[g_[15]] +Vector3(area1+x_offset ,y_offset, area2+z_offset)+ offset
		
		var uv_a = uv_offset + Vector2(0,0)
		var uv_b = uv_offset + Vector2(-width, 0)
		var uv_c = uv_offset + Vector2(0, -height)
		var uv_d = uv_offset + Vector2(-width, -height)
		var uv_e = uv_offset + Vector2(0,0)
		var uv_f = uv_offset + Vector2(0,-height)
		var uv_g = uv_offset + Vector2(-width,0)
		var uv_h = uv_offset + Vector2(-width, -height)
		var uv_i = uv_offset + Vector2(0,0)
		var uv_j = uv_offset + Vector2(0,-height)
		var uv_k = uv_offset + Vector2(-width,0)
		var uv_l = uv_offset + Vector2(-width, -height)
		var uv_m = uv_offset + Vector2(0,0)
		var uv_n = uv_offset + Vector2(0,-height)
		var uv_o = uv_offset + Vector2(-width,0)
		var uv_p = uv_offset + Vector2(-width, -height)
		
		
		gst.add_triangle_fan(([a, b, c]), ([uv_a, uv_b, uv_c]))
		gst.add_triangle_fan(([c, b, a]), ([uv_c, uv_b, uv_a]))
		gst.add_triangle_fan(([c, b, d]), ([uv_c, uv_b, uv_d]))
		gst.add_triangle_fan(([d, b, c]), ([uv_d, uv_b, uv_c]))
		
		gst.add_triangle_fan(([e_, f, g]), ([uv_e, uv_f, uv_g]))
		gst.add_triangle_fan(([g, f, e_]), ([uv_g, uv_f, uv_e]))
		gst.add_triangle_fan(([f, g, h]), ([uv_f, uv_g, uv_h]))
		gst.add_triangle_fan(([h, g, f]), ([uv_h, uv_g, uv_f]))
		
		gst.add_triangle_fan(([i_, j,k_]), ([uv_i, uv_j, uv_k]))
		gst.add_triangle_fan(([k_, j,i_]), ([uv_k, uv_j, uv_i]))
		gst.add_triangle_fan(([j, k_,l_]), ([uv_j, uv_k, uv_l]))
		gst.add_triangle_fan(([l_, k_,j]), ([uv_l, uv_k, uv_j]))
		
		gst.add_triangle_fan(([m, n, o]), ([uv_m, uv_n, uv_o]))
		gst.add_triangle_fan(([o, n, m]), ([uv_o, uv_n, uv_m]))
		gst.add_triangle_fan(([n, o, p]), ([uv_n, uv_o, uv_p]))
		gst.add_triangle_fan(([p, o, n]), ([uv_p, uv_o, uv_n]))
		
func create_grass2(a1p, a2p, ox, oy, oz, plant_number, g_, e,i,x, y, z,texture_atlas_offset):
		rng.randomize(); 
		var number = rng.randf_range(1.1, 1.3)
		var rand_scale_top = Vector3(number, number, number)
		var rand_scale_bottom = Vector3(number, 1, number)
		
		var uv_offset = texture_atlas_offset / Global.GRASS_TEXTURE_ATLAS_SIZE
		var height = 1.0 / Global.GRASS_TEXTURE_ATLAS_SIZE.y 
		var width = 1.0 / Global.GRASS_TEXTURE_ATLAS_SIZE.x
	
		var k = float(plant_number+2)
		var l = float(plant_number) 
		
		var offset = Vector3(x, y, z)
		
		var x_offset = ox
		var z_offset = oz
		var y_offset = oy
		
		var area2 = (a2p/k)*e 
		var area1 = (a1p/l)*i 
		
				
		var a = rand_scale_bottom * grass_vertices2[g_[0]] + Vector3(area1+x_offset ,y_offset ,area2+z_offset) +offset
		var b =  rand_scale_bottom * grass_vertices2[g_[1]] +Vector3(area1+x_offset ,y_offset,area2+z_offset) + offset 
		var c =  rand_scale_top * grass_vertices2[g_[2]] +Vector3(area1 + x_offset,y_offset,area2+z_offset)+ offset
		var d =  rand_scale_top * grass_vertices2[g_[3]] +Vector3(area1+x_offset ,y_offset,area2+z_offset)+ offset
		var e_ =  rand_scale_bottom * grass_vertices2[g_[4]] +Vector3(area1+x_offset ,y_offset,area2+z_offset)+ offset
		var f =  rand_scale_top * grass_vertices2[g_[5]] +Vector3(area1+x_offset ,y_offset,area2+z_offset)+ offset
		var g =  rand_scale_bottom * grass_vertices2[g_[6]] +Vector3(area1+x_offset ,y_offset,area2+z_offset)+ offset
		var h =  rand_scale_top * grass_vertices2[g_[7]] +Vector3(area1+x_offset ,y_offset,area2+z_offset)+ offset
		var i_ =  rand_scale_bottom * grass_vertices2[g_[8]] +Vector3(area1+x_offset ,y_offset,area2+z_offset)+ offset
		var j =  rand_scale_top * grass_vertices2[g_[9]] +Vector3(area1+x_offset ,y_offset,area2+z_offset)+ offset
		var k_ =  rand_scale_bottom * grass_vertices2[g_[10]] +Vector3(area1+x_offset ,y_offset,area2+z_offset)+ offset
		var l_ =  rand_scale_top * grass_vertices2[g_[11]] +Vector3(area1+x_offset ,y_offset,area2+z_offset)+ offset
		var m =  rand_scale_bottom * grass_vertices2[g_[12]] +Vector3(area1+x_offset ,y_offset,area2+z_offset)+ offset
		var n =  rand_scale_top * grass_vertices2[g_[13]] +Vector3(area1+x_offset ,y_offset,area2+z_offset)+ offset
		var o =  rand_scale_bottom * grass_vertices2[g_[14]] +Vector3(area1+x_offset ,y_offset,area2+z_offset)+ offset
		var p =  rand_scale_top * grass_vertices2[g_[15]] +Vector3(area1+x_offset ,y_offset,area2+z_offset)+ offset
		
		var uv_a = uv_offset + Vector2(0,0)
		var uv_b = uv_offset + Vector2(-width, 0)
		var uv_c = uv_offset + Vector2(0, -height)
		var uv_d = uv_offset + Vector2(-width, -height)
		var uv_e = uv_offset + Vector2(0,0)
		var uv_f = uv_offset + Vector2(0,-height)
		var uv_g = uv_offset + Vector2(-width,0)
		var uv_h = uv_offset + Vector2(-width, -height)
		var uv_i = uv_offset + Vector2(0,0)
		var uv_j = uv_offset + Vector2(0,-height)
		var uv_k = uv_offset + Vector2(-width,0)
		var uv_l = uv_offset + Vector2(-width, -height)
		var uv_m = uv_offset + Vector2(0,0)
		var uv_n = uv_offset + Vector2(0,-height)
		var uv_o = uv_offset + Vector2(-width,0)
		var uv_p = uv_offset + Vector2(-width, -height)
		
		
		gst.add_triangle_fan(([a, b, c]), ([uv_a, uv_b, uv_c]))
		gst.add_triangle_fan(([c, b, a]), ([uv_c, uv_b, uv_a]))
		gst.add_triangle_fan(([c, b, d]), ([uv_c, uv_b, uv_d]))
		gst.add_triangle_fan(([d, b, c]), ([uv_d, uv_b, uv_c]))
		
		gst.add_triangle_fan(([e_, f, g]), ([uv_e, uv_f, uv_g]))
		gst.add_triangle_fan(([g, f, e_]), ([uv_g, uv_f, uv_e]))
		gst.add_triangle_fan(([f, g, h]), ([uv_f, uv_g, uv_h]))
		gst.add_triangle_fan(([h, g, f]), ([uv_h, uv_g, uv_f]))
		
		gst.add_triangle_fan(([i_, j,k_]), ([uv_i, uv_j, uv_k]))
		gst.add_triangle_fan(([k_, j,i_]), ([uv_k, uv_j, uv_i]))
		gst.add_triangle_fan(([j, k_,l_]), ([uv_j, uv_k, uv_l]))
		gst.add_triangle_fan(([l_, k_,j]), ([uv_l, uv_k, uv_j]))
		
		gst.add_triangle_fan(([m, n, o]), ([uv_m, uv_n, uv_o]))
		gst.add_triangle_fan(([o, n, m]), ([uv_o, uv_n, uv_m]))
		gst.add_triangle_fan(([n, o, p]), ([uv_n, uv_o, uv_p]))
		gst.add_triangle_fan(([p, o, n]), ([uv_p, uv_o, uv_n]))
		
func create_fill_grass(ox, oy, oz, g_,x, y, z,texture_atlas_offset):
	var uv_offset = texture_atlas_offset / Global.GRASS_TEXTURE_ATLAS_SIZE
	var height = 1.0 / Global.GRASS_TEXTURE_ATLAS_SIZE.y 
	var width = 1.0 / Global.GRASS_TEXTURE_ATLAS_SIZE.x

	var offset = Vector3(x, y, z)
	
	var x_offset = ox
	var z_offset = oz
	var y_offset = oy
	
			
	var a = grass_vertices2[g_[0]] + Vector3(x_offset ,y_offset ,z_offset) +offset
	var b =  grass_vertices2[g_[1]] +Vector3(x_offset ,y_offset,z_offset) + offset 
	var c =  grass_vertices2[g_[2]] +Vector3(x_offset,y_offset,z_offset)+ offset
	var d =  grass_vertices2[g_[3]] +Vector3(x_offset ,y_offset,z_offset)+ offset
	var e_ = grass_vertices2[g_[4]] +Vector3(x_offset ,y_offset,z_offset)+ offset
	var f =  grass_vertices2[g_[5]] +Vector3(x_offset ,y_offset,z_offset)+ offset
	var g =  grass_vertices2[g_[6]] +Vector3(x_offset ,y_offset,z_offset)+ offset
	var h =  grass_vertices2[g_[7]] +Vector3(x_offset ,y_offset,z_offset)+ offset
	var i_ = grass_vertices2[g_[8]] +Vector3(x_offset ,y_offset,z_offset)+ offset
	var j =  grass_vertices2[g_[9]] +Vector3(x_offset ,y_offset,z_offset)+ offset
	var k_ =  grass_vertices2[g_[10]] +Vector3(x_offset ,y_offset,z_offset)+ offset
	var l_ =  grass_vertices2[g_[11]] +Vector3(x_offset ,y_offset,z_offset)+ offset
	var m =  grass_vertices2[g_[12]] +Vector3(x_offset ,y_offset,z_offset)+ offset
	var n =  grass_vertices2[g_[13]] +Vector3(x_offset ,y_offset,z_offset)+ offset
	var o =  grass_vertices2[g_[14]] +Vector3(x_offset ,y_offset,z_offset)+ offset
	var p =  grass_vertices2[g_[15]] +Vector3(x_offset ,y_offset,z_offset)+ offset
	
	var uv_a = uv_offset + Vector2(0,0)
	var uv_b = uv_offset + Vector2(-width, 0)
	var uv_c = uv_offset + Vector2(0, -height)
	var uv_d = uv_offset + Vector2(-width, -height)
	var uv_e = uv_offset + Vector2(0,0)
	var uv_f = uv_offset + Vector2(0,-height)
	var uv_g = uv_offset + Vector2(-width,0)
	var uv_h = uv_offset + Vector2(-width, -height)
	var uv_i = uv_offset + Vector2(0,0)
	var uv_j = uv_offset + Vector2(0,-height)
	var uv_k = uv_offset + Vector2(-width,0)
	var uv_l = uv_offset + Vector2(-width, -height)
	var uv_m = uv_offset + Vector2(0,0)
	var uv_n = uv_offset + Vector2(0,-height)
	var uv_o = uv_offset + Vector2(-width,0)
	var uv_p = uv_offset + Vector2(-width, -height)
	
	
	gst.add_triangle_fan(([a, b, c]), ([uv_a, uv_b, uv_c]))
	gst.add_triangle_fan(([c, b, a]), ([uv_c, uv_b, uv_a]))
	gst.add_triangle_fan(([c, b, d]), ([uv_c, uv_b, uv_d]))
	gst.add_triangle_fan(([d, b, c]), ([uv_d, uv_b, uv_c]))
	
	gst.add_triangle_fan(([e_, f, g]), ([uv_e, uv_f, uv_g]))
	gst.add_triangle_fan(([g, f, e_]), ([uv_g, uv_f, uv_e]))
	gst.add_triangle_fan(([f, g, h]), ([uv_f, uv_g, uv_h]))
	gst.add_triangle_fan(([h, g, f]), ([uv_h, uv_g, uv_f]))
	
	gst.add_triangle_fan(([i_, j,k_]), ([uv_i, uv_j, uv_k]))
	gst.add_triangle_fan(([k_, j,i_]), ([uv_k, uv_j, uv_i]))
	gst.add_triangle_fan(([j, k_,l_]), ([uv_j, uv_k, uv_l]))
	gst.add_triangle_fan(([l_, k_,j]), ([uv_l, uv_k, uv_j]))
	
	gst.add_triangle_fan(([m, n, o]), ([uv_m, uv_n, uv_o]))
	gst.add_triangle_fan(([o, n, m]), ([uv_o, uv_n, uv_m]))
	gst.add_triangle_fan(([n, o, p]), ([uv_n, uv_o, uv_p]))
	gst.add_triangle_fan(([p, o, n]), ([uv_p, uv_o, uv_n]))
	
func create_fill_grass2(ox, oy, oz, g_,x, y, z,texture_atlas_offset):
	var uv_offset = texture_atlas_offset / Global.GRASS_TEXTURE_ATLAS_SIZE
	var height = 1.0 / Global.GRASS_TEXTURE_ATLAS_SIZE.y 
	var width = 1.0 / Global.GRASS_TEXTURE_ATLAS_SIZE.x

	var offset = Vector3(x, y, z)
	
	var x_offset = ox
	var z_offset = oz
	var y_offset = oy
	
			
	var a = grass_vertices3[g_[0]] + Vector3(x_offset ,y_offset ,z_offset) +offset
	var b =  grass_vertices3[g_[1]] +Vector3(x_offset ,y_offset,z_offset) + offset 
	var c =  grass_vertices3[g_[2]] +Vector3(x_offset,y_offset,z_offset)+ offset
	var d =  grass_vertices3[g_[3]] +Vector3(x_offset ,y_offset,z_offset)+ offset
	var e_ = grass_vertices3[g_[4]] +Vector3(x_offset ,y_offset,z_offset)+ offset
	var f =  grass_vertices3[g_[5]] +Vector3(x_offset ,y_offset,z_offset)+ offset
	var g =  grass_vertices3[g_[6]] +Vector3(x_offset ,y_offset,z_offset)+ offset
	var h =  grass_vertices3[g_[7]] +Vector3(x_offset ,y_offset,z_offset)+ offset
	var i_ = grass_vertices3[g_[8]] +Vector3(x_offset ,y_offset,z_offset)+ offset
	var j =  grass_vertices3[g_[9]] +Vector3(x_offset ,y_offset,z_offset)+ offset
	var k_ =  grass_vertices3[g_[10]] +Vector3(x_offset ,y_offset,z_offset)+ offset
	var l_ =  grass_vertices3[g_[11]] +Vector3(x_offset ,y_offset,z_offset)+ offset
	var m =  grass_vertices3[g_[12]] +Vector3(x_offset ,y_offset,z_offset)+ offset
	var n =  grass_vertices3[g_[13]] +Vector3(x_offset ,y_offset,z_offset)+ offset
	var o =  grass_vertices3[g_[14]] +Vector3(x_offset ,y_offset,z_offset)+ offset
	var p =  grass_vertices3[g_[15]] +Vector3(x_offset ,y_offset,z_offset)+ offset
	
	var uv_a = uv_offset + Vector2(0,0)
	var uv_b = uv_offset + Vector2(-width, 0)
	var uv_c = uv_offset + Vector2(0, -height)
	var uv_d = uv_offset + Vector2(-width, -height)
	var uv_e = uv_offset + Vector2(0,0)
	var uv_f = uv_offset + Vector2(0,-height)
	var uv_g = uv_offset + Vector2(-width,0)
	var uv_h = uv_offset + Vector2(-width, -height)
	var uv_i = uv_offset + Vector2(0,0)
	var uv_j = uv_offset + Vector2(0,-height)
	var uv_k = uv_offset + Vector2(-width,0)
	var uv_l = uv_offset + Vector2(-width, -height)
	var uv_m = uv_offset + Vector2(0,0)
	var uv_n = uv_offset + Vector2(0,-height)
	var uv_o = uv_offset + Vector2(-width,0)
	var uv_p = uv_offset + Vector2(-width, -height)
	
	
	gst.add_triangle_fan(([a, b, c]), ([uv_a, uv_b, uv_c]))
	gst.add_triangle_fan(([c, b, a]), ([uv_c, uv_b, uv_a]))
	gst.add_triangle_fan(([c, b, d]), ([uv_c, uv_b, uv_d]))
	gst.add_triangle_fan(([d, b, c]), ([uv_d, uv_b, uv_c]))
	
	gst.add_triangle_fan(([e_, f, g]), ([uv_e, uv_f, uv_g]))
	gst.add_triangle_fan(([g, f, e_]), ([uv_g, uv_f, uv_e]))
	gst.add_triangle_fan(([f, g, h]), ([uv_f, uv_g, uv_h]))
	gst.add_triangle_fan(([h, g, f]), ([uv_h, uv_g, uv_f]))
	
	gst.add_triangle_fan(([i_, j,k_]), ([uv_i, uv_j, uv_k]))
	gst.add_triangle_fan(([k_, j,i_]), ([uv_k, uv_j, uv_i]))
	gst.add_triangle_fan(([j, k_,l_]), ([uv_j, uv_k, uv_l]))
	gst.add_triangle_fan(([l_, k_,j]), ([uv_l, uv_k, uv_j]))
	
	gst.add_triangle_fan(([m, n, o]), ([uv_m, uv_n, uv_o]))
	gst.add_triangle_fan(([o, n, m]), ([uv_o, uv_n, uv_m]))
	gst.add_triangle_fan(([n, o, p]), ([uv_n, uv_o, uv_p]))
	gst.add_triangle_fan(([p, o, n]), ([uv_p, uv_o, uv_n]))
		
func create_grass3(a1p, a2p, ox, oy, oz, plant_number, g_, e,i,x, y, z,texture_atlas_offset):
		rng.randomize(); 
		var number = rng.randf_range(1.1, 1.3)
		var rand_scale_top = Vector3(number, number, number)
		var rand_scale_bottom = Vector3(number, 1, number)
		
		var uv_offset = texture_atlas_offset / Global.GRASS_TEXTURE_ATLAS_SIZE
		var height = 1.0 / Global.GRASS_TEXTURE_ATLAS_SIZE.y 
		var width = 1.0 / Global.GRASS_TEXTURE_ATLAS_SIZE.x
	
		var k = float(plant_number+2)
		var l = float(plant_number) 
		
		var offset = Vector3(x, y, z)
		
		var x_offset = ox
		var z_offset = oz
		var y_offset = oy
		
		var area2 = (a2p/k)*e 
		var area1 = (a1p/l)*i 
		
				
		var a = rand_scale_bottom * grass_vertices3[g_[0]] + Vector3(area1+x_offset ,y_offset ,area2+z_offset) +offset
		var b =  rand_scale_bottom * grass_vertices3[g_[1]] +Vector3(area1+x_offset ,y_offset,area2+z_offset) + offset 
		var c =  rand_scale_top * grass_vertices3[g_[2]] +Vector3(area1 + x_offset,y_offset,area2+z_offset)+ offset
		var d =  rand_scale_top * grass_vertices3[g_[3]] +Vector3(area1+x_offset ,y_offset,area2+z_offset)+ offset
		var e_ =  rand_scale_bottom * grass_vertices3[g_[4]] +Vector3(area1+x_offset ,y_offset,area2+z_offset)+ offset
		var f =  rand_scale_top * grass_vertices3[g_[5]] +Vector3(area1+x_offset ,y_offset,area2+z_offset)+ offset
		var g =  rand_scale_bottom * grass_vertices3[g_[6]] +Vector3(area1+x_offset ,y_offset,area2+z_offset)+ offset
		var h =  rand_scale_top * grass_vertices3[g_[7]] +Vector3(area1+x_offset ,y_offset,area2+z_offset)+ offset
		var i_ =  rand_scale_bottom * grass_vertices3[g_[8]] +Vector3(area1+x_offset ,y_offset,area2+z_offset)+ offset
		var j =  rand_scale_top * grass_vertices3[g_[9]] +Vector3(area1+x_offset ,y_offset,area2+z_offset)+ offset
		var k_ =  rand_scale_bottom * grass_vertices3[g_[10]] +Vector3(area1+x_offset ,y_offset,area2+z_offset)+ offset
		var l_ =  rand_scale_top * grass_vertices3[g_[11]] +Vector3(area1+x_offset ,y_offset,area2+z_offset)+ offset
		var m =  rand_scale_bottom * grass_vertices3[g_[12]] +Vector3(area1+x_offset ,y_offset,area2+z_offset)+ offset
		var n =  rand_scale_top * grass_vertices3[g_[13]] +Vector3(area1+x_offset ,y_offset,area2+z_offset)+ offset
		var o =  rand_scale_bottom * grass_vertices3[g_[14]] +Vector3(area1+x_offset ,y_offset,area2+z_offset)+ offset
		var p =  rand_scale_top * grass_vertices3[g_[15]] +Vector3(area1+x_offset ,y_offset,area2+z_offset)+ offset
		
		var uv_a = uv_offset + Vector2(0,0)
		var uv_b = uv_offset + Vector2(-width, 0)
		var uv_c = uv_offset + Vector2(0, -height)
		var uv_d = uv_offset + Vector2(-width, -height)
		var uv_e = uv_offset + Vector2(0,0)
		var uv_f = uv_offset + Vector2(0,-height)
		var uv_g = uv_offset + Vector2(-width,0)
		var uv_h = uv_offset + Vector2(-width, -height)
		var uv_i = uv_offset + Vector2(0,0)
		var uv_j = uv_offset + Vector2(0,-height)
		var uv_k = uv_offset + Vector2(-width,0)
		var uv_l = uv_offset + Vector2(-width, -height)
		var uv_m = uv_offset + Vector2(0,0)
		var uv_n = uv_offset + Vector2(0,-height)
		var uv_o = uv_offset + Vector2(-width,0)
		var uv_p = uv_offset + Vector2(-width, -height)
		
		
		gst.add_triangle_fan(([a, b, c]), ([uv_a, uv_b, uv_c]))
		gst.add_triangle_fan(([c, b, a]), ([uv_c, uv_b, uv_a]))
		gst.add_triangle_fan(([c, b, d]), ([uv_c, uv_b, uv_d]))
		gst.add_triangle_fan(([d, b, c]), ([uv_d, uv_b, uv_c]))
		
		gst.add_triangle_fan(([e_, f, g]), ([uv_e, uv_f, uv_g]))
		gst.add_triangle_fan(([g, f, e_]), ([uv_g, uv_f, uv_e]))
		gst.add_triangle_fan(([f, g, h]), ([uv_f, uv_g, uv_h]))
		gst.add_triangle_fan(([h, g, f]), ([uv_h, uv_g, uv_f]))
		
		gst.add_triangle_fan(([i_, j,k_]), ([uv_i, uv_j, uv_k]))
		gst.add_triangle_fan(([k_, j,i_]), ([uv_k, uv_j, uv_i]))
		gst.add_triangle_fan(([j, k_,l_]), ([uv_j, uv_k, uv_l]))
		gst.add_triangle_fan(([l_, k_,j]), ([uv_l, uv_k, uv_j]))
		
		gst.add_triangle_fan(([m, n, o]), ([uv_m, uv_n, uv_o]))
		gst.add_triangle_fan(([o, n, m]), ([uv_o, uv_n, uv_m]))
		gst.add_triangle_fan(([n, o, p]), ([uv_n, uv_o, uv_p]))
		gst.add_triangle_fan(([p, o, n]), ([uv_p, uv_o, uv_n]))
		
func set_chunk_position(pos):
	chunk_position = pos; 
	translation = Vector3(pos.x, 0, pos.y) * Global.DIMENSION; 
	
	self.visible = false; 
