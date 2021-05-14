extends Spatial

var P
var S

const NORTH = 0
const SOUTH = 1
const EAST = 2
const WEST = 3

func _ready():
	P = get_parent()
	

func _process(delta):
		# WASD movement
	if Input.is_key_pressed(KEY_W) && !P.isMove:
		
		match P.Forward:
			NORTH:
				P.moveSouth()
			SOUTH:
				P.moveNorth()
				
			EAST:
				P.moveWest()
				
			WEST:
				P.moveEast()

				
	if Input.is_key_pressed(KEY_S) && !P.isMove:
		match P.Forward:
			NORTH:
				P.moveNorth()
			SOUTH:
				P.moveSouth()
			EAST:
				P.moveEast()
			WEST:
				P.moveWest()
		
	if Input.is_key_pressed(KEY_A) && !P.isMove:
		match P.Forward:
			NORTH:
				P.moveEast()
			SOUTH:
				P.moveWest()
			EAST:
				P.moveSouth()
			WEST:
				P.moveNorth()
				
	if Input.is_key_pressed(KEY_D) && !P.isMove:
		match P.Forward:
			NORTH:
				P.moveWest()
			SOUTH:
				P.moveEast()
			EAST:
				P.moveNorth()
			WEST:
				P.moveSouth()
				
func _input(event):
	if(event is InputEventKey && event.scancode == KEY_E && event.pressed && P.canMove):
		interact()

	if Input.is_key_pressed(KEY_Y):
		match P.SpriteLook:
				0:
					S.frame = 12
				1: 
					S.frame = 13
				2:
					S.frame = 14
				3:
					S.frame = 15
	if Input.is_key_pressed(KEY_U):
		match P.SpriteLook:
				0:
					S.frame = 16
				1: 
					S.frame = 17
				2:
					S.frame = 18
				3:
					S.frame = 19
	if Input.is_key_pressed(KEY_H):
		match P.SpriteLook:
				0:
					S.frame = 20
				1: 
					S.frame = 21
				2:
					S.frame = 22
				3:
					S.frame = 23
	if Input.is_key_pressed(KEY_J):
		match P.SpriteLook:
				0:
					S.frame = 24
				1: 
					S.frame = 25
				2:
					S.frame = 26
				3:
					S.frame = 27
	if Input.is_key_pressed(KEY_N):
		match P.SpriteLook:
				0:
					S.frame = 28
				1: 
					S.frame = 29
				2:
					S.frame = 30
				3:
					S.frame = 31
					
func interact():
	match P.Dir:
			NORTH:
				var D = CheckDialogue(P.t.origin + Vector3(1,0,0))
				if(D != null):
					D.interact()
			SOUTH:
				var D = CheckDialogue(P.t.origin + Vector3(-1,0,0))
				if(D != null):
					D.interact()
			EAST:
				var D = CheckDialogue(P.t.origin + Vector3(0,0,1))
				if(D != null):
					D.interact()
			WEST:
				var D = CheckDialogue(P.t.origin + Vector3(0,0,-1))
				if(D != null):
					D.interact()
				
func CheckDialogue(dest):
	var D = null
	var P = get_parent().get_parent()
	for i in P.get_children():
		if(i.destination == dest):
			for j in i.get_children():
				if (j.name == "Dialogue"):
					D = j
	return D
