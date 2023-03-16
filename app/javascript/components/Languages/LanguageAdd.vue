<script setup lang="ts">
import axios from 'axios';
import * as yup from 'yup';
import { ILanguageDetails } from '@/types/language';
import { showToast } from '@/utils/showToast';
</script>

<template>
  <article>
    <v-form @submit.prevent="onSubmit">
      <h1>Add Language</h1>

      <v-text-field v-model="language.name" label="Name" name="name"></v-text-field>

      <v-btn type="submit">Save</v-btn>
    </v-form>
  </article>
</template>
<script lang="ts">
export default {
  data: () => {
    return {
      language: { id: 0 } as ILanguageDetails,
      error: '' as string,
      languageSchema: yup.object().shape({
        name: yup.string().required().label('Name'),
      }),
    };
  },
  methods: {
    onSubmit: function () {
      this.languageSchema.validate(this.language, { abortEarly: false }).then(() => {
        axios.post('/api/v1/languages/', { language: this.language }).then((result) => {
          showToast(result.data.data.attributes.name + ' created', 'success');
          window.setTimeout(() => {
            this.$router.push('/languages');
          }, 500);
        });
      });
    },
  },
};
</script>
