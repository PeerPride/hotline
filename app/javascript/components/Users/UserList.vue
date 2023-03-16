<script setup lang="ts">
// import type { User } from "@/interfaces/User";
// import { fetchWrapper } from "@/_helpers/fetch-wrapper";
import axios from 'axios';
import { IUser } from '@/types/user';
</script>

<template>
  <h1>Users</h1>
  <v-btn color="secondary" class="float-right"
    ><RouterLink :to="{ name: 'UserInvite' }" class="btn btn-outline-primary float-end">
      Invite
    </RouterLink></v-btn
  >
  <main>
    <v-table v-if="users.length > 0">
      <thead>
        <tr>
          <th>Name</th>
          <th>Team</th>
          <th>Status</th>
          <th>Last Login</th>
          <th></th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="user in users" :key="user.id">
          <td>{{ user.attributes.name }}</td>
          <td></td>
          <td></td>
          <td>{{ $filters.dateToReadableDisplay(user.attributes.last_sign_in_at) }}</td>
          <v-btn color="info">
            <RouterLink
              :to="{ name: 'UserView', params: { id: user.id } }"
              class="btn btn-outline-secondary"
            >
              View
            </RouterLink>
          </v-btn>
        </tr>
      </tbody>
    </v-table>
  </main>
</template>
<script lang="ts">
export default {
  data: () => {
    return {
      users: [] as IUser[],
      error: '' as string,
    };
  },
  mounted: function () {
    axios.get('/api/v1/users').then((response) => {
      this.users = response.data.data;
    });
  },
};
</script>
