extends Control

var loaded_books: Array = [];
@onready var results_container: VBoxContainer = $Vertical/Results/ItemContainer;
@onready var borrow_confirm_dialog: ConfirmationDialog = $BorrowConfirm;
var book_res: PackedScene = preload("res://borrow_book_listing.tscn");


func _ready():
	var config: ConfigFile = ConfigFile.new();
	config.load("user://lib.cfg");
	var books = config.get_section_keys("book_titles");
	
	for book in books:
		# book is the id
		var b_title: String = config.get_value("book_titles", book);
		var b_author: String = config.get_value("book_authors", book);
		var b_year: String = config.get_value("book_years", book);
		var b_desc: String = config.get_value("book_desc", book);
		
		var book_oject = {
			title = b_title,
			author = b_author,
			year = b_year,
			desc = b_desc,
			id = book
		};
		
		loaded_books.append(book_oject);


func get_book_name_from_id(id: String):
	for book in loaded_books:
		if book.id == id:
			return book.title;
	return null;


func _on_search_text_changed(new_text):
	kill_all_children(results_container);
	for book in loaded_books:
		var title_match: bool = book.title.to_lower().begins_with(new_text.to_lower());
		var author_match: bool = book.author.to_lower().begins_with(new_text.to_lower());
		var year_match: bool = book.year == new_text;
		if title_match || author_match || year_match:
			add_result(book);


func add_result(book):
	var object = book_res.instantiate();
	results_container.add_child(object);
	
	object.get_node("TextAligner/Title").text = book.title;
	object.get_node("TextAligner/Desc").text = "Author: " + book.author + "\nYear: " + book.year + "\n" + book.desc;
	object.pressed.connect(borrow.bind(book.id));


func borrow(id: String):
	borrow_confirm_dialog.dialog_text = "Are you sure you would like to borrow " + get_book_name_from_id(id) + "?";
	borrow_confirm_dialog.get_ok_button().pressed.connect(borrow_confirmed.bind(id));
	borrow_confirm_dialog.visible = true;


func borrow_confirmed(id: String):
	var config: ConfigFile = ConfigFile.new();
	config.load("user://lib.cfg");
	
	var existing_borrowed: String = config.get_value("borrowed", Global.current_user, "");
	existing_borrowed += id + ",";
	config.set_value("borrowed", Global.current_user, existing_borrowed);
	
	config.save("user://lib.cfg");
	get_tree().change_scene_to_file("res://home.tscn");


func kill_all_children(node: Node):
	for child in node.get_children():
		node.remove_child(child);


func _on_back_pressed():
	get_tree().change_scene_to_file("res://home.tscn");
