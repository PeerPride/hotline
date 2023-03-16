<script setup lang="ts">
import axios from 'axios';
import { ILanguage } from '@/types/language';
</script>

<template>
  <h1>Languages</h1>
  <v-btn color="secondary" class="float-right"
    ><RouterLink :to="{ name: 'LanguageAdd' }" class="btn btn-outline-primary float-end">
      Add
    </RouterLink></v-btn
  >
  <main>
    <v-table v-if="languages.length > 0" class="table table-condensed table-striped">
      <thead>
        <tr>
          <th>Name</th>
          <th>Description</th>
          <th>Status</th>
          <th></th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="lang in languages" :key="lang.id">
          <td>{{ lang.attributes.name }}</td>
          <td>{{ lang.attributes.is_active ? 'Active' : 'Inactive' }}</td>
          <td>
            <div class="btn-group" role="group" aria-label="Basic example">
              <v-btn color="info"
                ><RouterLink
                  :to="{ name: 'LanguageView', params: { id: lang.id } }"
                  class="btn btn-secondary"
                >
                  View
                </RouterLink></v-btn
              >
              <v-btn color="info"
                ><RouterLink
                  :to="{ name: 'LanguageEdit', params: { id: lang.id } }"
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
      languages: [] as ILanguage[],
      error: '' as string,
    };
  },
  mounted: function () {
    axios.get('/api/v1/languages').then((response) => {
      this.languages = response.data.data;
    });
  },
};
</script>
