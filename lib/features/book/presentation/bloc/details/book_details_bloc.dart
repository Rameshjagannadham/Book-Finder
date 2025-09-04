import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/book.dart';
import '../../../domain/usecases/get_book_details.dart';
import '../../../domain/repositories/book_repository.dart';

part 'book_details_event.dart';
part 'book_details_state.dart';

class BookDetailsBloc extends Bloc<BookDetailsEvent, BookDetailsState> {
  final GetBookDetails getDetails;
  final BookRepository repo;

  BookDetailsBloc({required this.getDetails, required this.repo})
    : super(const BookDetailsState.initial()) {
    on<LoadDetails>(_onLoadDetails);
    on<ToggleSave>(_onToggleSave);
  }

  Future<void> _onLoadDetails(
    LoadDetails event,
    Emitter<BookDetailsState> emit,
  ) async {
    emit(state.copyWith(status: DetailsStatus.loading, error: null));
    try {
      final (book, details) = await getDetails(event.workKey);
      final saved = await repo.getSavedBook(book.key);
      emit(
        state.copyWith(
          status: DetailsStatus.success,
          book: book,
          details: details,
          isSaved: saved != null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: DetailsStatus.failure, error: e.toString()));
    }
  }

  Future<void> _onToggleSave(
    ToggleSave event,
    Emitter<BookDetailsState> emit,
  ) async {
    final b = state.book;
    if (b == null) return;
    if (state.isSaved) {
      await repo.deleteBook(b.key);
      emit(state.copyWith(isSaved: false));
    } else {
      await repo.saveBook(b);
      emit(state.copyWith(isSaved: true));
    }
  }
}
