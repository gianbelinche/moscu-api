Y('que existe un usuario con nombre {string} y email {string}') do |nombre, email|
  registrar_usuario(nombre, email, id_falso2)
end

Dado('tiene un auto modelo {string} patente {string} publicado como p2p') do |modelo, patente|
  @patente_oferta = patente
  registrar_auto(modelo, patente, 5000, 2004)
  cotizar_auto(patente, 5000)
  publicar_p2p(patente, 10000) #El propietario rechaza la oferta de Fiubak
end

Cuando('realizo una oferta de {int} sobre el auto de patente {string}') do |precio, patente|
  @precio = precio
  @request_realizar_oferta = {
    :id_ofertante => id_falso2,
    :precio => precio
  }.to_json

  @response = Faraday.post(realizar_oferta_url(patente), @request_publicar_p2p, header)
end

Entonces('recibo mensaje de oferta exitosa') do
  expect(@response.status).to eq(200)
  respuesta = JSON.parse(@response.body)

  expect(respuesta['id_oferta']).not_to eq(nil)
  expect(respuesta['patente']).to eq(@patente_oferta)
  expect(respuesta['id_ofertante']).to eq(id_falso2)
  expect(respuesta['precio']).to eq(@precio)
end

Entonces('recibo mensaje de error por publicacion inexistente') do
  expect(@response.status).to eq(400)
  respuesta = JSON.parse(@response.body)

  expect(respuesta['error']).to eq 'Error: Auto no esta en venta'
end

Cuando('realizo una oferta sin indicar precio sobre el auto de patente {string}') do |patente|
  @request_realizar_oferta = {
    :id_ofertante => id_falso2
  }.to_json

  @response = Faraday.post(realizar_oferta_url(patente), @request_publicar_p2p, header)
end
