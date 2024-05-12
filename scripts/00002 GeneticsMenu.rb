UI::PSDKMenuButton::TEXT_MESSAGES << [:String, 'Genetics']
GamePlay::Menu::ACTION_LIST << :open_new_option
module GeneticsMenu
  def init_conditions
    super << [true] # New option always visible
  end
  def open_new_option
    # This is where you specify what to do with that new option
    log_info('choosed new option')
  end
end
GamePlay::Menu.prepend(GeneticsMenu)