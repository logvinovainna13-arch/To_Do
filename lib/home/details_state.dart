enum DetailsStatus { initial, loading, success, error }

class DetailsState {
  final DetailsStatus status;
  final String? errorMessage;

  const DetailsState({
    required this.status,
    this.errorMessage,
  });

  factory DetailsState.initial() => const DetailsState(status: DetailsStatus.initial);

  DetailsState copyWith({
    DetailsStatus? status,
    String? errorMessage, 
  }) {
    return DetailsState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
