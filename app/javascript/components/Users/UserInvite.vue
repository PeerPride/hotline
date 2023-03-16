<template>
  <article>
    <v-form @submit="onSubmit">
      <h1>Invite User</h1>
      <div class="mb-3">
        <div>
          <v-text-field v-model="name" label="Name" name="name"></v-text-field>
        </div>
      </div>
      <div class="mb-3">
        <v-text-field
          v-model="email"
          label="Email"
          name="email"
          required
          type="email"
        ></v-text-field>
      </div>
      <div class="mb-3">
        <v-text-field
          v-model="phone_number"
          label="Phone Number"
          name="phone_number"
          required
          type="tel"
        ></v-text-field>
        <p class="form-text">
          Be sure to include the international calling code. For US/Canada numbers, 1-xxx-yyy-zzzz.
        </p>
        <ErrorMessage name="phone_number" />
      </div>
      <v-btn type="submit" color="info">Send Invite</v-btn>
      <p class="form-text">
        The invitee will receive an email with instructions to finish their registration.
      </p>
    </v-form>
  </article>
</template>
<script setup lang="ts">
import { Form, Field, ErrorMessage } from 'vee-validate';
import axios from 'axios';
import * as yup from 'yup';
import { showToast } from '@/utils/showToast';

const newUserSchema = {
  email: yup.string().required().email().label('Email'),
  name: yup.string().required().label('Name'),
  phone_number: yup.string().required().label('Phone Number'),
};

const onSubmit = function (values: object) {
  axios
    .post('/api/v1/users/invite', values)
    .then((result) => {
      console.log(result);
    })
    .catch((err) => {
      showToast(err.response.data, 'error');
    });
};
</script>
<script lang="ts">
export default {
  data: () => {
    return {
      name: '',
      phone_number: '',
      email: '',
    };
  },
};
</script>
