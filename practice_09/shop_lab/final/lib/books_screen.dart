import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_badge.dart';
import 'models/book.dart';
import 'models/cart.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    debugPrint('BooksScreen build');
    final shown = books
        .where((b) => b.title.toLowerCase().contains(_query.toLowerCase()))
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
        actions: const [CartBadge()],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search books',
                filled: true,
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          for (final b in shown)
            Builder(builder: (context) {
              debugPrint('row ${b.title}');
              return ListTile(
                title: Text(b.title),
                subtitle: Text(b.author),
                trailing: _RowTrailing(book: b),
              );
            }),
        ],
      ),
    );
  }
}

/// Subscribes where the value is shown: only this widget rebuilds
/// when the cart changes, not the whole screen.
class _RowTrailing extends StatelessWidget {
  const _RowTrailing({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    final inCart = context.watch<Cart>().items.contains(book);
    if (inCart) return const Text('Added');
    return OutlinedButton(
      onPressed: () {
        final ok = context.read<Cart>().add(book);
        if (ok) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('Added'),
                duration: Duration(seconds: 1),
              ),
            );
        }
      },
      child: const Text('Add'),
    );
  }
}
