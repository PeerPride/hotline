<script setup lang="ts">
import axios from 'axios';
import { ITagCategory } from '@/types/tagcategory';
</script>

<template>
  <h1>Tag Categories</h1>
  <v-btn color="secondary" class="float-right"
    ><RouterLink :to="{ name: 'TagCategoryAdd' }" class="btn btn-outline-primary float-end">
      Add
    </RouterLink></v-btn
  >
  <main>
    <v-table v-if="categories.length > 0" class="table table-condensed table-striped">
      <thead>
        <tr>
          <th>Name</th>
          <th>Description</th>
          <th>Status</th>
          <th></th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="cat in categories" :key="cat.id">
          <td>{{ cat.attributes.name }}</td>
          <td>{{ cat.attributes.description }}</td>
          <td>{{ cat.attributes.is_active ? 'Active' : 'Inactive' }}</td>
          <td>
            <div class="btn-group" role="group" aria-label="Basic example">
              <v-btn color="info"
                ><RouterLink
                  :to="{ name: 'TagCategoryView', params: { id: cat.id } }"
                  class="btn btn-secondary"
                >
                  View
                </RouterLink></v-btn
              >
              <v-btn color="info"
                ><RouterLink
                  :to="{ name: 'TagCategoryEdit', params: { id: cat.id } }"
                  class="btn btn-outline-secondary"
                  >Edit</RouterLink
                ></v-btn
              >
            </div>
          </td>
        </tr>
      </tbody>
    </v-table>
  </main>
</template>
<script lang="ts">
export default {
  data: () => {
    return {
      categories: [] as ITagCategory[],
      error: '' as string,
    };
  },
  computed: {
    //TODO
    listedItems() {
      return this.categories.map((item) => {
        return { ...item, description: item.attributes.description.substring(1, 30) };
      });
    },
  },
  mounted: function () {
    axios.get('/api/v1/tagcategories').then((response) => {
      this.categories = response.data.data;
    });
  },
};
</script>
