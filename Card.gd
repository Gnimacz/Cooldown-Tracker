extends Control

class_name Card

var inputDict
var identifier
var ability_name
var description
var unlocked
var damage
var ability_range
var cooldown
var requires
var type
var linked_to


func set_ability_values(input, input_value):
#	print("input received:\n", input, "\n", input_value)
	inputDict = input_value
	identifier = input
	ability_name = input_value["Name"]
	description = input_value["Description"]
	unlocked = input_value["Unlocked"]
	damage = input_value["Damage"]
	ability_range = input_value["Range"]
	cooldown = input_value["Cooldown"]
	requires = input_value["Requires"]
	type = input_value["Type"]
	linked_to = input_value["Linked_To"]
	
	get_node(".").name = identifier
	$"%Name".text = ability_name
	$"%Type".text = type
	$"%Description".text = description
	$"%Cooldown".text = cooldown as String
	$"%Requires".hide()
	$"%Requires".text = ""
	if((requires as Array).size() > 0):
		$"%Requires".show()
		$"%Requires".text = "Requires: "
		for item in requires:
			$"%Requires".text += item as String + " "
	pass
