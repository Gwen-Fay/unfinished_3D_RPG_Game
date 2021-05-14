extends Spatial

const NONE = 0
const WANDER = 1
const FOLLOW = 2

var wanderRadius = 10
var followRadius = 3
export(NodePath) var followingPath
var following
var P
var isready = false
var circle
var rng
var path = []
var isPath = false
export(int, "none, wander, follow") var mode
#AI modes


func _ready():
	P = get_parent()
	rng = RandomNumberGenerator.new()
	rng.randomize()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isPath && P.canMove:
			if(path.front() == P.destination)&&(!P.isMove)&&len(path)>=2:
				if((path[0]-path[1]).x ==-1):
					if(P.moveNorth()!=null):
						path.pop_front()
					else:
						if(P.moveEast()==null):
							P.moveWest()
						aStarPath(path.back())
				elif((path[0]-path[1]).x ==1):
					if(P.moveSouth()!=null):
						path.pop_front()
					else:
						if(P.moveEast()==null):
							P.moveWest()
						aStarPath(path.back())
				elif((path[0]-path[1]).z ==-1):
					if(P.moveEast()!=null):
						path.pop_front()
					else:
						if(P.moveNorth()==null):
							P.moveSouth()
						aStarPath(path.back())
				elif((path[0]-path[1]).z ==1):
					if(P.moveWest()!=null):
						path.pop_front()
					else:
						if(P.moveNorth()==null):
							P.moveSouth()
						aStarPath(path.back())
				if(len(path) <=1):
					isPath = false
					path.clear()
					if(mode == WANDER):
						$WanderTimer.wait_time = rng.randf_range(3.0,6.0)
						$WanderTimer.start()
	if(mode == WANDER):
		if !isready:
			isready = true
			circle = P.getCircle(wanderRadius)
			var goal = circle[rng.randi_range(0,len(circle)-1)]
			aStarPath(goal)
	if(mode == FOLLOW && !isPath):
		if !isready:
			following = get_node(followingPath)
			isready = true
		if(distBetween(P.destination, following.destination) > followRadius):
			var followCircle = following.getCircle(followRadius)
			var closest = followCircle[0]
			for i in followCircle:
				if(distBetween(P.destination, i) 
						< distBetween(P.destination,closest)):
					closest = i
			aStarPath(closest)
				
func distBetween(start, end):
	return sqrt((start.x-end.x)*(start.x-end.x) 
		+ (start.y - end.y)*(start.y - end.y) 
		+ (start.z - end.z)*(start.z - end.z))

func aStarPath(goal):
	
	var search = []
	search.append(P.destination)
	
	var g = {}
	g[P.destination] = 0
	var h = {}
	h[P.destination] = distBetween(P.destination, goal)
	var prevNode = {}
	var searching = []
	searching.append(P.destination)
	
	var error = false
	
	while true:
		var search2 = search.duplicate()
		var lowestF = searching[0]
		for i in searching:
			if g[lowestF]+h[lowestF] > g[i]+h[i]:
				lowestF = i
		searching.remove(searching.find(lowestF))
		var n = P.getNorth(lowestF)
		var s = P.getSouth(lowestF)
		var e = P.getEast(lowestF)
		var w = P.getWest(lowestF)
		
		if !search2.has(n) && n!=null:
			search2.append(n)
			searching.append(n)
			g[n] = g[lowestF] + 1
			h[n] = distBetween(n,goal)
			prevNode[n] = lowestF
		elif n!= null:
			if(g[n] > g[lowestF] + 1):
				g[n] = g[lowestF] +1
				prevNode[n] = lowestF
				
		if !search2.has(s) && s!=null:
			search2.append(s)
			searching.append(s)
			g[s] = g[lowestF] + 1
			h[s] = distBetween(s,goal)
			prevNode[s] = lowestF
		elif s!=null:
			if(g[s] > g[lowestF] + 1):
				g[s] = g[lowestF] +1
				prevNode[s] = lowestF
			
		if !search2.has(e) && e!=null:
			search2.append(e)
			searching.append(e)
			g[e] = g[lowestF] + 1
			h[e] = distBetween(e,goal)
			prevNode[e] = lowestF
		elif e!= null:
			if(g[e] > g[lowestF] + 1):
				g[e] = g[lowestF] +1
				prevNode[e] = lowestF	
		if !search2.has(w) && w!=null:
			search2.append(w)
			searching.append(w)
			g[w] = g[lowestF] + 1
			h[w] = distBetween(w,goal)
			prevNode[w] = lowestF
		elif w != null:
			if(g[w] > g[lowestF] + 1):
				g[w] = g[lowestF] +1
				prevNode[w] = lowestF
		
		if(n==goal || s==goal || e==goal || w==goal):
			break
		
		search = search2
		
		if(len(searching)==0):
			error = true
			break
	if(!error):
		path.clear()
		path.push_front(goal)
		while path.front() != P.destination:
			if(prevNode[path.front()] != null):
				path.push_front(prevNode[path.front()])
		isPath = true
	
	
		

func _on_WanderTimer_timeout():
	
	var goal = circle[rng.randi_range(0,len(circle)-1)]
	while !P.CheckEntity(goal):
		goal = circle[rng.randi_range(0,len(circle)-1)]
	aStarPath(goal)
