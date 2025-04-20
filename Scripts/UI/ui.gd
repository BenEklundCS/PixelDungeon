extends CanvasGroup

var player: CharacterBody2D = null
var hp: int = 0
var mana: int = 0

func _ready() -> void:
	pass
	
func _process(_delta: float) -> void:
	if player:
		position = player.position
		hp = player.hp
		mana = player.mana

		$Control/HP.text = str(hp) + " hp"
		$Control/Mana.text = str(mana) + " mana"
	

func set_player(p : CharacterBody2D) -> void:
	self.player = p
	
