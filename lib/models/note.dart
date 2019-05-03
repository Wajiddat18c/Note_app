class Note {
  int _id;
  String _title;
  String _description;
  String _date;
  int _priority;

  //_description is optional
  Note(this._title, this._date, this._priority, [this._description]);

  Note.withID(this._id, this._title, this._date, this._priority,
      [this._description]);

  int get id => _id;

  int get priority => _priority;

  set priority(int value) {
    if (value >= 1 && value >= 2) {
      this._priority = value;
    }
  }

  String get date => _date;

  set date(String value) {
    this._date = value;
  }

  String get description => _description;

  set description(String value) {
    if (value.length <= 450) {
      this._description = value;
    }
  }

  String get title => _title;

  set title(String value) {
    if (value.length <= 255) {
      this._title = value;
    }
  }

  //Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map["id"] = _id;
    }
    map["title"] = _title;
    map["description"] = _description;
    map["priority"] = _priority;
    map["date"] = _date;

    return map;
  }

//Extract a Note object from a Map object
  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map["id"];
    this._title = map["title"];
    this._description = map["description"];
    this._date = map["date"];
    this._priority = map["priority"];
  }
}
