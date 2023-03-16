<script setup lang="ts">
import axios from 'axios';
import { ILineDetails } from '@/types/line';
import { showToast } from '@/utils/showToast';
</script>

<template>
  <article>
    <RouterLink
      v-if="line.id > 0"
      :to="{ name: 'LineEdit', params: { id: line.id } }"
      class="btn btn-outline-primary float-end"
      >Edit</RouterLink
    >
    <h1>
      {{ line.name }}: <small>{{ line.number }}</small>
    </h1>
    Active? {{ line.is_active ? 'Yes' : 'No' }}<br />
    Greeting Message: {{ line.phone_greeting_message }}<br />
    Record Calls? {{ line.record_calls ? 'Yes' : 'No' }}
    <span v-if="line.record_calls">
      {{
        line.recording_save_length
          ? ' and save for ' + line.recording_save_length + ' days'
          : ' and do not save'
      }}
    </span>
  </article>
</template>
<script lang="ts">
export default {
  data: () => {
    return {
      line: { id: 0 } as ILineDetails,
      lineid: 0,
      error: '' as string,
    };
  },
  mounted: function () {
    const id = this.$router.currentRoute.value.params.id;
    axios
      .get('/api/v1/lines/' + id)
      .then((line) => {
        this.line = line.data.data.attributes;
        this.lineid = this.line.id;
      })
      .catch((reason) => {
        switch (reason.response.status) {
          case 401:
            showToast("You don't have permission to view that line.", 'error');
            break;
          case 404:
            showToast('Line not found', 'error');
            break;
        }
      });
  },
};
</script>
