import 'package:ctrlz_counter/services/app_database.dart';
import 'package:ctrlz_counter/utils/utils.dart';
import 'package:flutter/material.dart';

class SessionList extends StatefulWidget {
  final ColorScheme colorScheme;
  final List<Session> sessions;
  final Function(int index) onSessionSelected;

  const SessionList({
    super.key,
    required this.colorScheme,
    required this.sessions,
    required this.onSessionSelected
  });

  @override
  State<SessionList> createState() => _SessionListState();
}

class _SessionListState extends State<SessionList> {
  int selectedIndex = -1;
  int? hoveredIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 300,
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: widget.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: StatefulBuilder(
        builder: (context, setState) {
          return ListView.separated(
            itemCount: widget.sessions.length,
            itemBuilder: (context, index) {
              bool isSelected = selectedIndex == index;
    
              return MouseRegion(
                onEnter: (_) => setState(() => hoveredIndex = index),
                onExit: (_) => setState(() => hoveredIndex = null),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                      widget.onSessionSelected(index);
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                      decoration: BoxDecoration(
                        color: isSelected 
                          ? widget.colorScheme.primaryFixedDim 
                          : hoveredIndex == index 
                            ? widget.colorScheme.primary.withValues(alpha: 0.2) 
                            : null,
                        borderRadius: BorderRadius.circular(20),
                        border: widget.sessions[index].finished
                          ? Border.all(
                            color: Colors.green.withValues(alpha: 0.5),
                            width: 3
                          ) : null,
                      ),
                      child: ListTile(
                        key: UniqueKey(),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.sessions[index].name, 
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                    ? widget.colorScheme.onPrimary
                                    : widget.colorScheme.onPrimaryContainer
                                )
                              ),
                            ),
                            if (widget.sessions[index].finished) Icon(
                                Icons.check_circle_outline_outlined,
                                color: Colors.green,
                                size: 20
                              )
                          ],
                        ),
                        subtitle: Text(
                          formatDate(widget.sessions[index].createdAt), 
                          style: TextStyle(
                            fontSize: 13, 
                            fontWeight: FontWeight.w500,
                            color: isSelected
                              ? widget.colorScheme.onPrimary.withValues(alpha: 0.8)
                              : widget.colorScheme.onPrimaryContainer.withValues(alpha: 0.7)
                          )
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: widget.colorScheme.onPrimaryContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            },
          );
        }
      ),
    );
  }
}