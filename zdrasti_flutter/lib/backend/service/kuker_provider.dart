import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/backend/service/kuker_repository_service.dart';
import 'package:zdrasti_flutter/models/kuker_data.dart';

class KukerProvider extends ChangeNotifier {
  KukerData _kuker = KukerData.defaultKuker();
  KukerData get kuker => _kuker;

  final KukerRepository _repo = KukerRepository();

  Future<void> load() async {
    final saved = await _repo.loadKuker();
    if (saved == null) {
      _kuker = KukerData.defaultKuker();
      await _repo.saveKuker(_kuker); // auto-save default
    } else {
      _kuker = saved;
    }
    notifyListeners();
  }


  Future<void> update(KukerData newKuker) async {
    _kuker = newKuker;
    await _repo.saveKuker(newKuker);
    notifyListeners();
  }
}
