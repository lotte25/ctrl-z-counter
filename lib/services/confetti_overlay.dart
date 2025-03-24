import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class Confetti {
  static void showOverlay(BuildContext context, ColorScheme colorScheme) {
    final overlay = Overlay.of(context);

    late OverlayEntry overlayEntry;
    late ConfettiController confettiController;
    late AnimationController fadeController;
    
    fadeController = AnimationController(
      vsync: Navigator.of(context),
      duration: const Duration(seconds: 2)
    );
    
    Animation<double> fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(fadeController)
    ..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        overlayEntry.remove();
      }
    });

    confettiController = ConfettiController(duration: Duration(seconds: 2, milliseconds: 500));

    overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return FadeTransition(
          opacity: fadeAnimation,
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.5),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: ConfettiWidget(
                    confettiController: confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    shouldLoop: false,
                    colors: [colorScheme.primary, colorScheme.primaryContainer, colorScheme.surface, colorScheme.secondaryContainer],
                    numberOfParticles: 30,
                    gravity: 0.1,
                    emissionFrequency: 0.2,
                    maxBlastForce: 50,
                  ),
                ),
              )
            ],
          ),
        );
      }
    );

    overlay.insert(overlayEntry);
    confettiController.play();

    Future.delayed(const Duration(seconds: 3), () {
      fadeController.forward();
    });
  }
}