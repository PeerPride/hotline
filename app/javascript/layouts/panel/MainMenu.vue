<template>
  <v-card id="site-main-header">
    <v-layout>
      <!-- <v-system-bar color="deep-purple darken-3"></v-system-bar> -->

      <v-app-bar color="primary" prominent>
        <v-app-bar-nav-icon variant="text" @click.stop="drawer = !drawer"></v-app-bar-nav-icon>

        <v-toolbar-title>
          <RouterLink :to="{ name: 'index' }" style="color: white; text-decoration: none"
            >PeerPride</RouterLink
          >
        </v-toolbar-title>

        <v-spacer></v-spacer>

        <!-- <v-btn variant="text" icon="mdi-magnify"></v-btn>

        <v-btn variant="text" icon="mdi-filter"></v-btn>

        <v-btn variant="text" icon="mdi-dots-vertical"></v-btn> -->
      </v-app-bar>

      <v-navigation-drawer id="site-nav" v-model="drawer" location="start" temporary>
        <v-card class="mx-auto">
          <v-list v-model:opened="open">
            <v-list-item prepend-icon="mdi-home-outline"
              ><RouterLink :to="{ name: 'index' }">Home</RouterLink></v-list-item
            >

            <v-list-item prepend-icon="mdi-account-circle">
              <RouterLink :to="{ name: 'Users' }"> Users </RouterLink></v-list-item
            >

            <v-list-group value="Settings">
              <template #activator="{ props }">
                <v-list-item
                  v-bind="props"
                  prepend-icon="mdi-cog-outline"
                  title="Settings"
                ></v-list-item>
              </template>

              <v-list-item>
                <RouterLink :to="{ name: 'Lines' }"> Lines </RouterLink>
              </v-list-item>
              <v-list-item>
                <RouterLink :to="{ name: 'ConversationCategories' }"> Categories </RouterLink>
              </v-list-item>
              <v-list-item>
                <RouterLink :to="{ name: 'TagCategories' }"> Tags </RouterLink>
              </v-list-item>
              <v-list-item>
                <RouterLink :to="{ name: 'Languages' }"> Languages </RouterLink>
              </v-list-item>
            </v-list-group>
            <v-list-group value="Reports">
              <template #activator="{ props }">
                <v-list-item
                  v-bind="props"
                  prepend-icon="mdi-chart-box-outline"
                  title="Reports"
                ></v-list-item>
              </template>

              <v-list-item>
                <RouterLink :to="{ name: 'CallsByDay' }"> Calls By Day </RouterLink>
              </v-list-item>
              <v-list-item>
                <RouterLink :to="{ name: 'CallsByDOW' }"> Calls By Day of Week </RouterLink>
              </v-list-item>
              <v-list-item>
                <RouterLink :to="{ name: 'CallsByTimeOfDay' }" class="dropdown-item">
                  Calls By Time of Day
                </RouterLink>
              </v-list-item>
            </v-list-group>
          </v-list>
        </v-card>
      </v-navigation-drawer>
    </v-layout>
  </v-card>
</template>

<script setup lang="ts">
import { useAuthStore } from '@/stores/auth.store';
const authStore = useAuthStore();
const logout = () => {
  authStore.logout();
};
</script>

<script lang="ts">
export default {
  data: () => {
    return {
      drawer: false,
      open: ['Users'],
    };
  },
};
</script>
