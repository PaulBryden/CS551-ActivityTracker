class Settings {
  bool m_goalMod;
  bool m_historyMod;
  bool m_notificationsMod;
  Settings(this.m_goalMod, this.m_historyMod, this.m_notificationsMod);

  Settings.fromJson(Map<String, dynamic> json)
      : m_goalMod = json['goalMod'],
        m_historyMod = json['historyMod'],
        m_notificationsMod = json['notificationsMod'];

  Map<String, dynamic> toJson() => {'goalMod': m_goalMod, 'historyMod': m_historyMod, 'notificationsMod':m_notificationsMod};
}
