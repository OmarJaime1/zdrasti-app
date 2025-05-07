import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/backend/controllers/kuker_customization_controller.dart';
import 'package:zdrasti_flutter/widgets/customize_kuker/customization_category_tab.dart';
import 'package:zdrasti_flutter/widgets/customize_kuker/static_kuker_renderer.dart';

class KukerCustomizationScreen extends StatefulWidget {
  const KukerCustomizationScreen({super.key});

  @override
  State<KukerCustomizationScreen> createState() => _KukerCustomizationScreenState();
}

class _KukerCustomizationScreenState extends State<KukerCustomizationScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final controller = KukerCustomizationController();

  @override
  void initState() {
    super.initState();
    controller.initialize().then((_) {
      _tabController = TabController(length: controller.categories.length, vsync: this);
      setState(() {}); // triggers rebuild once tabs are ready
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customize Your Kuker')),
      body: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          if (controller.isLoading || controller.categories.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              if (!controller.isOnline)
                Container(
                  width: double.infinity,
                  color: Colors.red.withOpacity(0.85),
                  padding: const EdgeInsets.all(8),
                  child: const Text(
                    'Offline – Customization changes will not be saved',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 12),
              StaticKukerRenderer(kuker: controller.currentKuker),
              const SizedBox(height: 8),
              TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs: controller.categories.map((c) => Tab(text: c)).toList(),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: controller.categories.map((category) {
                    final items = controller.itemsByCategory[category] ?? [];
                    final selected = controller.currentKuker.toMap()[category.toLowerCase()]!;
                    return CustomizationCategoryTab(
                      category: category,
                      items: items.map((item) => item.id).toList(),
                      selectedItemId: selected,
                      unlockedItems: controller.unlockedItems,
                      onItemSelected: (itemId) => controller.updatePart(category, itemId),
                    );
                  }).toList(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: controller.reset,
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: controller.isOnline
                        ? () async {
                            await controller.save();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Kuker saved!')),
                            );
                          }
                        : null,
                    child: const Text('Save Kuker'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          );
        },
      ),
    );
  }
}