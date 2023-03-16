<script setup lang="ts">
import axios from 'axios';
import * as yup from 'yup';
import { ILineDetails } from '@/types/line';
import { showToast } from '@/utils/showToast';
</script>

<template>
  <article>
    <v-form @submit.prevent="onSubmit">
      <h1>{{ linename }}</h1>
      <Field v-model="line.id" type="hidden" name="id"></Field>
      <div>
        <v-text-field v-model="line.name" label="Name" name="name"></v-text-field>
        <v-alert v-if="errors.name" type="error">{{ errors.name }}</v-alert>
      </div>
      <div>
        <v-text-field v-model="line.number" label="Phone" name="number"></v-text-field>
        <div class="text-caption">
          Be sure to include the international calling code. For US/Canada numbers, 1-xxx-yyy-zzzz.
        </div>
        <v-alert v-if="errors.number" type="error">{{ errors.number }}</v-alert>
      </div>
      <v-row>
        <v-col cols="12">
          <v-switch v-model="line.accepts_phone_calls" label="Accepts Phone Calls?"></v-switch>
        </v-col>
        <v-col v-if="line.accepts_phone_calls">
          <v-card variant="outlined">
            <v-card-item>
              <v-switch v-model="line.record_calls" label="Record Calls?"></v-switch>
            </v-card-item>
            <v-card-item v-if="line.record_calls">
              <v-text-field
                v-model="line.recording_save_length"
                label="Save Recordings For... days"
                name="recording_save_length"
              ></v-text-field>
              <v-alert v-if="errors.recording_save_length" type="error">{{
                errors.recording_save_length
              }}</v-alert>
            </v-card-item>
            <v-card-item>
              <v-textarea
                v-model="line.phone_greeting_message"
                label="Greeting Message"
              ></v-textarea>
            </v-card-item>

            <v-card-item>
              <v-switch v-model="line.accepts_voicemails" label="Accept Voicemails?"></v-switch>
            </v-card-item>

            <v-card-item v-if="line.accepts_voicemails">
              <v-textarea v-model="line.voicemail_greeting" label="Voicemail Greeting"></v-textarea>
            </v-card-item>
          </v-card>
        </v-col>
      </v-row>
      <v-row>
        <v-col>
          <v-switch v-model="line.accepts_text_messages" label="Accepts Texts?"></v-switch>
          <v-col v-if="line.accepts_text_messages">
            <v-card variant="outlined">
              <v-card-item>
                <v-textarea
                  v-model="line.no_operators_text_message"
                  label="No operators available response"
                ></v-textarea>
              </v-card-item>
            </v-card>
          </v-col>
        </v-col>
      </v-row>
      <v-btn type="submit">Save</v-btn>
    </v-form>
  </article>
</template>
<script lang="ts">
export default {
  data: () => {
    return {
      lineSchema: yup.object().shape({
        name: yup.string().required().label('Name'),
        number: yup.string().required().label('Phone Number'),
        recording_save_length: yup
          .number()
          .required()
          .positive()
          .integer()
          .label('Save For...')
          .typeError('Must be a number'),
      }),
      errors: {
        name: '',
        number: '',
        recording_save_length: '',
      },
      line: { id: 0 } as ILineDetails,
      linename: '',
    };
  },
  mounted: function () {
    const id = this.$router.currentRoute.value.params.id;
    axios
      .get('/api/v1/lines/' + id)
      .then((line) => {
        this.line = line.data.data.attributes;
        this.linename = line.data.data.attributes.name;
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
  methods: {
    resetErrors: function () {
      this.errors = {
        name: '',
        number: '',
        recording_save_length: '',
      };
    },
    onSubmit: function () {
      this.lineSchema
        .validate(this.line, { abortEarly: false })
        .then(() => {
          this.resetErrors();
          axios
            .put('/api/v1/lines/' + this.line.id, { line: this.line })
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
        })
        .catch((err) => {
          err.inner.forEach(
            (error: { message: string; path: 'name' | 'number' | 'recording_save_length' }) => {
              this.errors[error.path] = error.message;
            },
          );
        });
    },
  },
};
</script>
