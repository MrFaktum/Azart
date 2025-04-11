extends CanvasLayer

#(Для себя) Тестовая механика. Потом нужно удалить

var tips

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/Tips.visible = false
	$CanvasLayer/Continue.disabled = true
	$CanvasLayer/Continue.visible = false
	$CanvasLayer/Menu.disabled = true
	$CanvasLayer/Menu.visible = false
	Signals.connect("tips1_text", Callable(self, "tips_text"))

func tips_text(tips1_text):
	tips = tips1_text
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Tips.text = emit_signal(tips)
