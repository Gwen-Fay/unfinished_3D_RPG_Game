extends Spatial

var camSpeed = 0.075
var zoomSpeed = 1.5

func _ready():
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
    if(Input.is_action_just_pressed("ui_cancel")):
        Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    
    var p = get_node("../GridMap/Player")
    global_transform.origin = p.transform.origin + Vector3(0,1.5,0)

func _input(event):
    var delta = get_process_delta_time ( )
    if event is InputEventMouseMotion:
        rotate_y(event.relative.x * delta * camSpeed)
        $CamGimbal2.rotate_x(-event.relative.y * delta * camSpeed)
    
    if event.is_pressed() && event is InputEventMouseButton: 
        if event.button_index == BUTTON_WHEEL_UP:
            scale = scale - Vector3(zoomSpeed,zoomSpeed,zoomSpeed)*delta
            
        if event.button_index == BUTTON_WHEEL_DOWN:
            scale = scale + Vector3(zoomSpeed,zoomSpeed,zoomSpeed)*delta
