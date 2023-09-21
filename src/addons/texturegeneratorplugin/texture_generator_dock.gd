@tool
extends Control

const CONFIG_FILE := "res://config.cfg"

var prompt_input: TextEdit
var size_dropwdown: OptionButton
var generate_button: Button

var api_key: String
var url := "https://api.openai.com/v1/images/generations"
var temperature := 0.5
var headers: Array[String]
var request_url: HTTPRequest
var request_image: HTTPRequest

var GeneratedImage = preload("res://addons/texturegeneratorplugin/generated_image.tscn")
var image_container: VBoxContainer


func _enter_tree():
	image_container = $ScrollContainer/ImageContainer
	var config: ConfigFile = ConfigFile.new()
	config.load(CONFIG_FILE)
	api_key = config.get_value("Secrets", "OpenAIAPIKey")
	headers = ["Content-type: application/json", "Authorization: Bearer " + api_key]
	
	prompt_input = $PromptInput
	size_dropwdown = $ImageSizeDropdown
	generate_button = $GenerateButton
	
	request_url = HTTPRequest.new()
	add_child(request_url)
	request_url.connect("request_completed", _on_request_url_completed)
	
	request_image = HTTPRequest.new()
	add_child(request_image)
	request_image.connect("request_completed", _on_request_image_completed)


func generate_image(prompt):
	generate_button.disabled = true
	prompt_input.editable = false
	
	var body = JSON.stringify({
		"prompt": prompt,
		"n": 1,
		"size": size_dropwdown.text
	})

	var err := request_url.request(url, headers, HTTPClient.METHOD_POST, body)
	if err != OK:
		print("There was an error generating the image!")


func _on_request_url_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	var image_url = response["data"][0]["url"]
	var err = request_image.request(image_url)
	if err != OK:
		print("There was an error downloading the image!")
		

func _on_request_image_completed(result, response_code, headers, body):
	var image = Image.new()
	var err = image.load_png_from_buffer(body)
	if err != OK:
		print("Couldn't load image.")
	var texture = ImageTexture.create_from_image(image)
	var generated_image = GeneratedImage.instantiate()
	image_container.add_child(generated_image)
	generated_image.set(prompt_input.text, texture)
	
	generate_button.disabled = false
	prompt_input.editable = true
	prompt_input.text = ""
	

func _on_generate_button_pressed():
	generate_image(prompt_input.text)
