UI::PSDKMenuButton::TEXT_MESSAGES << [:String, 'Toggle Follower']
GamePlay::Menu::ACTION_LIST << :open_new_option
module ToggleFollower
  def init_conditions
    super << [true] # New option always visible
  end
  def open_new_option
    $game_switches[Yuki::Sw::FM_Enabled] = (!$game_switches[Yuki::Sw::FM_Enabled])
  end
end
GamePlay::Menu.prepend(ToggleFollower)