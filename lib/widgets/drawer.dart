import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kanban_board/generated/l10n.dart';
import 'package:kanban_board/utils/constants/color_seed.dart';
import 'package:kanban_board/pages/archives_page/archives_page.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget(
      {super.key,
      required this.handleColorSelect,
      required this.handleBrightnessChange,
      required this.themeMode});

  final VoidCallback handleBrightnessChange;
  final void Function(ColorSeed seed) handleColorSelect;
  final ThemeMode themeMode;

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      // padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Row(
            children: const [
              Text(
                'Kanban Board',
                style: TextStyle(fontSize: 24.0),
              ),
            ],
          ),
        ),
        ListTile(
          style: ListTileStyle.drawer,
          leading: const Icon(Icons.archive_rounded),
          title:  Text(S.of(context).archives),
          onTap: () {
            if (Navigator.canPop(context)) Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ArchivesPage()));
          },
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PopupMenuButton<ColorSeed>(
                    icon: Icon(
                      const IconData(0xe46b, fontFamily: 'MaterialIcons'),
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    padding: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                    onSelected: (seed) =>
                      handleColorSelect(seed),
                    itemBuilder: (context) => ColorSeed.values
                        .map((seed) => PopupMenuItem<ColorSeed>(
                              value: seed,
                              child: ListTile(
                                leading: Icon(
                                  const IconData(0xe46b, fontFamily: 'MaterialIcons'),
                                  color: seed.color,
                                ),
                                title: Text(
                                  seed.label,
                                ),
                                textColor: seed.color,
                              ),
                            ))
                        .toList(),
                  ),
                  IconButton(
                    onPressed: handleBrightnessChange,
                    icon: Icon(themeMode == ThemeMode.dark
                        ? CupertinoIcons.sun_max
                        : CupertinoIcons.moon),
                    color: Theme.of(context).colorScheme.onBackground,
                  )
                ],
              ),
            ),
          ),
        )
      ],
    ));
  }
}
