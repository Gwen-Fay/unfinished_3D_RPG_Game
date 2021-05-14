extends Spatial

# North = +X
# South = -X
# East = +Z
# West = -Z

export var look_at = false

const NORTH = 0
const SOUTH = 1
const EAST = 2
const WEST = 3

var Cam
var t

var Dir = EAST #Which direction am I facing?
var Forward = EAST #Which direction is player looking?
var isMove = false # Am I moving?
var canMove = true #Can I move?
var destination
var moveSpeed = 3
var animPlayer
var waitFrame = 0

onready var grid = get_parent()

func _ready():
	Cam = get_viewport().get_camera().get_global_transform()
	t = get_global_transform()
	destination = t.origin
	
	if(has_node("Model/AnimationPlayer")):
		animPlayer = get_node("Model/AnimationPlayer")
		animPlayer.get_animation("IdleNorm").set_loop(true)
		animPlayer.get_animation("IdleNormL").set_loop(true)
		animPlayer.get_animation("IdleNormR").set_loop(true)
		animPlayer.get_animation("IdleNormB").set_loop(true)
		animPlayer.get_animation("walkingNorm").set_loop(true)
		animPlayer.get_animation("walkingNormL").set_loop(true)
		animPlayer.get_animation("walkingNormR").set_loop(true)
		animPlayer.get_animation("walkingNormB").set_loop(true)
		animPlayer.play("IdleNorm")

func getNorth(p):
	var n = null
	if(grid.get_cell_item(p.x+1,p.y,p.z)>-1):
		if(grid.get_cell_item(p.x+1,p.y +1,p.z) == -1):
			if(grid.get_cell_item(p.x+1,p.y +2,p.z) == -1):
				if(CheckEntity(p + Vector3(1,0,0))):
					n = p + Vector3(1,0,0)

	if(grid.get_cell_item(p.x+1,p.y+1,p.z)>-1):
		if(grid.get_cell_item(p.x+1,p.y+2,p.z) == -1):
			if(grid.get_cell_item(p.x+1,p.y +3,p.z) == -1):
				if(CheckEntity(p + Vector3(1,1,0))):
					n = p + Vector3(1,1,0)

	if(grid.get_cell_item(p.x+1,p.y-1,p.z)>-1):
		if(grid.get_cell_item(p.x+1,p.y,p.z) == -1):
			if(grid.get_cell_item(p.x+1,p.y +1,p.z) == -1):
				if(CheckEntity(p + Vector3(1,-1,0))):
					n = p + Vector3(1,-1,0)
	return n
	
func getSouth(p):
	var s = null
	if(grid.get_cell_item(p.x-1,p.y,p.z)>-1):
		if(grid.get_cell_item(p.x-1,p.y +1,p.z) == -1):
			if(grid.get_cell_item(p.x-1,p.y +2,p.z) == -1):
				if(CheckEntity(p + Vector3(-1,0,0))):
					s = p + Vector3(-1,0,0)

	if(grid.get_cell_item(p.x-1,p.y+1,p.z)>-1):
		if(grid.get_cell_item(p.x-1,p.y+2,p.z) == -1):
			if(grid.get_cell_item(p.x-1,p.y +3,p.z) == -1):
				if(CheckEntity(p + Vector3(-1,1,0))):
					s = p + Vector3(-1,1,0)

	if(grid.get_cell_item(p.x-1,p.y-1,p.z)>-1):
		if(grid.get_cell_item(p.x-1,p.y,p.z) == -1):
			if(grid.get_cell_item(p.x-1,p.y +1,p.z) == -1):
				if(CheckEntity(p + Vector3(-1,-1,0))):
					s = p + Vector3(-1,-1,0)
	return s

func getEast(p):
	var e = null
	if(grid.get_cell_item(p.x,p.y,p.z+1)>-1):
		if(grid.get_cell_item(p.x,p.y +1,p.z+1) == -1):
			if(grid.get_cell_item(p.x,p.y +2,p.z+1) == -1):
				if(CheckEntity(p + Vector3(0,0,1))):
					e = p + Vector3(0,0,1)

	if(grid.get_cell_item(p.x,p.y+1,p.z+1)>-1):
		if(grid.get_cell_item(p.x,p.y+2,p.z+1) == -1):
			if(grid.get_cell_item(p.x,p.y +3,p.z+1) == -1):
				if(CheckEntity(p + Vector3(0,1,1))):
					e = p + Vector3(0,1,1)

	if(grid.get_cell_item(p.x,p.y-1,p.z+1)>-1):
		if(grid.get_cell_item(p.x,p.y,p.z+1) == -1):
			if(grid.get_cell_item(p.x,p.y +1,p.z+1) == -1):
				if(CheckEntity(p + Vector3(0,-1,1))):
					e = p + Vector3(0,-1,1)
	return e

func getWest(p):
	var w = null
	if(grid.get_cell_item(p.x,p.y,p.z-1)>-1):
		if(grid.get_cell_item(p.x,p.y +1,p.z-1) == -1):
			if(grid.get_cell_item(p.x,p.y +2,p.z-1) == -1):
				if(CheckEntity(p + Vector3(0,0,-1))):
					w = p + Vector3(0,0,-1)

	if(grid.get_cell_item(p.x,p.y+1,p.z-1)>-1):
		if(grid.get_cell_item(p.x,p.y+2,p.z-1) == -1):
			if(grid.get_cell_item(p.x,p.y +3,p.z-1) == -1):
				if(CheckEntity(p + Vector3(0,1,-1))):
					w = p + Vector3(0,1,-1)

	if(grid.get_cell_item(p.x,p.y-1,p.z-1)>-1):
		if(grid.get_cell_item(p.x,p.y,p.z-1) == -1):
			if(grid.get_cell_item(p.x,p.y +1,p.z-1) == -1):
				if(CheckEntity(p + Vector3(0,-1,-1))):
					w = p + Vector3(0,-1,-1)
	return w

func moveNorth():
	var n
	if(canMove):
		Dir = NORTH
		n = getNorth(t.origin)
		if(n != null):
			destination = n
			isMove = true
		
	return n
				
func moveSouth():
	var s
	if(canMove):
		Dir = SOUTH
		s = getSouth(t.origin)
		if(s != null):
			destination = s
			isMove = true
	return s
				
func moveEast():
	var e
	if(canMove):
		Dir = EAST
		e = getEast(t.origin)
		if(e != null):
			destination = e
			isMove = true
	return e
				
func moveWest():
	var w
	if(canMove):
		Dir = WEST
		w = getWest(t.origin)
		if(w != null):
			destination = w
			isMove = true
	return w

				
func CheckEntity(dest):
	var open = true
	var P = get_parent()
	for i in P.get_children():
		if(i.destination == dest):
			if(i.get_node("AI")==null):
				open = false
			if(i.get_node("AI")!= null && i.get_node("AI").mode!=2):
				open = false
	return open
	
func getCircle(radius):
	var circle = []
	circle.append(destination)
	
	for i in (radius-1):
		var circle2 = circle.duplicate()
		for j in circle:
			var n = getNorth(j)
			var s = getSouth(j)
			var e = getEast(j)
			var w = getWest(j)
			
			if !circle2.has(n) && n!=null:
				circle2.append(n)
			if !circle2.has(s) && s!=null:
				circle2.append(s)
			if !circle2.has(e) && e!=null:
				circle2.append(e)
			if !circle2.has(w) && w!=null:
				circle2.append(w)
		circle = circle2
	
	return circle
	
	

func _process(delta):
	
	
	#Look at active camera
	t = get_global_transform()
	Cam = get_viewport().get_camera().get_global_transform()
	var lookPos = Vector3(Cam.origin.x, t.origin.y, Cam.origin.z)
	if(look_at == true):
		look_at(lookPos, Vector3(0,1,0))
	
	
	#Set Forward
	var vec = t.origin - lookPos
	var angle = rad2deg(atan2(vec.z,vec.x))
	match Dir:
		NORTH:
			if(angle>-45 && angle<45 ): #SOUTH
				Forward = SOUTH
			elif(angle>45 && angle<135): #WEST
				Forward = WEST
			elif(angle<-45 && angle>-135): #EAST
				Forward = EAST
			elif(angle<-135 || angle>135): #NORTH
				Forward = NORTH
		SOUTH:
			if(angle>-45 && angle<45 ): #SOUTH
				Forward = SOUTH
			elif(angle>45 && angle<135): #WEST
				Forward = WEST
			elif(angle<-45 && angle>-135): #EAST
				Forward = EAST
			elif(angle<-135 || angle>135): #NORTH
				Forward = NORTH
		EAST:
			if(angle>-45 && angle<45 ): #SOUTH
				Forward = SOUTH
			elif(angle>45 && angle<135): #WEST
				Forward = WEST
			elif(angle<-45 && angle>-135): #EAST
				Forward = EAST
			elif(angle<-135 || angle>135): #NORTH
				Forward = NORTH
		WEST:
			if(angle>-45 && angle<45 ): #SOUTH
				Forward = SOUTH
			elif(angle>45 && angle<135): #WEST
				Forward = WEST
			elif(angle<-45 && angle>-135): #EAST
				Forward = EAST
			elif(angle<-135 || angle>135): #NORTH
				Forward = NORTH
	
	#Move To Destination.
	if(isMove && canMove):
		var move = destination - t.origin
		if(move.length()< delta * moveSpeed):
			t.origin = destination
			isMove = false

		else:
			global_translate(move.normalized() * delta * moveSpeed)
			
	else:
		#reset to int position
		t.origin = Vector3(round(t.origin.x),round(t.origin.y),round(t.origin.z))
	
	#rotateDir
	match Dir:
		NORTH:
			look_at(Vector3(t.origin.x -1,t.origin.y,t.origin.z)
			,Vector3(0,1,0))
		SOUTH:
			look_at(Vector3(t.origin.x +1,t.origin.y,t.origin.z)
			,Vector3(0,1,0))
		EAST:
			look_at(Vector3(t.origin.x,t.origin.y,t.origin.z -1)
			,Vector3(0,1,0))
		WEST:
			look_at(Vector3(t.origin.x,t.origin.y,t.origin.z +1)
			,Vector3(0,1,0))
	
	#Animation
	if(animPlayer != null):
		if(isMove):
			if(!has_node("PlayerController")):
				if(animPlayer.current_animation != "walkingNorm"):
						animPlayer.play("walkingNorm",0.1,2.25,false)
			else:
				waitFrame = 0
				if((Dir == NORTH && Forward == SOUTH) || (Dir == SOUTH && Forward == NORTH)
				|| (Dir == EAST && Forward == WEST) || (Dir == WEST && Forward == EAST)):
					if(animPlayer.current_animation != "walkingNorm"):
						animPlayer.play("walkingNorm",0.1,2.25,false)
				if((Dir == NORTH && Forward == EAST) || (Dir == SOUTH && Forward == WEST)
				|| (Dir == EAST && Forward == SOUTH) || (Dir == WEST && Forward == NORTH)):
					if(animPlayer.current_animation != "walkingNorm"):
						animPlayer.play("walkingNorm",0.1,2.25,false)
				if((Dir == NORTH && Forward == WEST) || (Dir == SOUTH && Forward == EAST)
				|| (Dir == EAST && Forward == NORTH) || (Dir == WEST && Forward == SOUTH)):
					if(animPlayer.current_animation != "walkingNorm"):
						animPlayer.play("walkingNorm",0.1,2.25,false)
				if((Dir == NORTH && Forward == NORTH) || (Dir == SOUTH && Forward == SOUTH)
				|| (Dir == EAST && Forward == EAST) || (Dir == WEST && Forward == WEST)):
					if(animPlayer.current_animation != "walkingNorm"):
						animPlayer.play("walkingNorm",0.1,2.25,false)
		else:
			if (waitFrame == 1):
				if(!has_node("PlayerController")):
					if(animPlayer.current_animation != "IdleNorm"):
							animPlayer.play("IdleNorm",0.1,1,false)
				else:
					if((Dir == NORTH && Forward == SOUTH) || (Dir == SOUTH && Forward == NORTH)
					|| (Dir == EAST && Forward == WEST) || (Dir == WEST && Forward == EAST)):
						if(animPlayer.current_animation != "IdleNorm"):
							animPlayer.play("IdleNorm",0.1,1,false)
					if((Dir == NORTH && Forward == EAST) || (Dir == SOUTH && Forward == WEST)
					|| (Dir == EAST && Forward == SOUTH) || (Dir == WEST && Forward == NORTH)):
						if(animPlayer.current_animation != "IdleNormL"):
							animPlayer.play("IdleNormL",0.1,1,false)
					if((Dir == NORTH && Forward == WEST) || (Dir == SOUTH && Forward == EAST)
					|| (Dir == EAST && Forward == NORTH) || (Dir == WEST && Forward == SOUTH)):
						if(animPlayer.current_animation != "IdleNormR"):
							animPlayer.play("IdleNormR",0.1,1,false)
					if((Dir == NORTH && Forward == NORTH) || (Dir == SOUTH && Forward == SOUTH)
					|| (Dir == EAST && Forward == EAST) || (Dir == WEST && Forward == WEST)):
						if(animPlayer.current_animation != "IdleNorm"):
							animPlayer.play("IdleNorm",0.1,1,false)
			else:
				waitFrame += 1
				
