<script setup lang="ts">
import axios from 'axios';
import { ILine } from '@/types/line';
</script>

<template>
  <h1>Lines</h1>
  <v-btn color="secondary" class="float-right"
    ><RouterLink :to="{ name: 'LineAdd' }" class="btn btn-outline-primary float-end">
      Add
    </RouterLink></v-btn
  >
  <main>
    <v-table v-if="lines.length > 0">
      <thead>
        <tr>
          <th>Name</th>
          <th>Number</th>
          <th>Status</th>
          <th></th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="line in lines" :key="line.id">
          <td>{{ line.attributes.name }}</td>
          <td>{{ line.attributes.number }}</td>
          <td><span v-if="line.attributes.is_active">Active</span></td>
          <td>
            <v-btn color="info"
              ><RouterLink
                :to="{ name: 'LineView', params: { id: line.id } }"
                class="btn btn-secondary"
              >
                View
              </RouterLink></v-btn
            >
            <v-btn color="info"
              ><RouterLink
                :to="{ name: 'LineEdit', params: { id: line.id } }"
                class="btn btn-outline-secondary"
                >Edit</RouterLink
              ></v-btn
            >
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
      lines: [] as ILine[],
      error: '' as string,
    };
  },
  mounted: function () {
    axios.get('/api/v1/lines').then((response) => {
      this.lines = response.data.data;
    });
  },
};
</script>
