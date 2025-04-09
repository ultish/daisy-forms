import Component from '@glimmer/component';

interface Signature {
  Blocks: {
    default: [];
  };
}
export default class FormRowComponent extends Component<Signature> {
  get test() {
    return '';
  }

  <template>
    <div class="pb-8">{{yield}}</div>
  </template>
}
