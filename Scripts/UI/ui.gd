extends CanvasGroup

var player: CharacterBody2D = null
var hp: int = 0
var mana: int = 0
var coins: int = 0

func _ready() -> void:
	pass
	
func _process(_delta: float) -> void:
	if player:
		#scale = player.scale
		hp = player.hp
		mana = player.mana
		coins = player.coins

		$Control/HP.text = str(hp) + " hp"
		$Control/Mana.text = str(mana) + " mana"
		$Control/Coins.text = str(coins) + " coins"
	

func set_player(p : CharacterBody2D) -> void:
	self.player = p
	
