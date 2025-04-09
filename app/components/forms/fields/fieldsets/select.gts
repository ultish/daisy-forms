import Component from '@glimmer/component';

export interface FormFieldsetSelectComponentSignature {
  Args: {
    type?: string;
    required?: boolean;
    placeholder?: string;
  };
}
export default class FormFieldsetSelectComponent extends Component<FormFieldsetSelectComponentSignature> {
  get type() {
    return this.args.type ?? 'text';
  }

  get required() {
    return this.args.required === true;
  }

  <template>chioces.js here</template>
}
