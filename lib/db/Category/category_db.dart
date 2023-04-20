import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_manage/models/category/category_model.dart';

const CATEGORY_DB_NAME = 'Category-database';

abstract class CategoryDBfunctions {
  Future<List<CategoryModel>> getCategories();
  Future<void> InsertCategory(CategoryModel value);
  Future<void> deleteCategory(String categoryID);
}

class CategoryDB implements CategoryDBfunctions {
  CategoryDB._internal();
  static CategoryDB instance = CategoryDB._internal();

  factory CategoryDB() {
    return instance;
  }

  ValueNotifier<List<CategoryModel>> incomCatgoryListListener =
      ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> expenseCatgoryListListener =
      ValueNotifier([]);

  @override
  Future<void> InsertCategory(CategoryModel value) async {
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);

    await _categoryDB.put(value.id, value);
    refreshUI();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    return _categoryDB.values.toList();
  }

  Future<void> refreshUI() async {
    final _allCatgories = await getCategories();
    incomCatgoryListListener.value.clear();
    expenseCatgoryListListener.value.clear();

    await Future.forEach(
      _allCatgories,
      (CategoryModel category) {
        if (category.type == CategoryType.incom) {
          incomCatgoryListListener.value.add(category);
        } else {
          expenseCatgoryListListener.value.add(category);
        }
      },
    );
    incomCatgoryListListener.notifyListeners();
    expenseCatgoryListListener.notifyListeners();
  }

  @override
  Future<void> deleteCategory(String categoryID) async {
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await _categoryDB.delete(categoryID);
    refreshUI();
  }
}
