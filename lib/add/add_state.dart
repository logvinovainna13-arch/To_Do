enum AddStatus { initial, loading, success, error }

class AddState {
  final AddStatus status;
  final String? errorMessage;

  const AddState({
    required this.status,
    this.errorMessage,
  });

  factory AddState.initial() => const AddState(status: AddStatus.initial);

  AddState copyWith({
    AddStatus? status,
    String? errorMessage,
  }) {
    return AddState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
