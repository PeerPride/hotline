import { Component, createApp } from 'vue';
import { Router } from 'vue-router';
import { VueQueryPlugin } from 'vue-query';
import { DateTime } from 'luxon';
import { createVuetify } from 'vuetify';
// eslint-disable-next-line import/no-unresolved
import * as components from 'vuetify/components';
// eslint-disable-next-line import/no-unresolved
import * as directives from 'vuetify/directives';
// eslint-disable-next-line import/no-unresolved
import 'vuetify/styles';
import '@mdi/font/css/materialdesignicons.css'; // Ensure you are using css-loader
// eslint-disable-next-line import/no-unresolved
import { aliases, mdi } from 'vuetify/iconsets/mdi';
import { globalProperties } from './globalProperties';
import { pinia } from '@/stores';
import { setHTTPHeader } from '@/services/http.service';
import AuthService from '@/services/auth.service';

const token = AuthService.getToken();

if (token) {
  setHTTPHeader({ Authorization: token });
}

export const setupEntryPoint = (rootComponent: Component, router: Router) => {
  const vuetify = createVuetify({
    components,
    directives,
    icons: {
      defaultSet: 'mdi',
      aliases,
      sets: { mdi },
    },
  });
  const app = createApp(rootComponent).use(vuetify);

  app.use(router);
  app.use(pinia);
  app.use(VueQueryPlugin);
  app.config.globalProperties = { ...app.config.globalProperties, ...globalProperties };

  app.config.globalProperties.$filters = {
    secondsToReadableDisplay(value: any): string {
      if (value < 60) {
        return value + ' seconds';
      } else if (value < 3600) {
        return Math.floor(value / 60) + ' minutes';
      } else {
        const hours = Math.floor(value / 3600);
        const minutes = Math.floor(Math.floor(value - hours * 3600) / 60);
        return Math.floor(value / 3600) + ' hour(s) ' + minutes + ' minutes';
      }
    },
    dateToReadableDisplay(value: any): string {
      const dt = DateTime.fromISO(value);
      if (!dt.isValid) {
        return '';
      }
      return dt.toLocaleString(DateTime.DATETIME_MED);
    },
  };

  router.isReady().then(() => app.mount('#app'));
};
