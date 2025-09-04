import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'core/network/api_client.dart';
import 'features/book/data/datasources/book_local_datasource.dart';
import 'features/book/data/datasources/book_remote_datasource.dart';
import 'features/book/data/repositories/book_repository_impl.dart';
import 'features/book/domain/usecases/get_book_details.dart';
import 'features/book/domain/usecases/search_books.dart';
import 'features/book/presentation/bloc/details/book_details_bloc.dart';
import 'features/book/presentation/bloc/search/search_books_bloc.dart';
import 'features/book/presentation/pages/search_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final client = ApiClient(http.Client());
  final remote = BookRemoteDataSourceImpl(client);
  final local = BookLocalDataSourceImpl();
  final repo = BookRepositoryImpl(remote: remote, local: local);

  runApp(MyApp(repo: repo));
}

class MyApp extends StatelessWidget {
  final BookRepositoryImpl repo;
  const MyApp({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SearchBooksBloc(SearchBooks(repo))),
        BlocProvider(
          create: (_) =>
              BookDetailsBloc(getDetails: GetBookDetails(repo), repo: repo),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Book Finder',
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
        home: const SearchPage(),
      ),
    );
  }
}
