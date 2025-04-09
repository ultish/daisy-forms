import Component from '@glimmer/component';
import FormRowComponent from './row';
import { hash } from '@ember/helper';

interface Signature {
  Blocks: {
    header: [];
    description: [];
    rows: [];
  };
}
export default class FormGroupComponent extends Component<Signature> {
  row = FormRowComponent;

  <template>
    <div class="prose">
      <h3 class="">
        {{yield to="header"}}
      </h3>
      <p class="text-sm mt-1 text-base-content/50">
        {{yield to="description"}}
      </p>
    </div>
    <div class="col-span-2 grid grid-cols-6 gap-4" ...attributes>
      {{yield (hash row=FormRowComponent) to="rows"}}
    </div>
  </template>
}
