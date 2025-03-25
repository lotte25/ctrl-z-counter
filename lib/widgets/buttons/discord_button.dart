import 'package:ctrlz_counter/providers/discord.dart';
import 'package:ctrlz_counter/widgets/buttons/left_rail_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiscordButton extends StatelessWidget {
  final ColorScheme colorScheme;

  const DiscordButton({
    super.key,
    required this.colorScheme
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<RPCProvider>(
      builder: (context, rpcState, child) {
        return Stack(
          alignment: Alignment.topRight,
          children: [
            LeftRailButton(
              icon: Icon(Icons.discord),
              colorScheme: colorScheme,
              onPressed: () {},
            ),
            Positioned(
              width: 8,
              height: 8,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: rpcState.isConnected ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                  // border: Border.all(color: colorScheme.surface, width: 2)
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
