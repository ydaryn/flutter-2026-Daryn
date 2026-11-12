import 'package:flutter/material.dart';

import 'api/fake_api.dart';
import 'widgets/empty_view.dart';
import 'widgets/error_view.dart';
import 'widgets/loading_view.dart';
import 'widgets/student_list.dart';

// Levels 2 and 5: the four states by hand, plus the Save button.
class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  List<Student>? _students; // null = not loaded yet
  Object? _error; // non-null = failed
  bool _saving = false; // Level 5: Save is in flight
  final _api = FakeApi(); // FakeApi(empty: true) shows the empty state

  @override
  void initState() {
    super.initState();
    // initState is synchronous: the framework will not wait, so no await.
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _students = null;
      _error = null;
    });
    try {
      final list = await _api.fetchStudents();
      if (!mounted) return; // the user may have left during the 2 seconds
      setState(() => _students = list);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e);
    }
  }

  // Level 5: the honest version. Awaited, try / on, pop only on success.
  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await _api.save(_students!.length);
      if (!mounted) return;
      Navigator.pop(context);
    } on StateError catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget body;
    if (_error != null) {
      body = ErrorView(onRetry: _load);
    } else if (_students == null) {
      body = const LoadingView();
    } else if (_students!.isEmpty) {
      body = const EmptyView();
    } else {
      body = StudentList(_students!);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Students — by hand')),
      body: body,
      floatingActionButton: _students == null
          ? null
          : FloatingActionButton(
              // null disables the button while the request is in flight
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
            ),
    );
  }
}
