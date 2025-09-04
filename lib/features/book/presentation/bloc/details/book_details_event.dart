part of 'book_details_bloc.dart';

sealed class BookDetailsEvent extends Equatable {
  const BookDetailsEvent();
  @override
  List<Object?> get props => [];
}

class LoadDetails extends BookDetailsEvent {
  final String workKey;
  const LoadDetails(this.workKey);
}

class ToggleSave extends BookDetailsEvent {
  const ToggleSave();
}
