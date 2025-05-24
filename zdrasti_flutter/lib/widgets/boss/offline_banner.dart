import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:zdrasti_flutter/backend/service/localization_service.dart';

class OfflineBanner extends StatefulWidget {
  final String staticTextKey;

  const OfflineBanner({
    super.key,
    required this.staticTextKey,
  });

  @override
  State<OfflineBanner> createState() => _OfflineBannerState();
}

class _OfflineBannerState extends State<OfflineBanner> {
  late StreamSubscription _subscription;
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      final isOffline = result == ConnectivityResult.none;
      if (mounted) setState(() => _isOffline = isOffline);
    });

    Connectivity().checkConnectivity().then((result) {
      if (mounted) setState(() => _isOffline = result == ConnectivityResult.none);
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isOffline) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      color: Colors.orange,
      padding: const EdgeInsets.all(8),
      child: Text(
        LocalizationService.getStaticText(widget.staticTextKey),
        style: const TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }
}