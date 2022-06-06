import 'dart:async';

import 'package:engee_arquivos/bloc/arquivos/arquivo_event.dart';
import 'package:engee_arquivos/bloc/arquivos/arquivo_state.dart';
import 'package:engee_arquivos/business/services/arquivo_service.dart';
import 'package:engee_arquivos/shared/models/dado_arquivo_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArquivoBloc extends Bloc<ArquivoEvent, ArquivoState> {
  final _arquivoService = ArquivoService();

  List<DadosArquivo> arquivos = [];

  ArquivoBloc() : super(ArquivoState.idle()) {
    on<ArquivoLoadEvent>(mapEventToState);
    on<ArquivoListEvent>(mapEventToState);
    on<ArquivoLoadCaminhoEvent>(mapEventToState);
    on<ArquivoSalvarCaminhoEvent>(mapEventToState);
  }

  void loadArquivos() => add(ArquivoLoadEvent());
  void loading() => add(ArquivoListEvent());
  void salvarCaminho(String caminho) =>
      add(ArquivoSalvarCaminhoEvent(caminho: caminho));
  void loadCaminho() => add(ArquivoLoadCaminhoEvent());

  Future<void> mapEventToState(
      ArquivoEvent event, Emitter<ArquivoState> emit) async {
    if (event is ArquivoLoadEvent) {
      await _arquivoService.loadArquivos();
      loading();
    }

    if (event is ArquivoListEvent) {
      emit(ArquivoState.loading());
      emit(await _loadArquivos());
    }

    if (event is ArquivoLoadCaminhoEvent) {
      emit(ArquivoState.loadingCaminho());
      final caminho = await _loadCaminho();
      emit(caminho);
      loadArquivos();
    }

    if (event is ArquivoSalvarCaminhoEvent) {
      await salvarCaminhoStorage(event.caminho!);
      loadArquivos();
    }
  }

  Future<ArquivoState> _loadArquivos() async {
    try {
      arquivos = await _arquivoService.listar();
      return ArquivoState.success(arquivos: arquivos);
    } on Exception {
      return ArquivoState.erro('Erro ao carregar arquivos');
    }
  }

  Future<ArquivoState> _loadCaminho() async {
    try {
      final caminho = await _arquivoService.loadCaminho();
      return ArquivoState.successCaminho(caminho: caminho);
    } on Exception {
      return ArquivoState.erro('Erro ao carregar caminho');
    }
  }

  Future<ArquivoState> salvarCaminhoStorage(String caminho) async {
    await _arquivoService.salvarCaminho(caminho);
    return ArquivoState.successCaminho(caminho: caminho);
  }
}
