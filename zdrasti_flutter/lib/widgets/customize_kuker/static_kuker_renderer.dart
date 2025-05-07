import 'package:flutter/material.dart';
import 'kuker_renderer.dart';

class StaticKukerRenderer extends KukerRenderer {
  const StaticKukerRenderer({required super.kuker, super.size, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset('assets/kuker_parts/costume/${kuker.costume}.png'),
          Image.asset('assets/kuker_parts/shoes/${kuker.shoes}.png'),
          Image.asset('assets/kuker_parts/horns/${kuker.horns}.png'),
          Image.asset('assets/kuker_parts/mask/${kuker.mask}.png'),
          if (kuker.accessory != 'none')
            Image.asset('assets/kuker_parts/accessory/${kuker.accessory}.png'),
          Image.asset('assets/kuker_parts/expressions/${kuker.expression}.png'),
          Image.asset('assets/kuker_parts/shoes/${kuker.shoes}.png'),
        ],
      ),
    );
  }
}
