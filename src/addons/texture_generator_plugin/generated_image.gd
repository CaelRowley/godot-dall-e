@tool
extends Panel

var prompt_label: Label
var output_image: TextureRect


func set_image(prompt: String, texture: ImageTexture):
	prompt_label = $PromptLabel
	output_image = $OutputImage

	prompt_label.text = prompt
	output_image.texture = texture


func _on_save_button_pressed():
	var data := output_image.texture.get_image()
	data.convert(Image.FORMAT_RGBA8)
	data.save_png("res://" + prompt_label.text + ".png")


func _on_delete_button_pressed():
	queue_free()
