# Crip Dart

Um aplicativo de linha de comando em Dart para demonstrar e comparar criptografia simétrica (AES), criptografia assimétrica (RSA), criptografia híbrida (AES+RSA), além de serialização/deserialização usando JSON e FlatBuffers.

## Funcionalidades

- Gera usuários com dados aleatórios.
- Serializa e desserializa dados usando JSON e FlatBuffers.
- Criptografa e descriptografa dados usando AES.
- Criptografa e descriptografa chaves usando RSA.
- Demonstra criptografia híbrida (AES+RSA), padrão seguro utilizado em aplicações reais.
- Realiza benchmark de desempenho de cada operação.
- Exibe exemplos dos dados serializados, encriptados e desencriptados no terminal, com cores para facilitar a visualização.

## Estrutura do Projeto

- **`bin/benchmark.dart`**: Executa o benchmark de serialização, criptografia e descriptografia, exibindo exemplos e tempos de execução.
- **`lib/aes/aes_encryptor.dart`**: Lógica de criptografia e descriptografia AES.
- **`lib/aes/aes_key.dart`**: Geração e fornecimento de chave e IV para AES.
- **`lib/rsa/rsa_keys.dart`**: Geração de pares de chaves RSA.
- **`lib/rsa/rsa_service.dart`**: Lógica de criptografia e descriptografia RSA.
- **`lib/user_usr_generated.dart`**: Código gerado pelo FlatBuffers para o modelo de usuário.
- **`lib/colors/xterm_colors.dart`**: Cores para exibição no terminal.
- **`schema/user.fbs`**: Schema FlatBuffers para usuários.
- **`pubspec.yaml`**: Dependências do projeto.

## Como Usar

1. Certifique-se de ter o [SDK do Dart](https://dart.dev/get-dart) instalado.
2. Navegue até o diretório raiz do projeto no terminal.
3. Execute o comando:
   ```bash
   dart run bin/benchmark.dart
   ```
   Ou utilize o script:
   ```bash
   ./run_benchmark.sh
   ```
   Ou rode pelo VS Code usando a configuração "Run Benchmark".
4. Veja no terminal os exemplos de dados e os tempos de execução de cada operação.

## Observações

- O projeto utiliza o padrão seguro de criptografia híbrida (AES para dados, RSA para chave/IV).
- O benchmark pode ser ajustado para diferentes quantidades de usuários alterando o valor de `n` em `benchmark.dart`.
- Os resultados são exibidos com cores para facilitar a leitura e comparação.

## Créditos

Este projeto foi desenvolvido por **Gabriel**.
