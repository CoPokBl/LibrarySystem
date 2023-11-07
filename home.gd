extends Control

@onready var title: Label = $Vertical/Title;
@onready var admin_section: VBoxContainer = $Vertical/Admin;
@onready var borrow_limit_dialog: AcceptDialog = $BorrowLimitDialog;
@onready var cant_return_dialog: AcceptDialog = $CantReturn;

var max_borrow = 1;
var borrowed = 0;


func _ready():
	if Global.current_user == "admin":
		admin_section.visible = true;
	else:
		admin_section.visible = false;
	
	var config: ConfigFile = ConfigFile.new();
	config.load("user://lib.cfg");
	
	# Get borrowed amount and max borrow amount
	var max_borrow_conf_val = config.get_value("config", "max_borrow");
	if max_borrow_conf_val == null:
		config.set_value("config", "max_borrow", "1");
		config.save("user://lib.cfg");
		max_borrow_conf_val = "1";
	
	max_borrow = int(max_borrow_conf_val);
	
	# Borrowed books
	var books_string: String = config.get_value("borrowed", Global.current_user, "");
	var books = books_string.split(",", false);
	borrowed = len(books);
	
	# Change title
	title.text = "Welcome " + Global.current_user_name + "!" + "\nBorrowed: " + str(borrowed);


func _on_add_books_pressed():
	get_tree().change_scene_to_file("res://manage_books.tscn");


func _on_borrow_pressed():
	if borrowed >= max_borrow:
		borrow_limit_dialog.visible = true;
		return;
	get_tree().change_scene_to_file("res://borrow.tscn");


func _on_return_pressed():
	if borrowed == 0:
		cant_return_dialog.visible = true;
		return;
	get_tree().change_scene_to_file("res://return.tscn");


func _on_view_borrowed_pressed():
	get_tree().change_scene_to_file("res://view_borrowed.tscn");


func _on_logout_pressed():
	get_tree().change_scene_to_file("res://login.tscn");


func _on_settings_pressed():
	get_tree().change_scene_to_file("res://settings.tscn");
