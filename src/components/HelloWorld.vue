<template>
  <v-app id="inspire">
    <v-app-bar flat>
      <v-container class="fill-height d-flex align-center">
        <v-avatar
          class="mr-10 ml-4"
          color="grey-darken-1"
          size="32"
        ></v-avatar>

        <v-btn
          v-for="link in links"
          :key="link"
          variant="text"
        >
          {{ link }}
        </v-btn>

        <v-spacer></v-spacer>

        <v-responsive max-width="260">
          <v-text-field
            density="compact"
            hide-details
            variant="solo"
          ></v-text-field>
        </v-responsive>
      </v-container>
    </v-app-bar>

    <v-main class="bg-grey-lighten-3">
      <v-container>
        <v-row>
          <v-col>
            <v-sheet min-height="70vh" rounded="lg">
              <v-card>
                <v-card-title>Factura #{{numeroFactura}}</v-card-title>
                <v-card-text>
                  <v-form
                    ref="form"
                    v-model="valid"
                    lazy-validation
                  >
                    <v-select
                      v-model="selectedProduct"
                      :items="products"
                      item-title="producto"
                      item-value="id"
                      return-object
                      :rules="[v => !!v || 'Item is required']"
                      label="Producto"
                      required
                      variant="outlined"
                    ></v-select>

                    <v-text-field
                      v-model="cantidad"
                      :counter="10"
                      :rules="nameRules"
                      label="Cantidad"
                      required
                      variant="outlined"
                    ></v-text-field>

                    <v-text-field
                      v-model="precio"
                      :counter="10"
                      :rules="nameRules"
                      label="Precio"
                      required
                      variant="outlined"
                    ></v-text-field>


                    <v-row class="mb-10" justify="center">
                      <v-btn
                        color="primary"
                        @click="addProduct"
                      >
                        Agregar Produto
                      </v-btn>
                    </v-row>

                    <v-row>
                      <v-text-field
                      v-model="buscarFactura"
                      :counter="10"
                      :rules="nameRules"
                      label="Buscar por Numero Factura"
                      required
                      variant="outlined"
                    ></v-text-field>

                    <v-btn
                        color="success"
                        class="ml-4 mt-2"
                        @click="buscar()"
                      >
                        Buscar Factura
                      </v-btn>
                    </v-row>

                    <v-row class="mt-3 mb-1" justify="center">
                      <v-btn
                        color="success"
                        class="mr-4"
                        @click="guardar()"
                      >
                        Guardar Factura
                      </v-btn>

                      <v-btn
                        color="error"
                        class="mr-4"
                        @click="reset"
                      >
                        Limpiar
                      </v-btn>
                    </v-row>
                  </v-form>
                </v-card-text>
              </v-card>

              <v-card elevation="16">
                <v-table>
                  <thead>
                    <tr>
                      <th class="text-left">
                        Cantidad
                      </th>

                      <th class="text-left">
                        Prod
                      </th>

                      <th class="text-left">
                        Descripcion
                      </th>

                      <th class="text-left">
                        Total
                      </th>

                      <th class="text-left">
                        Op
                      </th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="item in addedProducts" :key="item.id">
                      <td>{{ item.cantidad }}</td>
                      <td>{{ item.producto }}</td>
                      <td>{{ item.descripcion }}</td>
                      <td>{{item.precioTotal}}</td>
                      <td><v-btn icon="mdi-minus" color="error" class="ma-1" @click="removeProduct(item.id)"></v-btn></td>
                    </tr>
                  </tbody>
                </v-table>
              </v-card>
            </v-sheet>
          </v-col>
        </v-row>
      </v-container>
    </v-main>
  </v-app>
</template>

<script>
  import axios from "axios";
  import listProduct from '@/components/productos.js';

  export default {
    data: () => ({

      cantidad: 0,
      precio: 0,

      addedProducts: [],
      buscarFactura: "0000",

      selectedProduct: null,

      numeroFactura: 0,

      links: [
        'Clientes',
        'Productos',
        'Facturas',
        'Reportes',
      ],
      products: []
    }),

    computed:{
      precioTotal(){
        return (this.cantidad * this.precio);
      }
    },

    mounted(){
      this.numeroFactura = Math.floor(Math.random() * (99999 - (10000 + 1) + 10000));
      this.products = listProduct();

      console.log(this.products)
    },

    methods: {
      addProduct() {
        this.addedProducts.push({
          id: this.selectedProduct.id,
          producto: this.selectedProduct.producto,
          descripcion: this.selectedProduct.descripcion,
          cantidad: this.cantidad,
          precioTotal: this.precioTotal,
          numeroFactura: this.numeroFactura,
          precioUnitario: this.precio
        });
      },

      async guardar() {
        let listaAdd = [];

        this.addedProducts.forEach(x=> {
          let item = {descripcionProducto: x.descripcion,
          cantidadProducto: x.cantidad,
          precioTotal: this.precioTotal,
          numeroFactura: this.numeroFactura,
          fechaFactura: "2022-11-19",
          nombreEmisor: "Ups",
          precioUnitario: x.precioUnitario
        }

          listaAdd.push(item)
        })

        console.table(listaAdd)

        const urlGet = `/api/factura/add`;

        listaAdd.forEach(async x=> {
          const dataGet = await (await axios.post(urlGet, x)).data;
        })

      },

      async buscar() {
        let listaAdd = [];

        console.table(listaAdd)

        const urlGet = `/api/factura/search/${this.buscarFactura}`;

          const dataGet = await (await axios.get(urlGet)).data;

          dataGet.forEach(x=> {
            let item = {
              id: x.idFactura,
              producto: x.descripcionProducto,
              descripcion: x.descripcionProducto,
              cantidad: x.cantidadProducto,
              precioTotal: x.precioTotal,
              numeroFactura: x.numeroFactura,
              precioUnitario: x.precioUnitario
            }

            this.addedProducts.push(item)
        })
      },

      removeProduct(id) {
        this.addedProducts = this.addedProducts.filter(product => product.id !== id);
      }
    }
  }
</script>
