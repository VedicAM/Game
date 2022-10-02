extends HTTPRequest


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():

	self.request('https://api.weather.gov/points/39.7456, -97.0892')

func _http_request_completed(result, response_code, headers, body):
	var response = parse_json(body.get_string_from_utf8())

	# Will print the user agent string used by the HTTPRequest node (as recognized by httpbin.org).
	print(response)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
