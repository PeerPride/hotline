<script setup lang="ts">
import axios from 'axios';
import { Device } from '@twilio/voice-sdk';
import MainMenu from './MainMenu.vue';
import CurrentlyOnCall from '@/components/CurrentlyOnCall.vue';
//import Toast from '@/components/Toast/Index.vue';
</script>

<template>
  <MainMenu />
  <Toast />
  <v-container class="bg-surface-variant" style="z-index: 999; margin-top: 60px">
    <v-row>
      <v-col sm="2"><CurrentlyOnCall /></v-col>
      <v-col sm="10"><router-view /></v-col>
    </v-row>
  </v-container>
  <button v-if="twilio_active" @click="makeCall()">call</button>
</template>

<script lang="ts">
export default {
  data: () => {
    return {
      twilio_jwt: '',
      twilio_device: {} as Device,
      twilio_active: false,
    };
  },
  mounted() {
    //axios.get('/api/v1/tokens/get').then((result) => {
    //this.twilio_jwt = result.data.token;
    // this.twilio_device = new Device(this.twilio_jwt, {
    //   closeProtection: true,
    // });
    // this.twilio_device.on('registered', () => {
    //   this.twilio_active = true;
    // });
    // this.twilio_device.on('unregistered', () => {
    //   this.twilio_active = false;
    // });
    // this.twilio_device.on('tokenWillExpire', (device) => {
    //   axios.get('/api/v1/tokens/get').then((result) => {
    //     device.updateToken(result.data.token);
    //   });
    // });
    // this.twilio_device.on('incoming', (call) => {
    //   console.log(call);
    // });
    // this.twilio_device.on('error', (twilioError, call) => {
    //   console.log('An error has occurred: ', twilioError, call);
    // });
    //});
  },
  methods: {
    async makeCall() {
      const call = await this.twilio_device.connect({
        params: {
          To: '+12030000000',
        },
      });
      console.log(call);
    },
  },
};
</script>
