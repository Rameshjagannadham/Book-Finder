import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/book.dart';
import '../bloc/details/book_details_bloc.dart';

class DetailsPage extends StatefulWidget {
  final String workKey; // "/works/OLxxxxW"
  final Book? fallback;
  const DetailsPage({super.key, required this.workKey, this.fallback});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    context.read<BookDetailsBloc>().add(LoadDetails(widget.workKey));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Details')),
      body: BlocConsumer<BookDetailsBloc, BookDetailsState>(
        listener: (context, state) {
          if (state.error != null && state.status == DetailsStatus.failure) {
            // ScaffoldMessenger.of(
            //   context,
            // ).showSnackBar(SnackBar(content: Text(state.error!)));
          }
        },
        builder: (context, state) {
          if (state.status == DetailsStatus.loading &&
              widget.fallback != null) {
            return _body(context, widget.fallback!, null, false);
          }
          if (state.status == DetailsStatus.success && state.book != null) {
            return _body(context, state.book!, state.details, state.isSaved);
          }
          if (state.status == DetailsStatus.failure &&
              widget.fallback != null) {
            return _body(context, widget.fallback!, null, false);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _body(
    BuildContext ctx,
    Book book,
    Map<String, dynamic>? details,
    bool isSaved,
  ) {
    final cover = book.coverUrl;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) => Transform.rotate(
                angle: _controller.value * 2 * math.pi,
                child: child,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: cover != null
                    ? Image.network(
                        cover,
                        width: 180,
                        height: 240,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 180,
                        height: 240,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.menu_book, size: 64),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(book.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(book.author, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          if (book.firstPublishYear != null)
            Text('First published: ${book.firstPublishYear}'),
          const SizedBox(height: 12),
          if (details != null) ...[
            Text(
              'Work Key: ${book.key}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            if (details['description'] != null)
              Text(
                details['description'] is String
                    ? details['description']
                    : (details['description']['value'] ?? ''),
              ),
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () =>
                    ctx.read<BookDetailsBloc>().add(const ToggleSave()),
                icon: Icon(
                  isSaved ? Icons.bookmark_remove : Icons.bookmark_add,
                ),
                label: Text(isSaved ? 'Remove from Saved' : 'Save Locally'),
              ),
              // const SizedBox(width: 12),
              // OutlinedButton.icon(
              //   onPressed: () =>
              //       ctx.read<BookDetailsBloc>().add(LoadDetails(book.key)),
              //   icon: const Icon(Icons.refresh),
              //   label: const Text('Reload'),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
