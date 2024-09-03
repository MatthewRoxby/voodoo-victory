extends TextureButton


func _ready():
	print("whaaa")
	pressed.connect(func(): print("pressed!"))
	mouse_entered.connect(func(): print("mouse enter!"))
	mouse_exited.connect(func(): print("mouse exit!"))
