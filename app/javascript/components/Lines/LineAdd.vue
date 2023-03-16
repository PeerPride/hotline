<script setup lang="ts">
import axios from 'axios';
import { Form, Field, ErrorMessage } from 'vee-validate';
import * as yup from 'yup';
import { ILineDetails } from '@/types/line';
import { showToast } from '@/utils/showToast';
</script>

<template>
  <article>
    <Form :validation-schema="lineSchema" @submit="onSubmit">
      <h1>Add Line</h1>
      <div class="mb-3">
        <label for="name" class="form-label">Name</label>
        <Field id="name" v-model="line.name" name="name" class="form-control" type="text" />
        <ErrorMessage name="name" />
      </div>
      <div class="mb-3">
        <label for="phone_number" class="form-label">Phone</label>
        <Field
          id="phone_number"
          v-model="line.number"
          name="number"
          class="form-control"
          type="tel"
        />
        <p class="form-text">
          Be sure to include the international calling code. For US/Canada numbers, 1-xxx-yyy-zzzz.
        </p>
        <ErrorMessage name="number" />
      </div>
      <button type="submit" class="btn btn-primary">Save</button>
    </Form>
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
};

const lineSchema = {
  name: yup.string().required().label('Name'),
  number: yup.string().required().label('Phone Number'),
};

const onSubmit = function (values: any) {
  axios
    .post('/api/v1/lines/', values)
    .then((result) => {
      showToast(result.data.data.attributes.name + ' updated', 'success');
    })
    .catch((err) => {
      switch (err.response.status) {
        case 401:
          showToast("You don't have permission to edit that line.", 'error');
          break;
        case 404:
          showToast('Line not found', 'error');
          break;
        case 500:
          showToast('Error: ' + err.response.data, 'error');
          break;
      }
    });
};
</script>
