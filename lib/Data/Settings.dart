class Settings {
  bool goalMod;
  bool historyMod;
  bool notificationsMod;
  Settings(this.goalMod, this.historyMod, this.notificationsMod);

  Settings.fromJson(Map<String, dynamic> json)
      : goalMod = json['goalMod'],
        historyMod = json['historyMod'],
        notificationsMod = json['notificationsMod'];

  Map<String, dynamic> toJson() => {'goalMod': goalMod, 'historyMod': historyMod, 'notificationsMod':notificationsMod};
}
