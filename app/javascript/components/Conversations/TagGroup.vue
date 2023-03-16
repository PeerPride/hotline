<script setup lang="ts">
import axios from 'axios';
import { ITagGroup } from '@/types/taggroup';
import { ITagCategory } from '@/types/tagcategory';
import { ITagDetails } from '@/types/tag';
</script>

<template>
  <article class="card">
    <div class="card-body">
      <v-autocomplete
        v-model="taggroup.tags"
        :items="items"
        chips
        closable-chips
        color="blue-grey-lighten-2"
        item-title="name"
        item-value="value"
        label="Select"
        multiple
      >
        <template #chip="{ props, item }">
          <v-chip v-bind="props" :prepend-avatar="item.name" :text="item.name"></v-chip>
        </template>

        <template #item="{ props, item }">
          <v-list-item
            v-bind="props"
            :prepend-avatar="item?.raw?.avatar"
            :title="item?.raw?.name"
            :subtitle="item?.raw?.category"
          ></v-list-item>
        </template>
      </v-autocomplete>
      <hr />
    </div>
  </article>
</template>

<script lang="ts">
export default {
  props: ['group'],
  data() {
    return {
      items: [{}],
      taggroup: this.group as ITagGroup,
    };
  },
  mounted: function () {
    axios.get('/api/v1/tagcategories/all_with_tags').then((result) => {
      this.items = [];
      result.data.data.forEach((category: ITagCategory) => {
        category.attributes.tags.forEach((tag: ITagDetails) => {
          this.items.push({
            category: category.attributes.name,
            name: tag.name,
            value: tag.id.toString(),
          });
        });
      });
    });
  },
  methods: {
    here(value: { name: string; value: string }) {
      if (!this.taggroup.tags) {
        this.taggroup.tags = [];
      }
      this.taggroup.tags.push(value);
    },
  },
};
</script>
