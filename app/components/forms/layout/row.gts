import Component from '@glimmer/component';

interface Signature {
  Args: {};
  Blocks: {
    default: [];
  };
}
export default class FormRowComponent extends Component<Signature> {
  get test() {
    return '';
  }

  <template>{{yield}}</template>
}
