import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:money_manage/Screens/add_transaction/screen_add_transaction.dart';
import 'package:money_manage/Screens/category/category_add_popup.dart';
import 'package:money_manage/Screens/category/screen_category.dart';
import 'package:money_manage/Screens/home/widgets/bottom_nav.dart';
import 'package:money_manage/Screens/transactions/screen_transaction.dart';
import 'package:money_manage/db/Category/category_db.dart';
import 'package:money_manage/models/category/category_model.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  static ValueNotifier<int> SelectedIndexNotifier = ValueNotifier(0);

  final _pages = const [
    ScreenTransaction(),
    ScreenCategory(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("MONEY MANAGER"),
        centerTitle: true,
      ),
      bottomNavigationBar: const MoneyManagerBottomNavigation(),
      body: SafeArea(
          child: ValueListenableBuilder(
        valueListenable: SelectedIndexNotifier,
        builder: (BuildContext context, int updatedIndex, _) {
          return _pages[updatedIndex];
        },
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (SelectedIndexNotifier.value == 0) {
            print('Add Transaction');
            Navigator.of(context).pushNamed(ScreenaddTransaction.routeName);
          } else {
             print('Add Category');

             showCategoryAddPopup(context);

            // final _sample = CategoryModel(
            //   id: DateTime.now().millisecondsSinceEpoch.toString(),
            //   name: 'Travel',
            //   type: CategoryType.expense,
            // );

            // CategoryDB().InsertCategory(_sample);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
