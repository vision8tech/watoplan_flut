import 'package:flutter/material.dart';

import 'package:watoplan/routes.dart';
import 'package:watoplan/localizations.dart';
import 'package:watoplan/intents.dart';
import 'package:watoplan/data/home_layouts.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/provider.dart';
import 'package:watoplan/utils/data_utils.dart';
import 'package:watoplan/widgets/fam.dart';
import 'package:watoplan/widgets/expansion_radio_group.dart';
import 'package:watoplan/widgets/radio_expansion.dart';

class HomeScreen extends StatefulWidget {

  final String title;
  List<MenuChoice> overflow = const <MenuChoice>[
    const MenuChoice(title: 'Settings', icon: Icons.settings, route: Routes.settings),
    const MenuChoice(title: 'About', icon: Icons.info, route: Routes.about)
  ];
  ValueNotifier<List<SubFAB>> subFabs = ValueNotifier([]);

  HomeScreen({ Key key, this.title }) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();

}

class HomeScreenState extends State<HomeScreen> {

  // Generate a list of 4 FABs to display the most used activityTypes for easy access
  List<SubFAB> typesToSubFabs(BuildContext context, List<ActivityType> types, List<Activity> activities) {
    List toShow = types
      .map((it) =>
        [it, activities.where((act) => act.typeId == it.id).length]
      ).toList()
      ..sort((a, b) => (b[1] as int).compareTo(a[1] as int));

    return toShow
      .sublist(0, toShow.length >= 4 ? 4 : toShow.length)
      .reversed.toList()
      .map((it) => it[0] as ActivityType).toList()
      .map((it) =>
        SubFAB(
          icon: it.icon,
          label: it.name,
          color: it.color,
          onPressed: () {
            Intents.setFocused(Provider.of(context), indice: -(types.indexOf(it) + 1));
            Intents.editEditing(
              Provider.of(context),
              Activity(
                type: it,
                data: it.params
                  .map((key, value) => MapEntry(key, value is DateTime
                    ? DateTimeUtils.copyWith(DateTime.now(), second: 0, millisecond: 0)
                    : value
                  )),
              )
            );
            Navigator.of(context).pushNamed(Routes.addEditActivity);
          },
        )
      ).toList();
  }

  @override
  Widget build(BuildContext context) {
    final AppState stateVal = Provider.of(context).value;
    // final Map<String, dynamic> soptions = stateVal.homeOptions['schedule'];
    // final Map<String, dynamic> moptions = stateVal.homeOptions['month'];
    final locales = WatoplanLocalizations.of(context);
    final theme = Theme.of(context);

    widget.subFabs.value = typesToSubFabs(context, stateVal.activityTypes, stateVal.activities);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title ?? locales.appTitle),
        actions: <Widget>[
          PopupMenuButton<ActivityType>(
            icon: Icon(Icons.add),
            onSelected: (ActivityType type) {
              Intents.setFocused(Provider.of(context), indice: -(stateVal.activityTypes.indexOf(type) + 1));
              Intents.editEditing(
                Provider.of(context),
                Activity(
                  type: type,
                  data: type.params
                    .map((key, value) => MapEntry(key, value is DateTime
                      ? DateTimeUtils.copyWith(DateTime.now(), second: 0, millisecond: 0)
                      : value
                    )),
                )
              );
              Navigator.of(context).pushNamed(Routes.addEditActivity);
            },
            itemBuilder: (BuildContext context) =>
              stateVal.activityTypes.map((type) =>
                PopupMenuItem<ActivityType>(
                  value: type,
                  child: ListTileTheme(
                    iconColor: type.color,
                    textColor: type.color,
                    child: ListTile(
                      leading: Icon(type.icon),
                      title: Text(type.name),
                    ),
                  ),
                )
              ).toList(),
          ),
          PopupMenuButton<MenuChoice>(
            onSelected: (MenuChoice choice) {
              Navigator.of(context).pushNamed(choice.route);
            },
            itemBuilder: (BuildContext context) =>
              widget.overflow.map((MenuChoice choice) =>
                PopupMenuItem<MenuChoice>(
                value: choice,
                child: Row(
                  children: <Widget>[
                    Icon(choice.icon),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0)),
                    Text(choice.title)
                  ],
                ),
                )
              ).toList(),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 14.0, right: 14.0, top: 18.0, bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Image.asset('assets/icons/logo.png', width: 36.0, height: 36.0,),
                  Padding(
                    padding: const EdgeInsets.only(left: 14.0),
                    child: Text(
                      locales.appTitle,
                      style: TextStyle(
                        letterSpacing: 2.6,
                        fontSize: 24.0,
                        fontFamily: 'Timeburner',
                      ),
                    ),
                  )
                ],
              ),
            ),
            Divider(),
          //   RadioExpansion(
          //     value: 'month',
          //     groupValue: stateVal.homeLayout,
          //     onChanged: (value) async {
          //       return Intents.switchHome(
          //         Provider.of(context),
          //         layout: 'month', options: stateVal.homeOptions['month']
          //       );
          //     },
          //     title: Row(
          //       children: <Widget>[
          //         Text(
          //           locales.layoutMonth.toUpperCase(),
          //           style: TextStyle(
          //             letterSpacing: 1.4,
          //             fontWeight: FontWeight.w700,
          //             fontFamily: 'Timeburner',
          //           )
          //         ),
          //       ],
          //     ),
          //     trailing: Icon(new IconData(0)),
          //     children: <Widget>[
          //       Container()
          //     ],
          //   ),
          //   RadioExpansion(
          //     value: 'schedule',
          //     groupValue: stateVal.homeLayout,
          //     onChanged: (value) async {
          //       return Intents.switchHome(
          //         Provider.of(context),
          //         layout: 'schedule', options: stateVal.homeOptions['schedule']
          //       );
          //     },
          //     title: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: <Widget>[
          //         Text(
          //           locales.layoutList.toUpperCase(),
          //           style: TextStyle(
          //             letterSpacing: 1.4,
          //             fontWeight: FontWeight.w700,
          //             fontFamily: 'Timeburner',
          //           )
          //         ),
          //         Expanded(child: Container()),
          //         Text(
          //           '${locales.by} '
          //           '${soptions['sortRev'] ? soptions['sorter'].split('').reversed.join('').toUpperCase() : soptions['sorter'].toUpperCase()}',
          //           style: TextStyle(
          //             letterSpacing: 1.4,
          //             fontFamily: 'Timeburner',
          //           ),
          //         )
          //       ],
          //     ),
          //     children: <Widget>[
          //       Column(
          //         children: locales.validSorts.keys.map(
          //           (name) => RadioListTile(
          //             title: Text(
          //               locales.validSorts[name](),
          //             ),
          //             activeColor: theme.accentColor,
          //             groupValue: soptions['sorter'],
          //             value: name,
          //             onChanged: (name) {
          //               Intents.sortActivities(Provider.of(context), options: soptions..['sorter'] = name);
          //             },
          //           )
          //         ).toList()
          //       ),
          //       Container(
          //         alignment: Alignment.centerRight,
          //         padding: const EdgeInsets.only(right: 14.0, bottom: 14.0),
          //         child: OutlineButton(
          //           padding: const EdgeInsets.all(0.0),
          //           textColor: soptions['sortRev'] ? Theme.of(context).accentColor : Theme.of(context).textTheme.subhead.color,
          //           borderSide: BorderSide(
          //             color: soptions['sortRev'] ? Theme.of(context).accentColor : Theme.of(context).hintColor,
          //           ),
          //           child: Text(
          //             soptions['sortRev'] ? locales.reversed.toUpperCase() : locales.reverse.toUpperCase(),
          //             style: TextStyle(
          //               fontFamily: 'Timeburner',
          //               fontSize: 12.0,
          //               fontWeight: FontWeight.w700,
          //               letterSpacing: 1.4,
          //             ),
          //           ),
          //           onPressed: () {
          //             Intents.sortActivities(Provider.of(context), options: soptions..['sortRev'] = !soptions['sortRev']);
          //           },
          //         ),
          //       ),
          //     ],
          //   ),
          // ],
          //////////
          /// ISSUE COULD BE THAT RADIOEXPANSIONS ARE BEING REBUILT BEFORE THE STATE IS UPDATED WITH NEW HOMELAYOUT
          //////////
          ]..addAll(validLayouts.values.map((HomeLayout layout) =>
            layout.menuBuilder(context, (value) {
              return Intents.switchHome(
                Provider.of(context),
                layout: layout.name, options: stateVal.homeOptions[layout.name]
              ).then((_) => value);
            })
          )),
          // ]..add(
          //   ExpansionRadioGroup(
          //     name: 'layoutMenu',
          //     members: validLayouts.values.map((HomeLayout layout) =>
          //       layout.menuBuilder(context, (value) async {
          //         await Intents.switchHome(Provider.of(context), layout: layout.name, options: stateVal.homeOptions[layout.name]);
          //       } /*stateVal.homeLayout*/)
          //     ).toList(),
          //   )
          // ),
        ),
      ),
      body: SafeArea(
        child: validLayouts[stateVal.homeLayout].builder(context)
      ),
      floatingActionButton: FloatingActionMenu(
        color: Theme.of(context).accentColor,
        entries: widget.subFabs,
        expanded: true,
      ),
    );
  }
}
