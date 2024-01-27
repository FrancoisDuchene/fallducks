extends Resource
class_name Stats

var high_score = {
		"value": 0,
		"date": ""
	}
	
const FILE_NAME = "user://data.json"
	
func update_high_score(new_score):
	if new_score < high_score["value"]:
		return false
	high_score["value"] = new_score
	var time = Time.get_date_dict_from_system()
	high_score["date"] = "%02d/%02d/%04d" % [time.day, time.month, time.year]
	return true

func save(data):
	ResourceSaver.save(data, FILE_NAME)

func load():
	if ResourceLoader.exists(FILE_NAME):
		return load(FILE_NAME)
	return null

