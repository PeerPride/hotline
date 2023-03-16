<script setup lang="ts">
import axios from 'axios';
import * as yup from 'yup';
import { IConversationCategoryDetails } from '@/types/conversationcategory';
import { showToast } from '@/utils/showToast';
</script>

<template>
  <article>
    <v-form @submit.prevent="onSubmit">
      <h1>Add Category</h1>

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
      category: { id: 0 } as IConversationCategoryDetails,
      error: '' as string,
      cateogrySchema: yup.object().shape({
        name: yup.string().required().label('Name'),
      }),
    };
  },
  methods: {
    onSubmit: function () {
      this.cateogrySchema.validate(this.category, { abortEarly: false }).then(() => {
        axios
          .post('/api/v1/conversationcategories/', { category: this.category })
          .then((result) => {
            showToast(result.data.data.attributes.name + ' created', 'success');
            window.setTimeout(() => {
              this.$router.push('/conversationcategories');
            }, 500);
          });
      });
    },
  },
};
</script>
