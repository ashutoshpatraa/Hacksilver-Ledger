import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import '../providers/category_provider.dart';
import '../models/category.dart';
import '../widgets/custom_drawer.dart';

class CategoryListScreen extends StatelessWidget {
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: const CustomDrawer(currentRoute: '/categories'),
        appBar: AppBar(
          title: const Text('Categories'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Expense'),
              Tab(text: 'Income'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CategoryList(type: CategoryType.expense),
            CategoryList(type: CategoryType.income),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddCategoryDialog(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    showDialog(context: context, builder: (ctx) => const AddCategoryDialog());
  }
}

class CategoryList extends StatelessWidget {
  final CategoryType type;
  const CategoryList({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, provider, child) {
        final categories = provider.categories
            .where((c) => c.type == type)
            .toList();

        if (categories.isEmpty) {
          return const Center(child: Text('No categories found.'));
        }

        return ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(cat.colorValue).withOpacity(0.2),
                child: Icon(
                  IconData(
                    cat.iconCode,
                    fontFamily: cat.fontFamily ?? 'MaterialIcons',
                    fontPackage: cat.fontPackage,
                  ),
                  color: Color(cat.colorValue),
                ),
              ),
              title: Text(cat.name),
              trailing: cat.isCustom
                  ? IconButton(
                      icon: const Icon(Icons.delete, color: Colors.grey),
                      onPressed: () {
                        // Confirm delete
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Delete Category?'),
                            content: const Text(
                              'This will not delete existing transactions, but they will lose this category association.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  provider.deleteCategory(cat.id!);
                                  Navigator.of(ctx).pop();
                                },
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : null, // Default categories cannot be deleted
            );
          },
        );
      },
    );
  }
}

class AddCategoryDialog extends StatefulWidget {
  const AddCategoryDialog({super.key});

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final _nameController = TextEditingController();
  CategoryType _type = CategoryType.expense;
  IconData _selectedIcon = Icons.restaurant; // Default icon
  int _selectedColor = 0xFFF44336; // Default color

  Future<void> _pickIcon() async {
    // Only use default Material icons (default behavior)
    // Note: showIconPicker returns IconPickerIcon in this version
    IconPickerIcon? result = await showIconPicker(context);

    if (result != null) {
      setState(() {
        _selectedIcon = result.data;
      });
    }
  }

  final List<int> _availableColors = [
    0xFFF44336, // Red
    0xFF4CAF50, // Green
    0xFF2196F3, // Blue
    0xFFFF9800, // Orange
    0xFF9C27B0, // Purple
    0xFF795548, // Brown
    0xFF607D8B, // Blue Grey
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Category'),
      scrollable: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Category Name'),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: RadioListTile<CategoryType>(
                  title: const Text('Expense'),
                  value: CategoryType.expense,
                  groupValue: _type,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (val) => setState(() => _type = val!),
                ),
              ),
              Expanded(
                child: RadioListTile<CategoryType>(
                  title: const Text('Income'),
                  value: CategoryType.income,
                  groupValue: _type,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (val) => setState(() => _type = val!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Select Icon'),
          const SizedBox(height: 8),
          Center(
            child: InkWell(
              onTap: _pickIcon,
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Theme.of(context).primaryColor,
                child: Icon(_selectedIcon, color: Colors.white, size: 30),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Center(child: Text('Tap to change icon')),
          const SizedBox(height: 16),
          const Text('Select Color'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _availableColors.map((color) {
              return InkWell(
                onTap: () => setState(() => _selectedColor = color),
                child: CircleAvatar(
                  backgroundColor: Color(color),
                  child: _selectedColor == color
                      ? const Icon(Icons.check, color: Colors.white)
                      : null,
                ),
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_nameController.text.isEmpty) return;

            final newCat = Category(
              name: _nameController.text,
              iconCode: _selectedIcon.codePoint,
              fontFamily: _selectedIcon.fontFamily,
              fontPackage: _selectedIcon.fontPackage,
              colorValue: _selectedColor,
              type: _type,
              isCustom: true,
            );

            Provider.of<CategoryProvider>(
              context,
              listen: false,
            ).addCategory(newCat);
            Navigator.pop(context);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
