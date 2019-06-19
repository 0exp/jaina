# frozen_string_literal: true

describe 'Smoke test' do
  specify do
    a = Class.new(Jaina::TerminalExpr) { token 'A' }
    b = Class.new(Jaina::TerminalExpr) { token 'B' }
    c = Class.new(Jaina::TerminalExpr) { token 'C' }
    d = Class.new(Jaina::TerminalExpr) { token 'D' }
    e = Class.new(Jaina::TerminalExpr) { token 'E' }

    Jaina.register_expression(a)
    Jaina.register_expression(b)
    Jaina.register_expression(c)
    Jaina.register_expression(d)
    Jaina.register_expression(e)

    ast = Jaina::Parser.parse('(A AND B) OR C AND (E OR D)')
    expect(ast.ast_tree.ast_oriented_program).to eq('AND OR AND A B C OR E D')

    ast = Jaina::Parser.parse('(A AND B) OR C AND (E OR D) AND (NOT C)')
    expect(ast.ast_tree.ast_oriented_program).to eq('AND AND OR AND A B C OR E D NOT C')
  end
end
