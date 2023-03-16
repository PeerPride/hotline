<script setup lang="ts">
import axios from 'axios';
import { Form, Field, ErrorMessage } from 'vee-validate';
import * as yup from 'yup';
import TagGroup from './TagGroup.vue';
import { IConversation, IConversationDetails } from '@/types/conversation';
import { showToast } from '@/utils/showToast';
import { IConversationCategory, IConversationCategoryDetails } from '@/types/conversationcategory';
import { useConversationStore } from '@/stores/conversation.store';
import { ITagGroup } from '@/types/taggroup';
</script>

<template>
  <article class="mt-2">
    <h2>Log a Conversation</h2>
    <v-form @submit.prevent="onSubmit">
      <div class="mb-3">
        <div class="row">
          <div class="col-xs-12 col-sm-8">
            <v-select
              v-model="conversation.id"
              label="Conversation"
              :items="loggableConversations"
              item-title="title"
              item-value="value"
              :rules="conversationIDRules"
            ></v-select>
          </div>
        </div>
      </div>
      <div v-if="formShouldShow">
        <div class="mb-3">
          <div class="row">
            <div class="col-xs-12 col-sm-8">
              <v-select
                v-model="conversation.conversation_category_id"
                label="Category"
                :items="selectableCategories"
                item-title="title"
                item-value="value"
                :rules="conversationCategoryRules"
              ></v-select>
            </div>
          </div>
        </div>
        <div class="mb-3">
          <div class="row">
            <div class="col-xs-12 col-sm-8">
              <label for="notes" class="form-label">Your Notes</label>
              <v-textarea
                id="notes"
                v-model="conversation.notes"
                name="notes"
                class="form-control"
                :rules="conversationNotesRules"
              ></v-textarea>
            </div>
          </div>
        </div>

        <div class="h3">Tags</div>
        <v-btn type="button" class="btn btn-outline-secondary mb-5" @click.prevent="addTagGroup">
          Add Group
        </v-btn>
        <div class="card-group pb-5">
          <tag-group
            v-for="group in conversation.tag_groups"
            :key="group.id"
            :group="group"
          ></tag-group>
        </div>

        <v-btn type="submit" class="btn btn-primary">Save</v-btn>
      </div>
    </v-form>
  </article>
</template>
<script lang="ts">
export default {
  components: { TagGroup },
  data() {
    return {
      conversation: {
        tag_groups: [] as ITagGroup[],
      } as IConversationDetails,
      categories: [] as IConversationCategory[],
      unloggedConversations: useConversationStore().unloggedConversations,
      conversationNotesRules: [
        (value: string) => {
          if (value?.length > 3) {
            return true;
          }
          return 'Notes must be more than 3 characters.';
        },
      ],
      conversationCategoryRules: [
        (value: string) => {
          if (value?.length && value !== undefined) {
            return true;
          }
          return 'Select a category';
        },
      ],
      conversationIDRules: [
        (value: string) => {
          if (value?.length && value !== undefined) {
            return true;
          }
          return 'Select a conversation.';
        },
      ],
    };
  },
  computed: {
    formShouldShow() {
      return this.conversation.id > 0;
    },
    loggableConversations() {
      const convos = this.unloggedConversations.map((item: IConversation) => {
        return {
          title: `${item.attributes.contact.codename} on ${this.$filters.dateToReadableDisplay(
            item.attributes.started_at,
          )}`,
          value: item.id,
        };
      });

      return [...[{ title: 'Select', value: 0 }], ...convos];
    },
    selectableCategories() {
      return this.categories.map((item: any) => {
        return { title: item.attributes.name, value: item.id };
      });
    },
  },
  created: function () {
    useConversationStore().init();
  },
  mounted: function () {
    axios.get('/api/v1/conversationcategories').then((response) => {
      this.categories = response.data.data.filter((cat: IConversationCategory) => {
        return cat.attributes.is_active === true;
      });
    });
    //TODO: WTF, fix this.
    window.setTimeout(() => {
      this.unloggedConversations = useConversationStore().unloggedConversations;
    }, 500);
  },
  methods: {
    addTagGroup: function () {
      this.conversation.tag_groups.push({} as ITagGroup);
    },
    onSubmit: function () {
      axios
        .put('/api/v1/conversations/' + this.conversation.id, { conversation: this.conversation })
        .then((result) => {
          useConversationStore().prependItem(result.data.data);
          showToast(result.data.data.attributes.name + ' updated', 'success');
          this.conversation.id = 0;
        })
        .catch((err) => {
          switch (err.response.status) {
            case 401:
              showToast("You don't have permission to edit that conversation.", 'error');
              break;
            case 404:
              showToast('Conversation not found', 'error');
              break;
            case 500:
              showToast('Error: ' + err.response.data, 'error');
              break;
          }
        });
    },
  },
};
</script>
