import 'package:contador_de_ctrl_z/services/app_database.dart';

import 'package:contador_de_ctrl_z/providers/database.dart';
import 'package:contador_de_ctrl_z/providers/background.dart';
import 'package:contador_de_ctrl_z/providers/keyboard.dart';

import 'package:contador_de_ctrl_z/widgets/layout/window_border.dart';
import 'package:contador_de_ctrl_z/widgets/layout/background.dart';
import 'package:contador_de_ctrl_z/widgets/layout/window_buttons.dart';
import 'package:contador_de_ctrl_z/widgets/layout/left_rail.dart';
import 'package:contador_de_ctrl_z/widgets/layout/click_count_box.dart';
import 'package:contador_de_ctrl_z/widgets/layout/session_list.dart';

import 'package:contador_de_ctrl_z/widgets/buttons/icon_only_button.dart';
import 'package:contador_de_ctrl_z/widgets/buttons/session_buttons.dart';

import 'package:contador_de_ctrl_z/widgets/dialogs/session_dialog.dart';
import 'package:contador_de_ctrl_z/widgets/dialogs/finish_dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    super.key
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final AppDatabase database = DatabaseProvider.instance.db;

  List<Session> _sessions = [Session(createdAt: DateTime.now(), id: 1, name: "default", finished: true)];

  int currentSessionIndex = 0;
  int selectedIndex = -1;

  DateTime? selectedDate;
  int? clicksForSelectedDate;

  @override
  void initState() { 
    super.initState();
    _loadSessions();
  }
  
  Future<void> _loadSessions() async {
    List<Session> sessions = await database.getSessions();
    setState(() {
      _sessions = [
        Session(
          createdAt: DateTime.now(), 
          id: 1, 
          name: "default", 
          finished: true
        ),
        ...sessions
      ];
    });
  }

  Future<void> _deleteSession() async {
    setState(() {
      currentSessionIndex = 0;
    });

    await database.deleteSession(_sessions[selectedIndex].name);

    context.read<KeyboardProvider>().setSession(_sessions[0].name, isFinished: true);

    await _loadSessions();
  }

  Future<void> _selectDate(BuildContext context, String sessionName) async {
    final DateTime? picked = await showRoundedDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      imageHeader: AssetImage("assets/images/gatologo.png"),
      theme: ThemeData(brightness: Brightness.dark, primarySwatch: Colors.blueGrey),
      description: "Select a date to view clicks for that day",
      fontFamily: "Mali"
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });

      int count = await database.countClicksForDate(sessionName: sessionName, date: picked);
      setState(() {
        clicksForSelectedDate = count;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        BackgroundContainer(
          bgImage: context.select<BackgroundProvider, String?>((provider) => provider.backgroundImage),
          colorScheme: colorScheme,
        ),
        WindowBorder(colorScheme: colorScheme),
        Positioned.fill(
          child: Row(
            children: [
              LeftRail(),
              // Left
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            ClickCountBox(
                              colorScheme: colorScheme, 
                              selectedDate: selectedDate, 
                              clicksForSelectedDate: clicksForSelectedDate, 
                              currentSessionTime: _sessions[currentSessionIndex].createdAt
                            ),
                            SizedBox(height: 20),
                            FilledButton.icon(
                              onPressed: () {
                                if (!_sessions[currentSessionIndex].finished) {
                                  showFinishDialog(
                                    context, 
                                    colorScheme, 
                                    onFinish: () async {
                                      await database.finishSession(_sessions[currentSessionIndex].name);
                                      context.read<KeyboardProvider>().setCurrentSessionAsFinished();
                                      await _loadSessions();
                                    }
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "The session is already finished.",
                                        style: TextStyle(color: colorScheme.onSecondaryContainer)
                                      ),
                                      backgroundColor: colorScheme.secondaryContainer,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      animation: CurvedAnimation(
                                        parent: kAlwaysCompleteAnimation, 
                                        curve: Curves.easeInOut
                                      ),
                                    ),
                                  );
                                }
                              }, 
                              label: Text("Finish"),
                              icon: Icon(Icons.check_circle),
                            ),
                          ],
                        ),
                        Column(
                          spacing: 6,
                          children: [
                            IconOnlyButton(
                              onPressed: () => _selectDate(context, context.read<KeyboardProvider>().currentSession),
                              icon: Icon(Icons.calendar_today),
                            ),
                            IconOnlyButton(
                              onPressed: () {
                                setState(() {
                                  selectedDate = null;
                                  clicksForSelectedDate = null;
                                });
                              },
                              icon: Icon(Icons.restart_alt_outlined),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Right
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SessionList(
                          colorScheme: colorScheme, 
                          sessions: _sessions, 
                          onSessionSelected: (index) {
                            setState(() {
                              selectedIndex = index;
                            });
                          }
                        ),
                        // Below the list!
                        SessionButtons(
                          onSet: () {
                            if (selectedIndex < 0) return;
                            setState(() {
                              currentSessionIndex = selectedIndex;
                              context.read<KeyboardProvider>().setSession(_sessions[selectedIndex].name, isFinished: _sessions[selectedIndex].finished);
                            });
                          }, 
                          onDelete: () {
                            showDialog(
                              context: context, 
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Delete session"),
                                  content: Text("Are you sure you want to delete this session?\nThis action is irreversible."),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                          Navigator.pop(context);
                                      }, 
                                      child: const Text("No, cancel")
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await _deleteSession();
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Yes"),
                                    )
                                  ],
                                );
                              });
                          }, 
                          onAdd: () async {
                            final sessionName = await SessionDialog.show(
                                context, 
                                title: "Create session", 
                                hintText: "The session name.",
                                acceptButtonText: "Create",
                                inputValidator: (String value) async {
                                  if (await database.sessionExists(value)) {
                                    return "This name is already used.";
                                  }
                                  return null;
                                }
                              );
                              
                              if (sessionName != null) {
                                await database.createSession(DateTime.now(), sessionName);
                      
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "The session has been created.",
                                    style: TextStyle(color: colorScheme.onSecondaryContainer)
                                  ),
                                  backgroundColor: colorScheme.secondaryContainer,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  animation: CurvedAnimation(
                                    parent: kAlwaysCompleteAnimation, 
                                    curve: Curves.easeInOut
                                  ),
                                ),
                              );
                      
                                await _loadSessions();
                              }
                          }
                        )
                      ],
                    ),
                    SizedBox(width: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 40,
            color: Colors.transparent,
            child: WindowButtons(),
          )
        )
      ]
    );
  }
}