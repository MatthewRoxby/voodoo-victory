extends RichTextLabel


var hiscore : int

var score := 0

var display_score := 0.0

func _ready():
	text = "[center]score: 0"
	hiscore = SaveManager.save.high_score

func _process(delta):
	if(display_score < score):
		display_score += delta * 15.0
	else:
		display_score = score
	var d := int(display_score)
	if d > hiscore:
		text = "[center][rainbow][wave]new highscore: " + str(d)
	else:
		text = "[center]score: " + str(d)

func increase_score(amount : int):
	score += amount
	
