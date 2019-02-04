class Goal {
  String name;
  int target;

  Goal(this.name, this.target);

  Map<String, dynamic> toJson() => {'name': name, 'target': target};

  factory Goal.fromJson(Map<String, dynamic> parsedJson) {
    return new Goal(parsedJson['name'], parsedJson['target']);
  }
}
