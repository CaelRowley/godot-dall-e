@tool
extends Control

var prompt_input: TextEdit
var size_dropwdown: OptionButton
var generate_button: Button
var output_image: TextureRect


func _enter_tree():
	prompt_input = $PromptInput
	size_dropwdown = $ImageSizeDropdown
	generate_button = $GenerateButton
	output_image = $OutputImage


func _on_generate_button_pressed():
	print("cheese")
