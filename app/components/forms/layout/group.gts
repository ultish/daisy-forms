import Component from '@glimmer/component';
import FormRowComponent from './row';
import { hash } from '@ember/helper';
// import { hash } from '@ember/helper';

export interface FormGroupComponentSignature {
  // Args: {
  //   submitted?: boolean;
  // };
  Args: null;
  Blocks: {
    header: [];
    description: [];
    rows: [
      {
        submitted: boolean;
      },
    ];
  };
}
export default class FormGroupComponent extends Component<FormGroupComponentSignature> {
  row = FormRowComponent;

  <template>
    <div class="prose">
      <h3 class="">
        {{yield to="header"}}
        {{@submitted}}
      </h3>
      <p class="text-sm mt-1 text-base-content/50">
        {{yield to="description"}}
      </p>
    </div>
    <div class="col-span-2 grid grid-cols-6 gap-4 pb-8" ...attributes>
      {{yield (hash submitted=@submitted) to="rows"}}
    </div>
  </template>
}
