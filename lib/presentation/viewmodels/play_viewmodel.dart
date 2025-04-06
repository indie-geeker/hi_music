import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayState{
  final Uint8List? image;
  const PlayState({
    this.image
});

  PlayState copyWith({
    Uint8List? image,
  }) {
    return PlayState(
      image: image ?? this.image,
    );
  }
}

class PlayViewmodel extends StateNotifier<PlayState> {
  PlayViewmodel() : super(const PlayState());

  void setImage(Uint8List image) {
    state = state.copyWith(image: image);
  }

}

final playViewmodelProvider =
    StateNotifierProvider<PlayViewmodel, PlayState>((ref) {
  return PlayViewmodel();
});