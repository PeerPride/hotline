<script setup lang="ts">
import axios from 'axios';
import { IConversationDetails } from '@/types/conversation';
</script>

<template>
  <main>
    <div v-if="conversation.id">
      <p class="text-h5 text--primary">{{ conversation.contact.codename }}</p>
      <p class="font-weight-bold">{{ conversation.conversation_category.name }}</p>
      <p class="font-italic">
        on {{ $filters.dateToReadableDisplay(conversation.started_at) }} for
        {{ $filters.secondsToReadableDisplay(conversation.length) }}
      </p>
      <v-card v-if="conversation.notes.length" class="mt-4 mb-4">
        <v-card-title>Notes</v-card-title>
        <v-card-text
          ><p>{{ conversation.notes }}</p></v-card-text
        >
      </v-card>

      <v-card>
        <v-card-title>Tags</v-card-title>
        <v-card-item v-for="tg in conversation.tag_groups" :key="tg.id">
          <v-chip v-for="tag in tg.tags" :key="tag.tag_instance_id">{{ tag.tag }}</v-chip>
        </v-card-item>
      </v-card>
    </div>
  </main>
</template>
<script lang="ts">
export default {
  data: () => {
    return {
      conversation: {} as IConversationDetails,
      error: '' as string,
    };
  },
  mounted: function () {
    const id = this.$router.currentRoute.value.params.id;
    axios.get('/api/v1/conversations/' + id).then((response) => {
      this.conversation = response.data.data.attributes;
    });
  },
};
</script>

<style scoped>
@import 'datatables.net-bs5';
</style>
