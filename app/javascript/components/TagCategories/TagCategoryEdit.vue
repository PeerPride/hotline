<script setup lang="ts">
import axios from 'axios';
import * as yup from 'yup';
import { showToast } from '@/utils/showToast';
import { ITagCategoryDetails } from '@/types/tagcategory';
import { ITagDetails } from '@/types/tag';
</script>

<template>
  <article>
    <v-form class="mb-8" @submit.prevent="onSubmit">
      <h1>Tag Category: {{ category.name }}</h1>
      <Field v-model="category.id" type="hidden" name="id"></Field>

      <v-text-field v-model="category.name" label="Name" name="name"></v-text-field>

      <v-textarea
        v-model="category.description"
        label="Description"
        name="description"
      ></v-textarea>

      <v-switch v-model="category.is_active" label="Active"></v-switch>

      <v-btn type="submit">Save</v-btn>
    </v-form>
    <hr />
    <h2>Tags</h2>
    <v-form @submit.prevent="addNewTag">
      <v-table class="table table-condensed table-striped table-hover">
        <thead>
          <tr>
            <th>Tag</th>
            <th>Description</th>
            <th>Status</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="tag in category.tags" :key="tag.id">
            <td>{{ tag.name }}</td>
            <td>{{ tag.description }}</td>
            <td>{{ tag.is_active ? 'Active' : 'Inactive' }}</td>
            <td></td>
          </tr>
        </tbody>
        <tfoot>
          <tr>
            <td>
              <Field v-model="category.id" type="hidden" name="tag_category_id" />
              <v-text-field v-model="newTag.name" label="Name" name="name"></v-text-field>
            </td>
            <td>
              <v-text-field
                v-model="newTag.description"
                label="Description"
                name="description"
              ></v-text-field>
            </td>
            <td colspan="2">
              <v-btn type="submit">Create Tag</v-btn>
            </td>
          </tr>
        </tfoot>
      </v-table>
    </v-form>
  </article>
</template>
<script lang="ts">
export default {
  data: () => {
    return {
      category: { id: 0 } as ITagCategoryDetails,
      newTag: { id: 0, name: '' } as ITagDetails,
      tagCategorySchema: yup.object().shape({
        name: yup.string().required().label('Name'),
      }),
      tagSchema: yup.object().shape({
        name: yup.string().required().label('Name'),
      }),
    };
  },
  mounted: function () {
    const id = this.$router.currentRoute.value.params.id;
    axios
      .get('/api/v1/tagcategories/' + id)
      .then((category) => {
        this.category = category.data.data.attributes;
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
    addNewTag() {
      this.tagSchema.validate(this.newTag, { abortEarly: false }).then(() => {
        this.newTag.tag_category_id = this.category.id;
        axios.post('/api/v1/tags', { tag: this.newTag }).then((result) => {
          this.category.tags.push(result.data.data.attributes);
          this.newTag.name = '';
          this.newTag.description = '';
        });
      });
    },
    onSubmit: function () {
      this.tagCategorySchema.validate(this.category, { abortEarly: false }).then(() => {
        axios
          .put('/api/v1/tagcategories/' + this.category.id, {
            tagcategory: this.category,
          })
          .then((result) => {
            showToast(result.data.data.attributes.name + ' updated', 'success');
          });
      });
    },
  },
};
</script>
