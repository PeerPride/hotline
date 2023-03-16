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
  <h1 v-if="showTitle">Calls by Category</h1>
  <div class="row">
    <div class="col-sm-6">
      <v-text-field v-model="to" label="From" type="date" variant="underlined"></v-text-field>
    </div>
    <div class="col-sm-6">
      <v-text-field v-model="to" label="To" type="date" variant="underlined"></v-text-field>
    </div>
  </div>
  <div v-if="showCategories" class="row">
    <div v-for="category in categories" :key="category.name" class="col">
      <div class="form-check">
        <input
          :id="'category_' + category.id"
          v-model="category.value"
          class="form-check-input"
          type="checkbox"
        />
        <label :for="'category_' + category.id" class="form-check-label">
          {{ category.name }}
        </label>
      </div>
    </div>
  </div>
  <Bar v-if="loaded" id="my-chart-id" :options="chartOptions" :data="chartData" />
</template>

<script lang="ts">
ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale, Colors);

export default {
  props: {
    initialTitle: {
      type: String,
      default: 'Calls By Category',
    },
    showTitle: {
      type: Boolean,
      default: false,
    },
    defaultCategories: {
      type: Array,
      default: () => {
        return [];
      },
    },
    showCategories: {
      type: Boolean,
      default: false,
    },
  },
  data: () => ({
    loaded: false,
    since: DateTime.now().minus({ months: 1 }).toISODate(),
    to: DateTime.now().toISODate(),
    chartData: {} as ChartData<'bar', (number | [number, number] | null)[], unknown>,
    chartOptions: {
      responsive: true,
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
  },
  mounted() {
    axios.get('/api/v1/conversationcategories').then((response) => {
      this.categories = response.data.data.flatMap((el: any) => {
        const found = this.defaultCategories.filter((el2: any) => el2 == el.id);
        return { name: el.attributes.name, id: el.id, value: found };
      });
      this.getData();
    });
  },
  methods: {
    getData: function () {
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
          `/api/v1/conversations/by_category?since=${this.since}&to=${this.to}&=${catQueryString}`,
        )
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
  },
};
</script>
