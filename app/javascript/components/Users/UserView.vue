<script setup lang="ts">
import axios from 'axios';
import { isProxy, toRaw } from 'vue';
import { IUser, IUserDetails } from '@/types/user';
import { useToastStore } from '@/stores/toast.store';
import { showToast } from '@/utils/showToast';
</script>

<template>
  <article>
    <v-btn v-if="user.id" color="info" class="float-right"
      ><RouterLink :to="{ name: 'UserEdit', params: { id: user.id } }">Edit</RouterLink></v-btn
    >
    <h1>{{ user.name }}</h1>
    <div v-if="user.on_call_name">On-Call Name: {{ user.on_call_name }}</div>
    <div v-if="user.phone_number">Phone: {{ user.phone_number }}</div>
    <div v-if="user.email">
      Email: <a :href="user.email">{{ user.email }}</a>
    </div>
    <div v-if="user.pronouns">Pronouns: {{ user.pronouns }}</div>
    <div v-if="user.bio">Bio: {{ user.bio }}</div>
    <v-card class="mt-2 mb-2">
      <v-card-title>Languages</v-card-title>
      <v-card-text>
        <v-chip v-for="lang in user.languages" :key="lang.id">{{ lang.name }}</v-chip>
      </v-card-text>
    </v-card>
    <v-card class="mb-2">
      <v-card-title>Schedule</v-card-title>
      <v-card-text> </v-card-text>
    </v-card>
    <v-card class="mb-2">
      <v-card-title>Team</v-card-title>
      <v-card-text> </v-card-text>
    </v-card>
    <v-card class="mb-2">
      <v-card-title>Conversations</v-card-title>
      <v-card-text> </v-card-text>
    </v-card>
  </article>
</template>
<script lang="ts">
export default {
  props: ['me'],
  data: () => {
    return {
      user: { id: 0 } as IUserDetails,
      userid: 0,
      error: '' as string,
    };
  },
  mounted: function () {
    //console.log(toRaw(useAuthStore().currentuser));
    const id = this.$router.currentRoute.value.params.id
      ? this.$router.currentRoute.value.params.id
      : 'me';
    axios
      .get('/api/v1/users/' + id)
      .then((user) => {
        this.user = user.data.data.attributes;
        this.userid = this.user.id;
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
};
</script>
