import 'package:engee_arquivos/shared/models/load_state_model.dart';
import 'package:flutter/material.dart';

enum StateEnum {
  idle(LoadStateModel('Aguarde', Icons.access_time)),
  loading(LoadStateModel('Carregando', Icons.refresh)),
  erro(LoadStateModel('Erro ao carregar', Icons.refresh)),
  success(LoadStateModel('Sucesso', Icons.refresh));

  final LoadStateModel loadState;
  const StateEnum(this.loadState);
}
