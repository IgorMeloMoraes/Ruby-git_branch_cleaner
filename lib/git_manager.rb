# frozen_string_literal: true

class GitManager
  # Usamos um Array constante (congelado na memória) para as branches intocáveis
  PROTECTED_BRANCHES = %w[main master develop].freeze

  def initialize(path)
    @path = path
  end

  def merged_branches
    # Chama o método privado que vai até o sistema operacional
    output = run_system_command('git branch --merged')
    
    # 1. Quebra o texto em várias linhas (.lines)
    # 2. Remove os espaços em branco de cada linha (.map(&:strip))
    # 3. Joga fora (.reject) tudo que for vazio, for a branch atual (*) ou for protegida
    output.lines.map(&:strip).reject do |branch|
      branch.empty? || branch.start_with?('*') || PROTECTED_BRANCHES.include?(branch)
    end
  end

  def clean!
    deleted_branches = []
    
    merged_branches.each do |branch|
      run_system_command("git branch -d #{branch}")
      deleted_branches << branch
    end
    
    # Retornamos a lista do que foi apagado para podermos mostrar na interface (CLI)
    deleted_branches
  end

  private

  # Centralizamos a chamada de sistema em um único lugar.
  # Isso nos permitiu fazer o "Mock" nos testes e também garante que
  # o comando seja executado exatamente dentro da pasta do projeto alvo.
  def run_system_command(command)
    `cd "#{@path}" && #{command}`
  end
end