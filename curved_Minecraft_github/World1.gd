extends Spatial

var chunk_scene = preload("res://curved_cubes.tscn")

var load_radius = 15
onready var chunks = $Chunks
onready var player = $Player
onready var particles = preload("res://Particles.tscn"); 

var load_thread = Thread.new()

var blocks 

func _ready():
	for i in range(0, load_radius):
		for j in range(0, load_radius):
				var chunk = chunk_scene.instance()
				chunk.set_chunk_position(Vector2(i, j))
				chunks.add_child(chunk)
	for c in chunks.get_children():
		c.update(); 
			
	
	load_thread.start(self, "_thread_process", null)
	
	player.connect("place_block", self, "_on_Player_place_block")
	player.connect("break_block", self, "_on_Player_break_block")

func get_chunk(chunk_pos):
	for c in chunks.get_children():
		if c.chunk_position == chunk_pos:
			blocks = c.blocks; 
			return c
	return null
	
	
func _on_Player_place_block(pos, t): 
	var p = particles.instance()
#	p.translation = pos - Vector3(0, 0.3,0)
	#add_child(p); 
	#p.emitting = true; 
	#if p.emitting == false:
		#p.queue_free(); 
		
	var cx = int(floor(pos.x / Global.DIMENSION.x))
	var cz = int(floor(pos.z / Global.DIMENSION.z))
	
	var bx = posmod(floor(pos.x), Global.DIMENSION.x)
	var by = posmod(floor(pos.y), Global.DIMENSION.y)
	var bz = posmod(floor(pos.z), Global.DIMENSION.z)
	
	var c = get_chunk(Vector2(cx, cz))
	var cplusx  = get_chunk(Vector2(cx+1, cz))
	var cminusx = get_chunk(Vector2(cx-1,cz))
	var cplusxplusz = get_chunk(Vector2(cx+1, cz+1))
	var cplusxminusz = get_chunk(Vector2(cx+1, cz-1))
	var cminusxminusz = get_chunk(Vector2(cx-1, cz-1))
	var cminusxplusz = get_chunk(Vector2(cx-1, cz+1))
	var cplusz = get_chunk(Vector2(cx, cz+1))
	var cminusz = get_chunk(Vector2(cx, cz-1))

	c.blocks[bx][by][bz] = t
	
	if c != null:
		c.update()
	if cplusx != null:
		cplusx.update(); 
	if cminusx != null:
		cminusx.update(); 
	if  cplusxplusz != null:#
		 cplusxplusz.update(); 
	if cplusxminusz != null:
		cplusxminusz.update(); 
	if cminusxminusz != null:
		cminusxminusz.update(); 
	if cminusxplusz != null: 
		cminusxplusz.update(); 
	if cplusz != null:#
		cplusz.update(); 
	if cminusz != null:
		cminusz.update(); 


func _on_Player_break_block(pos):
	_on_Player_place_block(pos, Global.AIR)
