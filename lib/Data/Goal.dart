class Goal {
  String m_name;
  int m_target;

  Goal(this.m_name, this.m_target);

  Map<String, dynamic> toJson() => {'name': m_name, 'target': m_target};

  factory Goal.fromJson(Map<String, dynamic> parsedJson) {
    return new Goal(parsedJson['name'], parsedJson['target']);
  }
}
