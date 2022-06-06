class DadoArquivoFields {
  static const List<String> values = [
    id,
    path,
    nome,
    tamanho,
    hash,
    dataHoraCadastro,
    base64,
    dataHoraEnvio
  ];

  static const String nomeTabela = 'dado_arquivo';
  static const String id = '_id';
  static const String path = 'path';
  static const String nome = 'nome';
  static const String tamanho = 'tamanho';
  static const String hash = 'hash';
  static const String base64 = 'base64';
  static const String dataHoraCadastro = 'dataHoraCadastro';
  static const String dataHoraEnvio = 'dataHoraEnvio';
}

class DadosArquivo {
  final int? id;
  final String path;
  final String nome;
  final int tamanho;
  final String hash;
  final DateTime dataHoraCadastro;
  late String? base64;
  late DateTime? dataHoraEnvio;

  DadosArquivo({
    this.id,
    required this.path,
    required this.nome,
    required this.tamanho,
    required this.hash,
    required this.dataHoraCadastro,
    this.base64,
    this.dataHoraEnvio,
  });

  static DadosArquivo fromJson(Map<String, Object?> json) => DadosArquivo(
      id: json[DadoArquivoFields.id] as int?,
      path: json[DadoArquivoFields.path] as String,
      nome: json[DadoArquivoFields.nome] as String,
      tamanho: json[DadoArquivoFields.tamanho] as int,
      hash: json[DadoArquivoFields.hash] as String,
      dataHoraCadastro:
          DateTime.parse(json[DadoArquivoFields.dataHoraCadastro].toString()),
      base64: json[DadoArquivoFields.base64] as String?,
      dataHoraEnvio: json[DadoArquivoFields.dataHoraEnvio] == null
          ? null
          : DateTime.parse(json[DadoArquivoFields.dataHoraEnvio] as String));

  Map<String, Object?> toJson() => {
        DadoArquivoFields.id: id,
        DadoArquivoFields.path: path,
        DadoArquivoFields.nome: nome,
        DadoArquivoFields.tamanho: tamanho,
        DadoArquivoFields.hash: hash,
        DadoArquivoFields.dataHoraCadastro: dataHoraCadastro.toIso8601String(),
        DadoArquivoFields.base64: base64,
        DadoArquivoFields.dataHoraEnvio: dataHoraEnvio?.toIso8601String(),
      };

  DadosArquivo copy({
    int? id,
    String? path,
    String? nome,
    int? tamanho,
    String? hash,
    DateTime? dataHoraCadastro,
    String? base64,
    DateTime? dataHoraEnvio,
  }) =>
      DadosArquivo(
        id: id ?? this.id,
        path: path ?? this.path,
        nome: nome ?? this.nome,
        tamanho: tamanho ?? this.tamanho,
        hash: hash ?? this.hash,
        dataHoraCadastro: dataHoraCadastro ?? this.dataHoraCadastro,
        base64: base64 ?? this.base64,
        dataHoraEnvio: dataHoraEnvio ?? this.dataHoraEnvio,
      );
}
