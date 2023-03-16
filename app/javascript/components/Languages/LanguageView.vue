<script setup lang="ts">
import axios from 'axios';
import { ILanguageDetails } from '@/types/language';
import { showToast } from '@/utils/showToast';
</script>

<template>
  <article>
    <v-btn color="primary" class="float-right">
      <RouterLink
        v-if="language.id > 0"
        :to="{ name: 'LanguageEdit', params: { id: language.id } }"
        class="btn btn-outline-primary float-end"
        >Edit</RouterLink
      >
    </v-btn>
    <v-card variant="outlined">
      <v-card-title>
        {{ language.name }}
      </v-card-title>
      <v-card-text>
        Active?
        <v-icon v-if="language.is_active" icon="mdi-check-bold" color="green" />
        <v-icon v-if="!language.is_active" icon="mdi-alpha-x" color="red"></v-icon>
        {{ language.is_active ? 'Yes' : 'No' }}<br />
      </v-card-text>
    </v-card>
  </article>
</template>
<script lang="ts">
export default {
  data: () => {
    return {
      language: { id: 0 } as ILanguageDetails,
      error: '' as string,
    };
  },
  mounted: function () {
    const id = this.$router.currentRoute.value.params.id;
    axios
      .get('/api/v1/languages/' + id)
      .then((language) => {
        this.language = language.data.data.attributes;
      })
      .catch((reason) => {
        switch (reason.response.status) {
          case 401:
            showToast("You don't have permission to view that language.", 'error');
            break;
          case 404:
            showToast('Category not found', 'error');
            break;
        }
      });
  },
};
</script>
