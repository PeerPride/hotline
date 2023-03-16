<script setup lang="ts">
import axios from 'axios';
import DataTable from 'datatables.net-vue3';
import DataTablesLib from 'datatables.net';
import DataTableBs5 from 'datatables.net-bs5';
import { DateTime } from 'luxon';
import { IConversationDetails, IConversation } from '@/types/conversation';
</script>

<template>
  <h1>Conversations</h1>
  <main>
    <DataTable
      ref="table"
      class="display table"
      :columns="[
        { data: 'started_at' },
        { data: 'contact.codename' },
        { data: 'length' },
        { data: 'conversation_category.name' },
      ]"
      as="v-table"
      :data="conversations"
      :options="{ select: true }"
    />
    <table v-if="conversations.length > 9999990" class="table table-condensed table-striped">
      <thead>
        <tr>
          <th>Date</th>
          <th>Caller</th>
          <th></th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="convo in conversations" :key="convo.id">
          <td></td>
          <td></td>
          <td>
            <div class="btn-group" role="group" aria-label="Basic example">
              <v-btn
                ><RouterLink
                  :to="{ name: 'ConversationView', params: { id: convo.id } }"
                  class="btn btn-secondary"
                >
                  View
                </RouterLink></v-btn
              >
            </div>
          </td>
        </tr>
      </tbody>
    </table>
  </main>
</template>
<script lang="ts">
DataTable.use(DataTablesLib, DataTableBs5);

export default {
  data: () => {
    return {
      conversations: [] as IConversationDetails[],
      error: '' as string,
    };
  },
  mounted: function () {
    axios.get('/api/v1/conversations').then((response) => {
      this.conversations = [];
      response.data.data.forEach((el: IConversation) => {
        const dt = DateTime.fromISO(el.attributes.started_at);
        el.attributes.started_at = dt.toLocaleString(DateTime.DATETIME_MED);
        this.conversations.push(el.attributes);
        if (!el.attributes.conversation_category) {
          el.attributes.conversation_category = { name: '' };
        }
        const value = el.attributes.length;
        if (value == null) {
          return '';
        }
        if (value < 60) {
          el.attributes.length = value + ' seconds';
        } else if (value < 3600) {
          el.attributes.length = Math.floor(value / 60) + ' minutes';
        } else {
          const hours = Math.floor(value / 3600);
          const minutes = Math.floor(Math.floor(value - hours * 3600) / 60);
          el.attributes.length = Math.floor(value / 3600) + ' hour(s) ' + minutes + ' minutes';
        }
      });
    });
  },
};
</script>

<style scoped>
@import 'datatables.net-bs5';
</style>
