import 'package:cake_wallet/routes.dart';
import 'package:cake_wallet/src/screens/dashboard/desktop_widgets/desktop_sidebar/side_menu.dart';
import 'package:cake_wallet/src/screens/dashboard/desktop_widgets/desktop_sidebar/side_menu_controller.dart';
import 'package:cake_wallet/src/screens/dashboard/desktop_widgets/desktop_sidebar/side_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:cake_wallet/router.dart' as Router;

class DesktopSidebarWrapper extends StatefulWidget {
  final Widget child;

  const DesktopSidebarWrapper({required this.child});

  @override
  State<DesktopSidebarWrapper> createState() => _DesktopSidebarWrapperState();
}

class _DesktopSidebarWrapperState extends State<DesktopSidebarWrapper> {
  final page = PageController();
  final sideMenu = SideMenuController();

  @override
  void initState() {
    SideMenuGlobal.controller = sideMenu;
    sideMenu.addListener((p0) {
      page.jumpToPage(p0);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SideMenu(
          topItems: [
            SideMenuItem(
              iconPath: 'assets/images/wallet_outline.png',
              priority: 0,
              onTap: (page, _) => sideMenu.changePage(page),
            ),
          ],
          bottomItems: [
            SideMenuItem(
              iconPath: 'assets/images/support_icon.png',
              priority: 1,
              onTap: (page, _) => sideMenu.changePage(page),
            ),
            SideMenuItem(
              iconPath: 'assets/images/settings_outline.png',
              priority: 2,
              onTap: (page, _) => sideMenu.changePage(page),
            ),
          ],
        ),
        Expanded(
          child: PageView(
            controller: page,
            physics: NeverScrollableScrollPhysics(),
            children: [
              widget.child,
              Container(
                child: Navigator(
                  initialRoute: Routes.support,
                  onGenerateRoute: (settings) => Router.createRoute(settings),
                  onGenerateInitialRoutes: (NavigatorState navigator, String initialRouteName) {
                    return [
                      navigator.widget.onGenerateRoute!(RouteSettings(name: initialRouteName))!
                    ];
                  },
                ),
              ),
              Navigator(
                initialRoute: Routes.desktop_settings_page,
                onGenerateRoute: (settings) => Router.createRoute(settings),
                onGenerateInitialRoutes: (NavigatorState navigator, String initialRouteName) {
                  return [
                    navigator.widget.onGenerateRoute!(RouteSettings(name: initialRouteName))!
                  ];
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}