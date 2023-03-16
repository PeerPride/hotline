import { defineStore } from 'pinia';
import axios from 'axios';
import { IConversation } from '@/types/conversation';

export const useConversationStore = defineStore('conversations', {
  state: () => ({
    conversations: [] as IConversation[],
    unlogged: [] as IConversation[],
  }),
  actions: {
    init() {
      axios.get('/api/v1/conversations/recent').then((response) => {
        this.conversations = response.data.data;
      });
      axios.get('/api/v1/conversations/unlogged').then((response) => {
        this.unlogged = response.data.data;
      });
    },
    prependItem(item: IConversation) {
      this.conversations = [item, ...this.conversations];
    },
  },
  getters: {
    allConversations(state) {
      return state.conversations;
    },
    finishedConversations(state) {
      return state.conversations.filter((el, i) => {
        return i < 20 && el.attributes.status == 'Finished';
      });
    },
    unloggedConversations(state) {
      return state.unlogged;
    },
  },
});
