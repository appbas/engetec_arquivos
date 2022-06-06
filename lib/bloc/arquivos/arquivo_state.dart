import 'package:engee_arquivos/bloc/enums/state_enum.dart';
import 'package:engee_arquivos/shared/models/dado_arquivo_model.dart';

class ArquivoState {
  final StateEnum state;
  final String? caminho;
  late String? erroMessage;
  late List<DadosArquivo>? arquivos;

  ArquivoState(
      {required this.state, this.caminho, this.arquivos, this.erroMessage});

  factory ArquivoState.idle() {
    return ArquivoState(state: StateEnum.idle, arquivos: []);
  }

  factory ArquivoState.loading() {
    return ArquivoState(state: StateEnum.loading);
  }

  factory ArquivoState.success({required List<DadosArquivo> arquivos}) {
    return ArquivoState(state: StateEnum.success, arquivos: arquivos);
  }

  factory ArquivoState.loadingCaminho() {
    return ArquivoState(state: StateEnum.loading);
  }

  factory ArquivoState.successCaminho({required String? caminho}) {
    return ArquivoState(state: StateEnum.success, caminho: caminho);
  }

  factory ArquivoState.erro(String erroMessage) {
    return ArquivoState(
      state: StateEnum.erro,
      erroMessage: erroMessage,
    );
  }
}
