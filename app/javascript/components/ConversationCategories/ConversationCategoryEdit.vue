<script setup lang="ts">
import axios from 'axios';
import * as yup from 'yup';
import { IConversationCategoryDetails } from '@/types/conversationcategory';
import { showToast } from '@/utils/showToast';
</script>

<template>
  <article>
    <v-form @submit.prevent="onSubmit">
      <h1>{{ category.name }}</h1>
      <Field v-model="category.id" type="hidden" name="id"></Field>

      <v-text-field v-model="category.name" label="Name" name="name"></v-text-field>

      <v-textarea
        v-model="category.description"
        label="Description"
        name="description"
      ></v-textarea>

      <v-switch v-model="category.is_active" label="Active"></v-switch>

      <v-btn type="submit">Save</v-btn>
    </v-form>
  </article>
</template>
<script lang="ts">
export default {
  data: () => {
    return {
      category: { id: 0 } as IConversationCategoryDetails,
      categorySchema: yup.object().shape({
        name: yup.string().required().label('Name'),
      }),
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
            showToast("You don't have permission to view that line.", 'error');
            break;
          case 404:
            showToast('Line not found', 'error');
            break;
        }
      });
  },
  methods: {
    onSubmit: function () {
      this.categorySchema.validate(this.category, { abortEarly: false }).then(() => {
        axios
          .put('/api/v1/conversationcategories/' + this.category.id, {
            category: this.category,
          })
          .then((result) => {
            showToast(result.data.data.attributes.name + ' updated', 'success');
          });
      });
    },
  },
};
</script>
