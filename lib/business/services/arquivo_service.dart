import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:engee_arquivos/business/database/data_base.dart';
import 'package:engee_arquivos/shared/models/dado_arquivo_model.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArquivoService {
  static const String caminho = "caminho";

  Future<void> loadArquivos() async {
    final path = (await SharedPreferences.getInstance()).getString('caminho');
    if (path != null && path.trim().isNotEmpty) {
      await Directory(path)
          .list()
          .where((dirOrFiles) => FileSystemEntity.isFileSync(dirOrFiles.path))
          .forEach((file) async {
        var hash = sha256.convert(File(file.path).readAsBytesSync()).toString();
        final base64 = base64Encode(File(file.path).readAsBytesSync());
        // debugPrint(
        //     'Nome: ${file.path.split(Platform.pathSeparator).last} Tamanho: ${base64.length.toString()}');
        final dadoArquivo = DadosArquivo(
          path: file.path,
          nome: file.path.split(Platform.pathSeparator).last,
          tamanho: File(file.path).lengthSync(),
          hash: hash,
          dataHoraCadastro: DateTime.now(),
          base64: base64,
        );
        if (!(await jaExisteHashArquivo(hash))) {
          await criar(dadoArquivo);
        }
      });
    }
  }

  Future<bool> jaExisteHashArquivo(String hash) async {
    final db = await EngeeTechDatabase.instance.database;
    final result = await db?.query(DadoArquivoFields.nomeTabela,
        columns: DadoArquivoFields.values,
        where: '${DadoArquivoFields.hash} = ?',
        whereArgs: [hash]);
    if (result == null || result.isEmpty) {
      return false;
    }
    return result.map(DadosArquivo.fromJson).isNotEmpty;
  }

  Future<DadosArquivo> criar(DadosArquivo dadoArquivo) async {
    final db = await EngeeTechDatabase.instance.database;

    final mapa = dadoArquivo.toJson();
    final id = await db?.insert(DadoArquivoFields.nomeTabela, mapa);
    return dadoArquivo.copy(id: id);
  }

  Future<List<DadosArquivo>> listar() async {
    final db = await EngeeTechDatabase.instance.database;
    final resultsMap =
        await db?.query('dado_arquivo', columns: DadoArquivoFields.values);
    return resultsMap!.map(DadosArquivo.fromJson).toList();
  }

  Future<String?> loadCaminho() async {
    final sp = await SharedPreferences.getInstance();
    final caminho = sp.getString(ArquivoService.caminho);
    return caminho;
  }

  Future<void> salvarCaminho(String caminho) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(ArquivoService.caminho, caminho);
  }
}
