<script setup lang="ts">
import axios from 'axios';
import * as yup from 'yup';
import { ITagCategoryDetails } from '@/types/tagcategory';
import { showToast } from '@/utils/showToast';
</script>

<template>
  <article>
    <v-form @submit.prevent="onSubmit">
      <h1>Add Tag Category</h1>

      <v-text-field v-model="category.name" label="Name" name="name"></v-text-field>

      <v-textarea
        v-model="category.description"
        label="Description"
        name="description"
      ></v-textarea>

      <v-btn type="submit">Save</v-btn>
    </v-form>
  </article>
</template>
<script lang="ts">
export default {
  data: () => {
    return {
      category: { id: 0 } as ITagCategoryDetails,
      error: '' as string,
      tagCategorySchema: yup.object().shape({
        name: yup.string().required().label('Name'),
      }),
    };
  },
  methods: {
    onSubmit: function () {
      this.tagCategorySchema.validate(this.category, { abortEarly: false }).then(() => {
        axios.post('/api/v1/tagcategories/', { tagcategory: this.category }).then((result) => {
          showToast(result.data.data.attributes.name + ' created', 'success');
          this.$router.push('/tagcategories');
        });
      });
    },
  },
};
</script>
