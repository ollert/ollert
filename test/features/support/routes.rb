OllertTest::Navigation.routes = {
    default: [
      [LandingPage, :lets_get_started],
      [LoginPage, :login_with_my_account],
      [SettingsPage]
    ],
    boards_route: [
      [LandingPage, :lets_get_started],
      [LoginPage, :login_with_my_account],
      [BoardsPage]
    ]
}
