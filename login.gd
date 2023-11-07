extends Control

@onready var id_input: TextEdit = $PaddingContainer/Content/TextEdit;
@onready var error: Label = $PaddingContainer/Content/Error;

var error_count = 0;


func _ready():
	# If the admin user doesn't exist then create it
	var config: ConfigFile = ConfigFile.new();
	config.load("user://lib.cfg");
	var admin_exists: String = config.get_value("state", "admin_exists", "false");
	if admin_exists == "false":
		config.set_value("state", "admin_exists", "true");
		config.set_value("users", "admin", "Administrator");
		config.save("user://lib.cfg");


func _on_button_pressed():
	# Login
	var id = id_input.text;
	print("User " + id + " logging in");
	
	var config: ConfigFile = ConfigFile.new();
	config.load("user://lib.cfg");
	var user = config.get_value("users", id);
	if user == null:
		# User doesn't exist
		error_count += 1;
		error.text = "User doesn't exist (" + str(error_count) + ")";
		return;
	
	# User exists, user is their name and id is their id
	Global.current_user = id;
	Global.current_user_name = user;
	
	get_tree().change_scene_to_file("res://home.tscn");
