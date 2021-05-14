extends GridMap

var usedCells
var cellItems = {}
var cellItemOs ={}

# Called when the node enters the scene tree for the first time.
func _ready():
	usedCells = get_used_cells()
	for i in usedCells:
		cellItems[i] = get_cell_item(i.x,i.y,i.z)
		cellItemOs[i] = get_cell_item_orientation(i.x,i.y,i.z)
	

func resetTiles():
	clear()
	for i in usedCells:
		set_cell_item(i.x,i.y,i.z,cellItems[i],cellItemOs[i])


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
