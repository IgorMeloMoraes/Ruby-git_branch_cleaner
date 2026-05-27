# frozen_string_literal: true

require_relative '../lib/git_manager'

RSpec.describe GitManager do
  # Instanciamos a classe passando um caminho de mentira
  subject(:manager) { GitManager.new('/caminho/falso/do/projeto') }

  describe '#merged_branches' do
    it 'filtra e retorna apenas as branches que podem ser deletadas' do
      # MOCK: Simulamos a saída suja do comando 'git branch --merged'
      saida_simulada_do_git = <<~GIT
        * feature/nova-interface
          main
          master
          develop
          bugfix/corrige-botao
          feature/login-antigo
      GIT

      # Interceptamos a chamada de sistema para não rodar o Git de verdade
      allow(manager).to receive(:run_system_command)
        .with('git branch --merged')
        .and_return(saida_simulada_do_git)

      # Ação: pedimos a lista de branches mescladas
      branches_para_deletar = manager.merged_branches

      # Verificação: Ele deve ter ignorado o *, a main, a master e a develop
      expect(branches_para_deletar).to contain_exactly('bugfix/corrige-botao', 'feature/login-antigo')
    end
  end

  describe '#clean!' do
    it 'executa o comando de delecao apenas nas branches permitidas' do
      # MOCK: Simulamos que o método anterior já encontrou essas duas branches
      allow(manager).to receive(:merged_branches).and_return(['bugfix/corrige-botao', 'feature/login-antigo'])

      # EXPECTATIVA: Exigimos que a classe tente rodar o comando de deleção para cada uma delas
      expect(manager).to receive(:run_system_command).with('git branch -d bugfix/corrige-botao')
      expect(manager).to receive(:run_system_command).with('git branch -d feature/login-antigo')

      # Executamos a limpeza
      manager.clean!
    end
  end
end