
# Git Branch Cleaner 🧹

Uma ferramenta de automação (CLI) escrita em Ruby para manter o seu ambiente de desenvolvimento limpo e organizado.

O script varre recursivamente um diretório em busca de repositórios Git, identifica branches locais que já foram mescladas (*merged*) e realiza a exclusão em lote, ignorando com segurança branches protegidas (como `main`, `master` e `develop`).

## 🚀 Como usar

A ferramenta pode ser executada localmente passando um diretório como argumento, ou na pasta atual caso nenhum seja fornecido:

```bash
# Execução na pasta atual
./bin/cleaner

# Execução apontando para uma pasta com múltiplos projetos
./bin/cleaner /caminho/para/projetos/

```

## 🏗️ Arquitetura e Segurança

Para evitar perda de dados, o projeto separa a execução da regra de negócio:

* `bin/cleaner`: Orquestrador que navega no sistema de arquivos e exibe o relatório visual.
* `lib/git_manager.rb`: Classe que executa os comandos do Git (`branch --merged` e `branch -d`) com uma esteira de filtros de proteção.
* `spec/`: Suíte de testes (RSpec) utilizando **Mocks** agressivos na camada de sistema operacional para garantir que os testes nunca alterem ou deletem o estado real da máquina do desenvolvedor.

## ⚙️ Requisitos

* Ruby instalado.
* Git configurado no ambiente.
