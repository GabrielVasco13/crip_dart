# Crip Dart

Um aplicativo de linha de comando simples em Dart para demonstrar a criptografia e descriptografia de texto usando o algoritmo AES com o pacote `encrypt`.

## Funcionalidades

- Recebe um texto do usuário via linha de comando.
- Criptografa o texto usando uma chave AES pré-definida (atualmente 32 bytes).
- Utiliza um Vetor de Inicialização (IV) gerado aleatoriamente para cada criptografia.
- Descriptografa o texto de volta ao original usando a mesma chave e o IV correspondente.
- Imprime o texto criptografado (em Base64) e o texto descriptografado final.

## Estrutura do Projeto

- **`bin/crip_dart.dart`**: Ponto de entrada da aplicação, orquestra a interação com o usuário e chama as classes de criptografia/descriptografia.
- **`lib/encript.dart`**: Contém a classe `Cript`, responsável pela lógica de criptografia.
- **`lib/descript.dart`**: Contém a classe `Descript`, responsável pela lógica de descriptografia.
- **`lib/helper/encrypted_result.dart`**: Contém a classe `EncryptedResult`, usada para retornar os dados criptografados e o IV juntos.
- **`pubspec.yaml`**: Define as dependências do projeto, incluindo o pacote `encrypt`.

## Como Usar

1.  Certifique-se de ter o [SDK do Dart](https://dart.dev/get-dart) instalado.
2.  Navegue até o diretório raiz do projeto no terminal.
3.  Execute o comando:
    ```bash
    dart run bin/crip_dart.dart
    ```
4.  Siga as instruções para digitar o texto que deseja criptografar.

## Créditos

Este projeto foi desenvolvido por **Gabriel**.
