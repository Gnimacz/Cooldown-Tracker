extends FileDialog

class_name Import

signal json_Parsed(json)

export(Dictionary) var test

func _on_MenuButton_pressed():
	self.show();
	pass # Replace with function body.


func _on_FileDialog_file_selected(path):
	var file = File.new();
	file.open(path, File.READ);
	var fileContent = file.get_as_text()
	#print(fileContent);
	var parsedJSON : Dictionary = parse_json(fileContent);
	emit_signal("json_Parsed", parsedJSON);
#	print(JSON.print(parsedJSON));
#	if typeof(parsedJSON) == TYPE_DICTIONARY:
#		for key in parsedJSON.keys():
##			print(key);
#			var value = parsedJSON[key]
##			print(value);
#			if typeof(value) == TYPE_DICTIONARY:
#				print("SUBDICT FOUND: " + key);
#				for item2 in parsedJSON[key].keys():
#					var item2Value = item2
#					print(item2Value);
	pass # Replace with function body.
	

