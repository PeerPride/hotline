<script setup lang="ts">
import axios from 'axios';
import CallsByCategory from '../Reports/CallsByCategory.vue';
import { IConversationCategoryDetails } from '@/types/conversationcategory';
import { showToast } from '@/utils/showToast';
</script>

<template>
  <article>
    <v-btn color="primary" class="float-right">
      <RouterLink
        v-if="category.id > 0"
        :to="{ name: 'ConversationCategoryEdit', params: { id: category.id } }"
        class="btn btn-outline-primary float-end"
        >Edit</RouterLink
      >
    </v-btn>
    <v-card variant="outlined">
      <v-card-title>
        {{ category.name }}
      </v-card-title>
      <v-card-text>
        Active?
        <v-icon v-if="category.is_active" icon="mdi-check-bold" color="green" />
        <v-icon v-if="!category.is_active" icon="mdi-alpha-x" color="red"></v-icon>
        {{ category.is_active ? 'Yes' : 'No' }}<br />
        Description: {{ category.description }}
      </v-card-text>
    </v-card>
    <CallsByCategory :default-categories="[1]" :show-title="false"></CallsByCategory>
  </article>
</template>
<script lang="ts">
export default {
  data: () => {
    return {
      category: { id: 0 } as IConversationCategoryDetails,
      error: '' as string,
    };
  },
  mounted: function () {
    const id = this.$router.currentRoute.value.params.id;
    axios
      .get('/api/v1/conversationcategories/' + id)
      .then((category) => {
        this.category = category.data.data.attributes;
      })
      .catch((reason) => {
        switch (reason.response.status) {
          case 401:
            showToast("You don't have permission to view that category.", 'error');
            break;
          case 404:
            showToast('Category not found', 'error');
            break;
        }
      });
  },
};
</script>
