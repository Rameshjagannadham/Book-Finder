import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/search/search_books_bloc.dart';
import '../widgets/book_list_item.dart';
import '../widgets/shimmer_list_item.dart';
import 'details_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    final max = _scroll.position.maxScrollExtent;
    final offset = _scroll.offset;
    if (offset > max - 200) {
      context.read<SearchBooksBloc>().add(const FetchNextPage());
    }
  }

  Future<void> _onRefresh() async {
    context.read<SearchBooksBloc>().add(const Refresh());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Finder')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Search book titles...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    context.read<SearchBooksBloc>().add(const QueryChanged(''));
                    setState(() {});
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (v) =>
                  context.read<SearchBooksBloc>().add(QueryChanged(v)),
              onChanged: (v) => setState(() {}),
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchBooksBloc, SearchBooksState>(
              builder: (context, state) {
                if (state.status == SearchStatus.initial) {
                  return const Center(child: Text('Search for books'));
                }
                if (state.status == SearchStatus.loading) {
                  return ListView.builder(
                    itemCount: 8,
                    itemBuilder: (c, i) => const ShimmerListItem(),
                  );
                }
                if (state.status == SearchStatus.failure) {
                  return Center(
                    child: Text(state.error ?? 'Something went wrong'),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _scroll,
                    itemCount: state.items.length + (state.loadingMore ? 1 : 0),
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      if (index >= state.items.length) {
                        return const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final book = state.items[index];
                      return BookListItem(
                        book: book,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                DetailsPage(workKey: book.key, fallback: book),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: (_controller.text.trim().isNotEmpty)
          ? FloatingActionButton.extended(
              onPressed: () => context.read<SearchBooksBloc>().add(
                QueryChanged(_controller.text),
              ),
              icon: const Icon(Icons.search),
              label: const Text('Search'),
            )
          : null,
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: const Text("Book Finder")),
  //     body: BlocBuilder<SearchBooksBloc, SearchBooksState>(
  //       builder: (context, state) {
  //         if (state is SearchLoading) {
  //           return ShimmerList(); // Your shimmer widget
  //         } else if (state is SearchLoaded) {
  //           return RefreshIndicator(
  //             onRefresh: () async {
  //               context.read<SearchBloc>().add(
  //                 RefreshBooks(state.query),
  //               ); // refresh current search
  //             },
  //             child: ListView.builder(
  //               controller: _scrollController,
  //               itemCount: state.books.length,
  //               itemBuilder: (context, index) {
  //                 final book = state.books[index];
  //                 return BookTile(book: book);
  //               },
  //             ),
  //           );
  //         } else if (state is SearchError) {
  //           return Center(child: Text("Error: ${state.message}"));
  //         } else {
  //           return const Center(child: Text("Search for books"));
  //         }
  //       },
  //     ),
  //   );
  // }
}
