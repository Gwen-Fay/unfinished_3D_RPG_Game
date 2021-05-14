extends Spatial

export (String, FILE, "*.json") var dialoguePath : String
onready var DUI = get_tree().get_root().get_node("Level/UI/DialogueBox")
onready var CUI = get_tree().get_root().get_node("Level/UI/ChoiceBox")

var dialogue = []
var line = []
var isDialogue = false
var isChoice = false
var choiceCount = 1
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if(event is InputEventKey && event.scancode == KEY_E && event.pressed && isDialogue):
		if(isChoice):
			var d = dialogue.front()[line.front()].get(CUI.get_node("Selector/Arrow").get_index() as String)
			dialogue.push_front(d)
			line.push_front(-1)
			isChoice = false
			nextDialogue()
		else:
			nextDialogue()
	if(event is InputEventKey && event.scancode == KEY_W && event.pressed && isChoice):
		if(CUI.get_node("Selector/Arrow").get_index()>0):
			CUI.get_node("Selector").move_child(CUI.get_node("Selector/Arrow"),CUI.get_node("Selector/Arrow").get_index() -1)
	if(event is InputEventKey && event.scancode == KEY_S && event.pressed && isChoice):
		if(CUI.get_node("Selector/Arrow").get_index()<choiceCount-1):
			CUI.get_node("Selector").move_child(CUI.get_node("Selector/Arrow"),CUI.get_node("Selector/Arrow").get_index() +1)

func interact():
	readFile(dialoguePath)
	startDialogue()
	

func readFile(path):
	var file = File.new()
	if not file.file_exists(path):
		print("failed to find file")
	file.open(path, File.READ)
	dialogue.push_front(parse_json(file.get_as_text()))
	line.push_front(0)

func clearDialogue():
	DUI.get_node("DialogueContent").text = ""
	DUI.get_node("DialogueName").text = ""
	DUI.get_node("DialoguePortrait").texture = null
	CUI.get_node("Choices/Option1").text = ""
	CUI.get_node("Choices/Option2").text = ""
	CUI.get_node("Choices/Option3").text = ""
	CUI.get_node("Choices/Option4").text = ""
	CUI.get_node("Selector").move_child(CUI.get_node("Selector/Arrow"),0)
	
func loadDialogue():
	
	if(dialogue.front()[line.front()].has("text")):
		DUI.visible = true
		CUI.visible = false
		DUI.get_node("DialogueContent").text = dialogue.front()[line.front()].get("text")
		DUI.get_node("DialogueName").text = dialogue.front()[line.front()].get("name")
		DUI.get_node("DialoguePortrait").texture = load("res://Dialogue/" 
				+ dialogue.front()[line.front()].get("name")
				+"/"+dialogue.front()[line.front()].get("face")+".png")
	elif(dialogue.front()[line.front()].has("choice")):
		DUI.visible = false
		CUI.visible = true
		isChoice = true
		choiceCount = dialogue.front()[line.front()].get("choice").size()
		if (choiceCount >= 4):
			CUI.get_node("Choices/Option4").text = dialogue.front()[line.front()].get("choice")[3]
		if (choiceCount >= 3):
			CUI.get_node("Choices/Option3").text = dialogue.front()[line.front()].get("choice")[2]
		if (choiceCount >= 2):
			CUI.get_node("Choices/Option2").text = dialogue.front()[line.front()].get("choice")[1]
		if (choiceCount >= 1):
			CUI.get_node("Choices/Option1").text = dialogue.front()[line.front()].get("choice")[0]
	elif(dialogue.front()[line.front()].has("effect")):
		$Effect.effect(dialogue.front()[line.front()].get("effect"))
		nextDialogue()
	elif(dialogue.front()[line.front()].has("set true")):
		Global.saveDict[dialogue.front()[line.front()].get("set true")] = true
		nextDialogue()
	elif(dialogue.front()[line.front()].has("set false")):
		Global.saveDict[dialogue.front()[line.front()].get("set false")] = false
		nextDialogue()
	elif(dialogue.front()[line.front()].has("if")):
		if (Global.saveDict.has(dialogue.front()[line.front()].get("if"))):
			if (Global.saveDict[dialogue.front()[line.front()].get("if")] == true):
				if (dialogue.front()[line.front()].has("t")):
					var d = dialogue.front()[line.front()].get("t")
					dialogue.push_front(d)
					line.push_front(-1)
			else:
				if (dialogue.front()[line.front()].has("f")):
					var d = dialogue.front()[line.front()].get("f")
					dialogue.push_front(d)
					line.push_front(-1)
		nextDialogue()
func startDialogue():
	isDialogue = true
	clearDialogue()
	loadDialogue()
	for i in get_parent().get_parent().get_children():
		i.canMove = false
		
func nextDialogue():
	line[0] += 1
	if (line.front() >= dialogue.front().size()):
		endDialogue()
	else:
		loadDialogue()
	
func endDialogue():
	if(line.size()>1):
		line.pop_front()
		dialogue.pop_front()
		nextDialogue()
	else:
		dialogue = []
		line = []
		clearDialogue()
		DUI.visible = false
		isDialogue = false
		yield(get_tree(), "idle_frame")
		for i in get_parent().get_parent().get_children():
			i.canMove = true
		
