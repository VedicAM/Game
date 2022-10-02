extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var req = $HTTPRequest




# Called when the node enters the scene tree for the first time.
func _ready():
	$HTTPRequest2.request('http://ip-api.com/json')
	
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_HTTPRequest2_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	var data = json.result
	var lat = data['lat']
	var lon = data['lon']
	req.request("https://api.openweathermap.org/data/2.5/weather?lat="+ str(lat) +"&lon="+str(lon)+"&appid=49d33ca9231195c4ba75579c3a2627e7")

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	var data = json.result
	var weatherData = data['weather']
	print(weatherData[0]['main'])



