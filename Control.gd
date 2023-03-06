extends Control

signal set_ability_card_variable(ability)
var created_cards : Array
var valid_names = ["Abilities", "Ability_Layout"]
var ability_card : Resource = preload("res://Card.tscn")

var layout : Array
var inputJson
var ability_dict : Dictionary

onready var vbox = $"%VBoxContainer"
var hbox : HBoxContainer
var hboxes : Array

func _on_FileDialog_json_Parsed(json):
	inputJson = json;
	_try_Decode(json);
	apply_layout(layout)
	pass # Replace with function body.

func _try_Decode(inputJSON) -> void:
	if typeof(inputJSON) == TYPE_DICTIONARY:
		for key in inputJSON.keys():
			if valid_names.has(key):
				print("VALID NAME FOUND: ", key)
#				var new_card = ability_card.instance()
#				var new_card_callable := new_card as Card
#				get_node(".").add_child(new_card)
#				new_card_callable.set_ability_values(key, inputJSON[key])
				parse_valid_name(key, inputJSON[key])
#				return
				
#			print(key)
			if typeof(inputJSON[key]) == TYPE_DICTIONARY:
#				print("SUBDICT FOUND at: " + key + "\n\n")
				_try_Decode(inputJSON[key])
			elif typeof(inputJSON[key]) == TYPE_ARRAY:
#				print("ARRAY FOUND at: " + key + "\n\n")
				_try_Decode(inputJSON[key])
	elif typeof(inputJSON) == TYPE_ARRAY:
		var input := inputJSON as Array
		if input.size() > 0:
			for item in inputJSON:
				if typeof(item) == TYPE_DICTIONARY:
					_try_Decode(item);
				elif typeof(item) == TYPE_ARRAY:
					_try_Decode(item);
#				print(item)
		else:
			print("NO ITEMS IN ARRAY")
		return
	pass

func parse_valid_name(name, dict) -> void:
	match (name):
		"Abilities":
			ability_dict = dict
			for ability in dict:
				var new_card = ability_card.instance()
				var new_card_callable := new_card as Card
				new_card_callable.set_ability_values(ability, dict[ability])
				created_cards.append(new_card_callable)
#				print(ability, ": ", dict[ability], "\n")
			print((created_cards))
			pass
		"Ability_Layout":
			if(dict.size() > 0):
				var testarray := dict as Array
				layout = testarray
#				print(testarray.find("conjurers_tricks"))
				for ability in dict as Array:
					hbox = HBoxContainer.new()
					hbox.alignment = HBoxContainer.ALIGN_CENTER
					hboxes.append(hbox)
					$"%VBoxContainer".add_child(hbox, true)
					print("HBOX ADDED")
				print(hboxes)
			pass
	pass

func apply_layout(layout : Array) -> void:
	print("reading layout\n")
	var index = 0
	for layout_item in layout:
		var layout_string := layout_item as String
		var parsed_layout_layer = layout_string.split(" ", false)
		for layout_ability in parsed_layout_layer:
			var l_ability := layout_ability as String
			if (ability_dict as Dictionary).has(l_ability):
				for card in created_cards:
					if (card as Card).identifier == l_ability:
						print("FOUND ", card)
						hboxes[index].add_child(card)
					pass
		print(parsed_layout_layer)
		index = index + 1
	pass

func _process(delta):
	create_connections()
	if Input.is_action_just_pressed("ui_accept"):
		for card in created_cards:
			print((card as Node).rect_global_position)

export var handle_strength = 200

func create_connections():
	for child in $"%Connections".get_children():
		child.queue_free()
	
	for card in created_cards:
		if (card as Card).requires.size() == 0:
			continue
		for connection in card.requires:
			var curve := Curve2D.new()
			var cardNode = (card as Node)
			curve.add_point(cardNode.rect_global_position + cardNode.rect_size/2, Vector2(0,0), Vector2(0,-handle_strength))
			for card_connection in created_cards:
				if (card_connection as Card).identifier == connection:
					curve.add_point((card_connection as Node).rect_global_position + (card_connection as Control).rect_size/2, Vector2(0,handle_strength), Vector2(0,0))
			var l := Line2D.new()
			l.default_color = Color(1,1,1,1)
			l.width = 10
			for point in curve.get_baked_points():
				l.add_point(point)
#			for point 
			$"%Connections".add_child(l)
	pass
