import 'dart:async';
import 'dart:io';

import 'package:engee_arquivos/bloc/arquivos/arquivo_bloc.dart';
import 'package:engee_arquivos/bloc/arquivos/arquivo_state.dart';
import 'package:engee_arquivos/bloc/enums/state_enum.dart';
import 'package:engee_arquivos/business/services/connection_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabelaArquivosWidget extends StatefulWidget {
  const TabelaArquivosWidget({Key? key}) : super(key: key);

  @override
  State<TabelaArquivosWidget> createState() => TabelaArquivosyWidgetState();
}

class TabelaArquivosyWidgetState extends State<TabelaArquivosWidget> {
  late final ArquivoBloc bloc;
  final caminhoController =
      TextEditingController(text: 'Nenhum caminho selecionado');
  final GlobalKey<State<StatefulWidget>> scaffoldKey =
      GlobalKey(debugLabel: 'ScaffoldArquivo');

  @override
  void initState() {
    super.initState();
    bloc = ArquivoBloc();
    bloc.loadCaminho();
  }

  void validarCaminho() async {
    if (caminhoController.value.text.trim().isNotEmpty) {
      var caminho = caminhoController.value.text;
      final isDirecotry = await FileSystemEntity.isDirectory(caminho);
      debugPrint(isDirecotry.toString());

      if (isDirecotry) {
        bloc.salvarCaminho(caminhoController.value.text);
      } else {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
          SnackBar(
            content: Text('Caminho informado inválido: $caminho'),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'EngeeTech - Envio de arquivos',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: BlocBuilder(
              bloc: bloc,
              builder: (BuildContext context, ArquivoState state) {
                if (state.state == StateEnum.success &&
                    state.caminho != null &&
                    state.caminho!.isNotEmpty) {
                  caminhoController.text = state.caminho!;
                }

                return Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: caminhoController,
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () async {
                        setState(() {
                          validarCaminho();
                        });
                      },
                      child: const Text('Validar caminho'),
                    ),
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: Container(
              width: double.maxFinite,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(
                  style: BorderStyle.solid,
                  width: 1,
                  color: theme.primaryColor,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BlocBuilder(
                    bloc: bloc,
                    builder: (BuildContext context, ArquivoState state) {
                      if (state.state == StateEnum.idle) {
                        return const Text('Aguarde');
                      }

                      if (state.state == StateEnum.loading) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator(),
                              Text(
                                'Carregando',
                                style: theme.textTheme.headline6,
                              ),
                            ],
                          ),
                        );
                      }

                      if (state.arquivos == null || state.arquivos!.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.file_copy_rounded,
                                size: 80,
                                color: primaryColor,
                              ),
                              Text(
                                'Nenhum arquivo encontrado',
                                style: TextStyle(
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.fontSize,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      final rows = bloc.arquivos
                          .map(
                            (dados) => DataRow(
                              cells: [
                                DataCell(
                                  Text(dados.nome),
                                ),
                                DataCell(
                                  Text(dados.hash),
                                ),
                                DataCell(
                                  Text(dados.dataHoraEnvio?.toIso8601String() ??
                                      'Pendente de envio'),
                                ),
                                DataCell(
                                  Center(
                                    child: Icon(
                                      dados.dataHoraEnvio == null
                                          ? Icons.thumb_down
                                          : Icons.thumb_up,
                                      color: dados.dataHoraEnvio == null
                                          ? Colors.red
                                          : Colors.green,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList();

                      return Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                            width: width,
                            child: DataTable(
                              columns: const [
                                DataColumn(
                                  label: Text('Nome arquivo'),
                                ),
                                DataColumn(
                                  label: Text('Hash arquivo'),
                                ),
                                DataColumn(
                                  label: Text('Data/Hora Envio'),
                                ),
                                DataColumn(
                                  label: Center(
                                    child: Text(
                                      'Enviado',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                              rows: rows,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: StreamBuilder(
              stream: ConnectionService.stream(),
              builder: (context, AsyncSnapshot<bool> snapshot) {
                if (!snapshot.hasData) {
                  return Row(
                    children: const [
                      Text('Carregando informação'),
                    ],
                  );
                }
                return Row(
                  children: [
                    Icon(
                      snapshot.data == null || snapshot.data!
                          ? Icons.wifi
                          : Icons.wifi_off,
                      color: snapshot.data! ? Colors.green : Colors.red,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        snapshot.data == null || !snapshot.data!
                            ? 'Sem conexão'
                            : 'Conectado',
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
