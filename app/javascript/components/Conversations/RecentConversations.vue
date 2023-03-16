<script setup lang="ts">
import { useConversationStore } from '@/stores/conversation.store';
</script>

<template>
  <h1>Recent Conversations</h1>
  <v-hover v-for="convo in useConversationStore().finishedConversations" :key="convo.id">
    <template #default="{ isHovering }">
      <v-card :color="isHovering ? 'primary' : undefined">
        <v-card-text>
          <v-btn color="info" text="white" class="white--text float-right"
            ><RouterLink
              :to="{ name: 'ConversationView', params: { id: convo.id } }"
              class="white--text"
            >
              View
            </RouterLink></v-btn
          >
          <p class="text-h5 text--primary">{{ convo.attributes.contact.codename }}</p>
          <p class="font-weight-bold">{{ convo.attributes.conversation_category.name }}</p>
          <p class="font-italic">
            on {{ $filters.dateToReadableDisplay(convo.attributes.started_at) }} for
            {{ $filters.secondsToReadableDisplay(convo.attributes.length) }}
          </p>
          <p>{{ convo.attributes.notes }}</p>
        </v-card-text>
        <v-card-item v-for="tg in convo.attributes.tag_groups" :key="tg.id">
          <v-chip v-for="tag in tg.tags" :key="tag.tag_instance_id">{{ tag.tag }}</v-chip>
        </v-card-item>
      </v-card>
    </template>
  </v-hover>
</template>

<script lang="ts">
export default {};
</script>
