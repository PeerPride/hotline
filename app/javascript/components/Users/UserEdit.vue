<script setup lang="ts">
import axios from 'axios';
import * as yup from 'yup';
import { IUserDetails } from '@/types/user';
import { ILanguage, ILanguageDetails } from '@/types/language';
import { showToast } from '@/utils/showToast';
</script>

<template>
  <article>
    <v-form @submit.prevent="onSubmit">
      <h1>{{ user.name }}</h1>

      <v-text-field v-model="user.name" label="Name" name="name"></v-text-field>

      <v-text-field
        v-model="user.on_call_name"
        label="On-Call Name"
        name="on_call_name"
        hint="This is the name the operator uses with callers."
        persistent-hint
        class="mb-4"
      ></v-text-field>

      <v-text-field v-model="user.email" type="email" label="Email" name="email"></v-text-field>

      <v-text-field
        v-model="user.phone_number"
        type="tel"
        label="Phone Number"
        name="phone_number"
        hint="Be sure to include the international calling code. For US/Canada numbers, 1-xxx-yyy-zzzz."
        class="mb-4"
        persistent-hint
      ></v-text-field>

      <v-textarea v-model="user.bio" label="Bio" name="bio"></v-textarea>

      <v-card class="mb-5">
        <v-card-item>
          <strong>Languages</strong>
          <v-checkbox
            v-for="lang in languages"
            :key="lang.id"
            :label="lang.attributes.name"
            :model-value="userLanguages[lang.id] == 1"
            @click="toggleLanguage(lang.id)"
          ></v-checkbox>
        </v-card-item>
      </v-card>
      <v-btn type="submit">Save</v-btn>
    </v-form>
  </article>
</template>
<script lang="ts">
export default {
  data: () => {
    return {
      user: { id: 0 } as IUserDetails,
      languages: [] as ILanguage[],
      userid: 0,
      userLanguages: [] as number[],
      error: '' as string,
      userSchema: yup.object().shape({
        name: yup.string().required().label('Name'),
        email: yup.string().email().required().label('Email'),
      }),
    };
  },
  computed: {},
  mounted: function () {
    const id = this.$router.currentRoute.value.params.id;
    axios
      .get('/api/v1/users/' + id)
      .then((user) => {
        this.user = user.data.data.attributes;
        this.userid = this.user.id;
        axios.get('/api/v1/languages/').then((response) => {
          this.languages = response.data.data;
          response.data.data.forEach((lang: ILanguageDetails) => {
            const userHasLanguage = this.user.languages.filter((el) => {
              return el.id == lang.id;
            });

            this.userLanguages[lang.id] = userHasLanguage.length ? 1 : 0;
          });
        });
      })
      .catch((reason) => {
        switch (reason.response.status) {
          case 401:
            showToast("You don't have permission to view that user.", 'error');
            break;
          case 404:
            showToast('User not found', 'error');
            break;
        }
      });
  },
  methods: {
    toggleLanguage: function (id: number) {
      this.userLanguages[id] = this.userLanguages[id] ? 0 : 1;
    },
    onSubmit: function () {
      //TODO: Save languages
      this.userSchema.validate(this.user, { abortEarly: false }).then(() => {
        axios
          .put('/api/v1/users/' + this.user.id, {
            user: this.user,
          })
          .then((result) => {
            showToast(result.data.data.attributes.name + ' updated', 'success');
          });
      });
    },
  },
};
</script>
