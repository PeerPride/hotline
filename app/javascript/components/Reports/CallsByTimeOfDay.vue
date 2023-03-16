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
  <h1>Calls by Time of Day</h1>
  <v-row>
    <v-text-field v-model="since" type="date" label="Start"></v-text-field>
    <v-text-field v-model="to" type="date" label="To"></v-text-field>
  </v-row>
  <v-row>
    <v-col>
      <v-checkbox v-model="daysofweek.Monday" label="Mon"></v-checkbox>
    </v-col>
    <v-col>
      <v-checkbox v-model="daysofweek.Tuesday" label="Tues"></v-checkbox>
    </v-col>
    <v-col>
      <v-checkbox v-model="daysofweek.Wednesday" label="Weds"></v-checkbox>
    </v-col>
    <v-col>
      <v-checkbox v-model="daysofweek.Thurday" label="Thurs"></v-checkbox>
    </v-col>
    <v-col>
      <v-checkbox v-model="daysofweek.Friday" label="Fri"></v-checkbox>
    </v-col>
    <v-col>
      <v-checkbox v-model="daysofweek.Saturday" label="Sat"></v-checkbox>
    </v-col>
    <v-col>
      <v-checkbox v-model="daysofweek.Sunday" label="Sun"></v-checkbox>
    </v-col>
  </v-row>
  <v-row>
    <v-col v-for="category in categories" :key="category.name" class="col">
      <v-checkbox v-model="category.value" :label="category.name"></v-checkbox>
    </v-col>
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
    daysofweek: {
      Monday: true,
      Tuesday: true,
      Wednesday: true,
      Thurday: true,
      Friday: true,
      Saturday: true,
      Sunday: true,
    },
    categories: [{} as { name: ''; value: true; id: 0 }],
  }),
  watch: {
    since: function () {
      this.getData();
    },
    to: function () {
      this.getData();
    },
    daysofweek: {
      handler() {
        this.getData();
      },
      deep: true,
    },
    categories: {
      handler() {
        this.getData();
      },
      deep: true,
    },
  },
  mounted() {
    axios.get('/api/v1/conversationcategories').then((response) => {
      this.categories = response.data.data.flatMap((el: any) => {
        return { name: el.attributes.name, id: el.id, value: true };
      });
      this.getData();
    });
  },
  methods: {
    getData: function () {
      const dowQueryString = Object.keys(this.daysofweek)
        .flatMap((i: string, j) => {
          return (
            'dow[' + (j + 1) + ']=' + (this.daysofweek[i as keyof typeof this.daysofweek] ? 1 : 0)
          );
        })
        .join('&');
      const catQueryString = this.categories
        .filter((cat) => {
          return cat.value;
        })
        .flatMap((i: any) => {
          return 'cat[' + i.id + ']=' + (i.value ? 1 : 0);
        })
        .join('&');
      axios
        .get(
          `/api/v1/conversations/by_time_of_day?since=${this.since}&to=${this.to}&${dowQueryString}&${catQueryString}`,
        )
        .then((result) => {
          this.chartData = {
            labels: result.data.map((el: any) => {
              return el.period_label;
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
  },
};
</script>
