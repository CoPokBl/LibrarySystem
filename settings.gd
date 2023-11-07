extends Control

@onready var users_container: VBoxContainer = $Vertical/Split/Users/ScrollContainer/UsersContainer;
@onready var new_user_id: LineEdit = $Vertical/Split/Users/Id;
@onready var new_user_name: LineEdit = $Vertical/Split/Users/Name;
var user_res: PackedScene = preload("res://user_listing.tscn");
var config: ConfigFile = ConfigFile.new();


func _ready():
	# Load All Users
	config.load("user://lib.cfg");
	
	var users: Array = config.get_section_keys("users");
	for user_id in users:
		var name: String = config.get_value("users", user_id);
		add_user_to_list(user_id, name);


func add_user_to_list(id: String, name: String):
	var node = user_res.instantiate();
	node.get_node("Horizontal/Vertical/Name").text = name;
	node.get_node("Horizontal/Vertical/Id").text = id;
	node.get_node("Horizontal/Delete").pressed.connect(delete_user.bind(id));
	users_container.add_child(node);


func remove_user_from_list(id: String):
	for child in users_container.get_children():
		if child.get_node("Horizontal/Vertical/Id").text == id:
			users_container.remove_child(child);
			return;
	# Didn't work, who cares


func delete_user(id: String):
	config.erase_section_key("users", id);
	config.save("user://lib.cfg");
	remove_user_from_list(id);


func _on_create_user_pressed():
	var id: String = new_user_id.text;
	var name: String = new_user_name.text;
	
	config.set_value("users", id, name);
	config.save("user://lib.cfg");
	add_user_to_list(id, name);


func change_config_value(key: String, value: String):
	config.set_value("config", key, value);
	config.save("user://lib.cfg");


func _on_back_pressed():
	get_tree().change_scene_to_file("res://home.tscn");


func _on_borrow_limit_text_changed(new_text):
	change_config_value("max_borrow", new_text);

