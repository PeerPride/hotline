<script setup lang="ts">
import { Bar } from 'vue-chartjs';
import {
  Chart as ChartJS,
  Title,
  Tooltip,
  Legend,
  BarElement,
  CategoryScale,
  LinearScale,
  ChartData,
  Colors,
} from 'chart.js';
import axios from 'axios';
import { DateTime } from 'luxon';
</script>
<template>
  <h1>Calls by Day</h1>
  <v-row>
    <v-text-field v-model="since" type="date" label="Start"></v-text-field>
    <v-text-field v-model="to" type="date" label="To"></v-text-field>
  </v-row>
  <Bar v-if="loaded" id="my-chart-id" :options="chartOptions" :data="chartData" />
</template>

<script lang="ts">
ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale, Colors);

export default {
  data: () => ({
    loaded: false,
    view: 'month',
    since: DateTime.now().minus({ months: 2 }).toISODate(),
    to: DateTime.now().toISODate(),
    chartData: {} as ChartData<'bar', (number | [number, number] | null)[], unknown>,
    chartOptions: {
      responsive: true,
    },
  }),
  watch: {
    since: function () {
      this.getData();
    },
    to: function () {
      this.getData();
    },
  },
  mounted() {
    this.getData();
  },
  methods: {
    getData: function () {
      axios
        .get('/api/v1/conversations/by_day?since=' + this.since + '&to=' + this.to)
        .then((result) => {
          this.chartData = {
            labels: result.data.map((el: any) => {
              return DateTime.fromISO(el.created_at).toLocaleString(DateTime.DATE_MED_WITH_WEEKDAY);
            }),
            datasets: [
              {
                label: 'Calls',
                data: result.data.map((el: any) => el.all_conversations),
              },
              {
                label: 'Unique Callers',
                data: result.data.map((el: any) => el.distinct_contacts),
              },
            ],
          };
          this.loaded = true;
        });
    },
    weekView: function () {
      this.view = 'week';
    },
  },
};
</script>
