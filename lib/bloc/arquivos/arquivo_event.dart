abstract class ArquivoEvent {
  final String? caminho;
  const ArquivoEvent({this.caminho});
}

class HomeIdleEvent extends ArquivoEvent {}

class ArquivoLoadEvent extends ArquivoEvent {}

class ArquivoSuccessLoadEvent extends ArquivoEvent {
  ArquivoSuccessLoadEvent();
}

class ArquivoListEvent extends ArquivoEvent {}

class ArquivoSuccessListEvent extends ArquivoEvent {
  ArquivoSuccessListEvent([List props = const []]);
}

class ArquivoLoadCaminhoEvent extends ArquivoEvent {}

class ArquivoSuccessCaminhoEvent extends ArquivoEvent {}

class ArquivoSalvarCaminhoEvent extends ArquivoEvent {
  ArquivoSalvarCaminhoEvent({required String caminho})
      : super(caminho: caminho);
}
