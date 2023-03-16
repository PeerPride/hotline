import { TShowToast } from './toasts';

interface ComponentInternalInstance {
  $filters: any;
}
declare module '@vue/runtime-core' {
  interface ComponentCustomProperties {
    $showToast: TShowToast;
    $filters: any;
  }
}

export {};
