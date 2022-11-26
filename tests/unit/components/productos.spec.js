import {consultaProducto} from '@/components/productos.js'

describe('Catlogo Productos', () => {
  test('Error en el catlago de productos', () => {
    const consulta = consultaProducto();

    expect(consulta.length).toBe(5)
  })
})
