import 'package:cake_wallet/generated/i18n.dart';
import 'package:cake_wallet/routes.dart';
import 'package:cake_wallet/src/screens/dashboard/desktop_widgets/desktop_sidebar/side_menu_controller.dart';
import 'package:cake_wallet/src/widgets/setting_action_button.dart';
import 'package:cake_wallet/src/widgets/setting_actions.dart';
import 'package:cake_wallet/typography.dart';
import 'package:flutter/material.dart';
import 'package:cake_wallet/router.dart' as Router;

final _settingsNavigatorKey = GlobalKey<NavigatorState>();

class DesktopSettingsPage extends StatefulWidget {
  const DesktopSettingsPage({super.key});

  @override
  State<DesktopSettingsPage> createState() => _DesktopSettingsPageState();
}

class _DesktopSettingsPageState extends State<DesktopSettingsPage> {
  int itemCount = 0;
  SideMenuController sideMenu = SideMenuController();
  int? currentPage;
  bool isTapped = false;

  initState() {
    super.initState();
    itemCount = SettingActions.all.length;
    sideMenu.addListener((index) {
      setState(() {
        isTapped = true;
        currentPage = index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.current.settings,
                      style: textXLarge(),
                    ),
                    SizedBox(height: 64),
                    Flexible(
                      child: ListView.separated(
                        padding: EdgeInsets.only(top: 0),
                        itemBuilder: (_, index) {
                          final item = SettingActions.all[index];
                          final isLastTile = index == itemCount;
                          return SettingActionButton(
                            isLastTile: isLastTile,
                            selectionActive: isTapped,
                            isSelected: currentPage == index,
                            isArrowVisible: true,
                            onTap: () {
                              if (currentPage != index) {
                                final settingContext =
                                    _settingsNavigatorKey.currentState?.context ?? context;
                                sideMenu.changePage(index);
                                item.onTap.call(settingContext);
                              }
                            },
                            image: item.image,
                            title: item.name,
                          );
                        },
                        separatorBuilder: (_, index) => Container(
                          height: 1,
                          color: Theme.of(context).primaryTextTheme.caption!.decorationColor!,
                        ),
                        itemCount: itemCount,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 100),
                  Flexible(
                    child: Navigator(
                      key: _settingsNavigatorKey,
                      initialRoute: Routes.empty_no_route,
                      onGenerateRoute: (settings) => Router.createRoute(settings),
                      onGenerateInitialRoutes: (NavigatorState navigator, String initialRouteName) {
                        return [
                          navigator.widget.onGenerateRoute!(RouteSettings(name: initialRouteName))!
                        ];
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}