const Index = () => import('@/pages/panel/IndexPage.vue');

const routes = [
  {
    path: '/',
    name: 'index',
    components: {
      default: Index,
    },
  },
  {
    path: '/users',
    name: 'Users',
    component: () => import('@/components/Users/UserList.vue'),
  },
  {
    path: '/users/invite',
    name: 'UserInvite',
    component: () => import('@/components/Users/UserInvite.vue'),
  },
  {
    path: '/users/me',
    name: 'UserMe',
    component: () => import('@/components/Users/UserView.vue'),
  },
  {
    path: '/users/:id',
    name: 'UserView',
    component: () => import('@/components/Users/UserView.vue'),
  },
  {
    path: '/users/:id/edit',
    name: 'UserEdit',
    component: () => import('@/components/Users/UserEdit.vue'),
  },
  {
    path: '/lines',
    name: 'Lines',
    component: () => import('@/components/Lines/LineList.vue'),
  },
  {
    path: '/lines/add',
    name: 'LineAdd',
    component: () => import('@/components/Lines/LineAdd.vue'),
  },
  {
    path: '/lines/:id',
    name: 'LineView',
    component: () => import('@/components/Lines/LineView.vue'),
  },
  {
    path: '/lines/:id/edit',
    name: 'LineEdit',
    component: () => import('@/components/Lines/LineEdit.vue'),
  },
  {
    path: '/conversationcategories',
    name: 'ConversationCategories',
    component: () => import('@/components/ConversationCategories/ConversationCategoryList.vue'),
  },
  {
    path: '/conversationcategories/add',
    name: 'ConversationCategoryAdd',
    component: () => import('@/components/ConversationCategories/ConversationCategoryAdd.vue'),
  },
  {
    path: '/conversationcategories/:id',
    name: 'ConversationCategoryView',
    component: () => import('@/components/ConversationCategories/ConversationCategoryView.vue'),
  },
  {
    path: '/conversationcategories/:id/edit',
    name: 'ConversationCategoryEdit',
    component: () => import('@/components/ConversationCategories/ConversationCategoryEdit.vue'),
  },
  {
    path: '/reports/callsbyday',
    name: 'CallsByDay',
    component: () => import('@/components/Reports/CallsByDay.vue'),
  },
  {
    path: '/reports/callsbydow',
    name: 'CallsByDOW',
    component: () => import('@/components/Reports/CallsByDOW.vue'),
  },
  {
    path: '/reports/callsbytimeofday',
    name: 'CallsByTimeOfDay',
    component: () => import('@/components/Reports/CallsByTimeOfDay.vue'),
  },
  {
    path: '/tagcategories',
    name: 'TagCategories',
    component: () => import('@/components/TagCategories/TagCategoryList.vue'),
  },
  {
    path: '/tagcategories/add',
    name: 'TagCategoryAdd',
    component: () => import('@/components/TagCategories/TagCategoryAdd.vue'),
  },
  {
    path: '/tagcategories/:id',
    name: 'TagCategoryView',
    component: () => import('@/components/TagCategories/TagCategoryView.vue'),
  },
  {
    path: '/tagcategories/:id/edit',
    name: 'TagCategoryEdit',
    component: () => import('@/components/TagCategories/TagCategoryEdit.vue'),
  },
  {
    path: '/conversations',
    name: 'Conversations',
    component: () => import('@/components/Conversations/ConversationList.vue'),
  },
  {
    path: '/conversations/:id',
    name: 'ConversationView',
    component: () => import('@/components/Conversations/ConversationView.vue'),
  },
  {
    path: '/languages',
    name: 'Languages',
    component: () => import('@/components/Languages/LanguagesList.vue'),
  },
  {
    path: '/languages/add',
    name: 'LanguageAdd',
    component: () => import('@/components/Languages/LanguageAdd.vue'),
  },
  {
    path: '/languages/:id',
    name: 'LanguageView',
    component: () => import('@/components/Languages/LanguageView.vue'),
  },
  {
    path: '/languages/:id/edit',
    name: 'LanguageEdit',
    component: () => import('@/components/Languages/LanguageEdit.vue'),
  },
];

export default routes;
