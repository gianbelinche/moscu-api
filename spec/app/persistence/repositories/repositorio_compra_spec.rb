require 'integration_helper'

describe Persistence::Repositories::RepositorioCompra do
  let(:repo_auto) { Persistence::Repositories::RepositorioAuto.new }
  let(:repo_usuario) { Persistence::Repositories::RepositorioUsuario.new }
  let(:comprador) { CreadorUsuario.new(repo_usuario).crear_usuario('Juan', 34_535, 'juan@gmail.com') }
  let(:vendedor) { CreadorUsuario.new(repo_usuario).crear_usuario('Jorge', 34_536, 'jorge@gmail.com') }
  let(:un_auto) { CreadorAuto.new(repo_auto, repo_usuario).crear_auto('AA752OH', 'Fiat', 40_000, 1999, vendedor.id) }

  it 'deberia almacenar una compra nueva' do
    compra = Compra.new(comprador, vendedor, un_auto)
    described_class.new.save(compra)

    expect(described_class.new.all.count).to eq 1
  end
end
