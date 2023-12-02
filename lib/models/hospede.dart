class Hospede {
  late String nome;
  late String cpf;
  late int idade;

  Hospede({required this.nome, required this.cpf, required this.idade});

  Map toMap() {
    return {
      'nome': nome,
      'cpf': cpf,
      'idade': idade,
    };
  }

  Hospede.fromMap(Map json) {
    nome = json["nome"];
    cpf = json["cpf"];
    idade = json["idade"];
  }
}
