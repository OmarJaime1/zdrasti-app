// boss_icon_widget.dart (revised to support lesson tab integration)

import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/models/kuker_boss.dart';

class BossIconWidget extends StatelessWidget {
  final KukerBoss boss;
  final bool defeated;
  final bool isCooldown;
  final VoidCallback? onTap;
  final String? tooltipMessage;

  const BossIconWidget({
    super.key,
    required this.boss,
    required this.defeated,
    required this.isCooldown,
    required this.onTap,
    this.tooltipMessage,
  });

  @override
  Widget build(BuildContext context) {
    final String bossImagePath = defeated
    ? 'assets/images/kuker/kuker_boss_defeated.png'
    : 'assets/images/kuker/kuker_boss_icon.png';


    final bool isLocked = isCooldown;

    return Tooltip(
      message: isLocked
          ? (tooltipMessage ?? 'Writing challenge locked.')
          : 'Challenge the ${boss.name}',
      child: GestureDetector(
        onTap: isLocked ? null : onTap,
        child: Column(
          children: [
            ColorFiltered(
              colorFilter: isLocked
                  ? const ColorFilter.mode(Colors.grey, BlendMode.saturation)
                  : const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
              child: Image.asset(
                bossImagePath,
                height: 100,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              boss.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isLocked ? Colors.grey : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
} 