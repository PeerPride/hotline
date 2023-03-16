<script setup lang="ts">
import axios from 'axios';
import { showToast } from '@/utils/showToast';
import { ITagCategoryDetails } from '@/types/tagcategory';
</script>

<template>
  <article>
    <RouterLink
      v-if="category.id > 0"
      :to="{ name: 'TagCategoryEdit', params: { id: category.id } }"
      class="btn btn-outline-primary float-end"
      >Edit</RouterLink
    >
    <h1>
      {{ category.name }}
    </h1>
    Active? {{ category.is_active ? 'Yes' : 'No' }}<br />
    Description: {{ category.description }}
  </article>
</template>
<script lang="ts">
export default {
  data: () => {
    return {
      category: { id: 0 } as ITagCategoryDetails,
      error: '' as string,
    };
  },
  mounted: function () {
    const id = this.$router.currentRoute.value.params.id;
    axios
      .get('/api/v1/tagcategories/' + id)
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
