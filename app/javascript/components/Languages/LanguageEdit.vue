<script setup lang="ts">
import axios from 'axios';
import * as yup from 'yup';
import { ILanguageDetails } from '@/types/language';
import { showToast } from '@/utils/showToast';
</script>

<template>
  <article>
    <v-form @submit.prevent="onSubmit">
      <h1>{{ language.name }}</h1>

      <v-text-field v-model="language.name" label="Name" name="name"></v-text-field>

      <v-switch v-model="language.is_active" label="Active"></v-switch>

      <v-btn type="submit">Save</v-btn>
    </v-form>
  </article>
</template>
<script lang="ts">
export default {
  data: () => {
    return {
      language: { id: 0 } as ILanguageDetails,
      languageSchema: yup.object().shape({
        name: yup.string().required().label('Name'),
      }),
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
      this.languageSchema.validate(this.language, { abortEarly: false }).then(() => {
        axios
          .put('/api/v1/languages/' + this.language.id, {
            language: this.language,
          })
          .then((result) => {
            console.log(result.data.data.attributes);
            showToast(result.data.data.attributes.name + ' updated', 'success');
          });
      });
    },
  },
};
</script>
