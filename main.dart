import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const forest = Color(0xFF174F3E);
const lime = Color(0xFFD7F277);
const canvas = Color(0xFFF6F5F1);
const muted = Color(0xFF89918C);

void main() => runApp(const MasroofiApp());

class MasroofiApp extends StatelessWidget {
  const MasroofiApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'مصروفي',
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: canvas,
          colorScheme: ColorScheme.fromSeed(seedColor: forest),
          fontFamily: 'Roboto',
        ),
        home: const Directionality(textDirection: TextDirection.rtl, child: HomePage()),
      );
}

class Expense {
  Expense(this.name, this.category, this.amount, this.icon, this.time);
  final String name, category, time;
  final double amount;
  final IconData icon;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const budget = 1900.0;
  double total = 1284.50;
  int selectedTab = 0;
  final expenses = <Expense>[
    Expense('قهوة ومخبوزات', 'طعام وشراب', 8.50, Icons.coffee_rounded, 'اليوم · 10:24 ص'),
    Expense('سوبرماركت', 'تسوق', 64.20, Icons.shopping_basket_rounded, 'أمس · 6:12 م'),
    Expense('مشوار تاكسي', 'مواصلات', 12, Icons.local_taxi_rounded, 'أمس · 2:45 م'),
    Expense('اشتراك سينما', 'ترفيه', 18, Icons.movie_rounded, '١٠ مارس · 8:00 م'),
  ];

  String money(double value) => '\$${value.toStringAsFixed(2)}';
  IconData iconFor(String category) => switch (category) {
        'طعام وشراب' => Icons.restaurant_rounded,
        'تسوق' => Icons.shopping_bag_rounded,
        'مواصلات' => Icons.directions_car_rounded,
        'ترفيه' => Icons.movie_rounded,
        _ => Icons.receipt_long_rounded,
      };

  Future<void> addExpense() async {
    final name = TextEditingController();
    final amount = TextEditingController();
    String category = 'طعام وشراب';
    final formKey = GlobalKey<FormState>();
    final result = await showModalBottomSheet<Expense>(
      context: context,
      isScrollControlled: true,
      backgroundColor: canvas,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (context) => StatefulBuilder(builder: (context, setSheet) {
        return Padding(
          padding: EdgeInsets.fromLTRB(22, 24, 22, MediaQuery.of(context).viewInsets.bottom + 28),
          child: Form(
            key: formKey,
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              const Text('إضافة مصروف جديد', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: 18),
              TextFormField(controller: name, decoration: _input('اسم المصروف', Icons.edit_rounded), validator: (v) => v == null || v.trim().isEmpty ? 'اكتب اسم المصروف' : null),
              const SizedBox(height: 12),
              TextFormField(controller: amount, keyboardType: const TextInputType.numberWithOptions(decimal: true), inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))], decoration: _input('المبلغ بالدولار', Icons.attach_money_rounded), validator: (v) => double.tryParse(v ?? '') == null || double.parse(v!) <= 0 ? 'أدخل مبلغًا صحيحًا' : null),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(value: category, decoration: _input('الفئة', Icons.category_rounded), items: ['طعام وشراب', 'تسوق', 'مواصلات', 'ترفيه', 'أخرى'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setSheet(() => category = v ?? category)),
              const SizedBox(height: 16),
              FilledButton(onPressed: () { if (formKey.currentState!.validate()) Navigator.pop(context, Expense(name.text.trim(), category, double.parse(amount.text), iconFor(category), 'الآن')); }, style: FilledButton.styleFrom(backgroundColor: forest, padding: const EdgeInsets.all(15)), child: const Text('حفظ المصروف', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
            ]),
          ),
        );
      }),
    );
    name.dispose();
    amount.dispose();
    if (result != null && mounted) {
      setState(() { expenses.insert(0, result); total += result.amount; });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تمت إضافة المصروف ✓'), behavior: SnackBarBehavior.floating, duration: Duration(seconds: 2)));
    }
  }

  InputDecoration _input(String label, IconData icon) => InputDecoration(labelText: label, prefixIcon: Icon(icon), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none));

  @override
  Widget build(BuildContext context) {
    final ratio = (total / budget).clamp(0.0, 1.0);
    return Scaffold(
      body: SafeArea(child: CustomScrollView(slivers: [
        SliverPadding(padding: const EdgeInsets.fromLTRB(20, 13, 20, 112), sliver: SliverList(delegate: SliverChildListDelegate([
          Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('الثلاثاء، ١٢ مارس', style: TextStyle(color: Colors.grey.shade600, fontSize: 14)), const SizedBox(height: 4), const Text('أهلًا يا سارة 👋', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800))])), Container(width: 46, height: 46, decoration: BoxDecoration(color: lime, borderRadius: BorderRadius.circular(16)), child: const Icon(Icons.spa_rounded, color: forest))]),
          const SizedBox(height: 20),
          Container(padding: const EdgeInsets.all(21), decoration: BoxDecoration(color: forest, borderRadius: BorderRadius.circular(26)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [const Expanded(child: Text('إجمالي مصروفات مارس', style: TextStyle(color: Color(0xFFD4E1D9), fontSize: 14))), Icon(Icons.more_horiz_rounded, color: Colors.white.withValues(alpha: .8))]), const SizedBox(height: 8), Text(money(total), textDirection: TextDirection.ltr, style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w800, letterSpacing: -1)), const SizedBox(height: 13), Row(children: [const Expanded(child: Text('الميزانية الشهرية', style: TextStyle(color: Color(0xFFD4E1D9), fontSize: 12))), Text(money(budget), style: const TextStyle(color: Color(0xFFD4E1D9), fontSize: 12))]), const SizedBox(height: 8), ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: ratio, minHeight: 7, backgroundColor: Colors.white24, color: lime)), const SizedBox(height: 9), Row(children: [const Expanded(child: Text('متبقي من الميزانية', style: TextStyle(color: Color(0xFFD4E1D9), fontSize: 12))), Text(money(budget - total), style: const TextStyle(color: Color(0xFFD4E1D9), fontSize: 12))])])),
          const SizedBox(height: 24),
          _section('لمحة سريعة', 'هذا الشهر'),
          Row(children: [Expanded(child: _stat('المتوسط اليومي', '\$42.80', '↘ أقل 8% عن الشهر الماضي', Icons.bar_chart_rounded, const Color(0xFF4E906F))), const SizedBox(width: 12), Expanded(child: _stat('أكبر فئة', '\$420.00', 'تسوق · 33% من مصروفاتك', Icons.shopping_bag_rounded, const Color(0xFFD47862)))]),
          const SizedBox(height: 24),
          _section('آخر العمليات', 'عرض الكل'),
          Container(padding: const EdgeInsets.symmetric(horizontal: 14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: Column(children: [for (int i = 0; i < expenses.length; i++) _expenseRow(expenses[i], i == expenses.length - 1)])),
        ]))),
      ])),
      floatingActionButton: FloatingActionButton(onPressed: addExpense, backgroundColor: lime, foregroundColor: forest, elevation: 2, child: const Icon(Icons.add_rounded, size: 31)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(height: 68, color: Colors.white, elevation: 8, shape: const CircularNotchedRectangle(), notchMargin: 7, child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [_nav(0, Icons.home_rounded, 'الرئيسية'), _nav(1, Icons.bar_chart_rounded, 'التقارير'), const SizedBox(width: 42), _nav(2, Icons.account_balance_wallet_rounded, 'الميزانيات'), _nav(3, Icons.person_outline_rounded, 'حسابي')])) ,
    );
  }

  Widget _section(String title, String action) => Padding(padding: const EdgeInsets.only(bottom: 13), child: Row(children: [Expanded(child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800))), TextButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(action == 'عرض الكل' ? 'قريبًا: كل العمليات' : 'ملخص هذا الشهر'))), child: Text(action, style: const TextStyle(color: Color(0xFF54806C), fontWeight: FontWeight.w700)))]));

  Widget _stat(String title, String value, String caption, IconData icon, Color captionColor) => Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(19)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Expanded(child: Text(title, style: const TextStyle(color: muted, fontSize: 12))), Container(width: 30, height: 30, decoration: BoxDecoration(color: const Color(0xFFF1F4E7), borderRadius: BorderRadius.circular(10)), child: Icon(icon, size: 17, color: forest))]), const SizedBox(height: 9), Text(value, textDirection: TextDirection.ltr, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)), const SizedBox(height: 3), Text(caption, style: TextStyle(fontSize: 10.5, color: captionColor), maxLines: 1, overflow: TextOverflow.ellipsis)]));

  Widget _expenseRow(Expense item, bool last) => Container(padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(border: last ? null : const Border(bottom: BorderSide(color: Color(0xFFEAE9E3)))), child: Row(children: [Container(width: 42, height: 42, decoration: BoxDecoration(color: const Color(0xFFF6EFE6), borderRadius: BorderRadius.circular(14)), child: Icon(item.icon, color: forest, size: 20)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(item.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)), const SizedBox(height: 3), Text('${item.time} · ${item.category}', style: const TextStyle(fontSize: 11, color: muted), overflow: TextOverflow.ellipsis)])), const SizedBox(width: 8), Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text('−${money(item.amount)}', textDirection: TextDirection.ltr, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)), const SizedBox(height: 3), const Text('مصروف', style: TextStyle(fontSize: 10, color: muted))])]));

  Widget _nav(int index, IconData icon, String label) => InkWell(onTap: () { setState(() => selectedTab = index); if (index != 0) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('قسم $label — قريبًا'), duration: const Duration(seconds: 1))); }, child: SizedBox(width: 58, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, color: selectedTab == index ? forest : const Color(0xFFA1A8A3), size: 22), const SizedBox(height: 3), Text(label, style: TextStyle(fontSize: 10, fontWeight: selectedTab == index ? FontWeight.w700 : FontWeight.normal, color: selectedTab == index ? forest : const Color(0xFFA1A8A3)))])));
}
