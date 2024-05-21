UI::PSDKMenuButton::TEXT_MESSAGES << [:String, 'Journal']
GamePlay::Menu::ACTION_LIST << :open_journal
module JournalMenu
  def init_conditions
    super << [true] # New option always visible
  end
  def open_journal
    GamePlay.open_quest_ui()
  end
end
GamePlay::Menu.prepend(JournalMenu)