class Settings {
  bool goalMod;
  bool historyMod;

  Settings(this.goalMod, this.historyMod);

  Settings.fromJson(Map<String, dynamic> json)
      : goalMod = json['goalMod'],
        historyMod = json['historyMod'];

  Map<String, dynamic> toJson() =>
      {'goalMod': goalMod, 'historyMod': historyMod};
}
