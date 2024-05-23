class Service {
  int? id;
  String? nome;
  String? descricao;
  double? valor;
  String? horario;
  String? categoria;
  String? contato;

  Service(this.id, this.nome, this.descricao, this.valor, this.horario,
      this.categoria, this.contato);

  Service.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    nome = map["nome"];
    descricao = map["descricao"];
    valor = map["valor"];
    horario = map["horario"];
    categoria = map["categoria"];
    contato = map["contato"];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      "nome": nome,
      "descricao": descricao,
      "valor": valor,
      "horario": horario,
      "categoria": categoria,
      "contato": contato
    };

    if (id != null) {
      map["id"] = id;
    }

    return map;
  }
}
