import 'package:flutter/material.dart';
import 'kuker_renderer.dart';

class StaticKukerRenderer extends KukerRenderer {
  const StaticKukerRenderer({
    required super.kuker,
    super.size = 200,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Assumes all parts are 512x768 and aligned
    const double baseWidth = 512;
    const double baseHeight = 768;
    final double height = size / baseWidth * baseHeight;

    return SizedBox(
      width: size,
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Optional: background glow/frame
          // Image.asset('assets/ui/kuker_frame.png'),

          // Base parts — rendered bottom to top
          Image.asset('images/kuker_parts/shoes/${kuker.shoes}.png'),
          Image.asset('images/kuker_parts/costume/${kuker.costume}.png'),
          Image.asset('images/kuker_parts/mask/${kuker.mask}.png'),
          Image.asset('images/kuker_parts/expressions/${kuker.expression}.png'),
          Image.asset('images/kuker_parts/horns/${kuker.horns}.png'),

          if (kuker.accessory != 'none')
            Image.asset('images/kuker_parts/accessory/${kuker.accessory}.png'),
        ],
      ),
    );
  }
}
