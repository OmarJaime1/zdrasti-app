import 'package:flutter/widgets.dart';
import 'package:zdrasti_flutter/models/kuker_data.dart';

abstract class KukerRenderer extends StatelessWidget {
  final KukerData kuker;
  final double size;

  const KukerRenderer({required this.kuker, this.size = 200, super.key});
}