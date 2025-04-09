import Component from '@glimmer/component';

export interface FormFieldsetInputComponentSignature {
  Args: {
    type?: string;
    required?: boolean;
    placeholder?: string;
  };
}
export default class FormFieldsetInputComponent extends Component<FormFieldsetInputComponentSignature> {
  get type() {
    return this.args.type ?? 'text';
  }

  get required() {
    return this.args.required === true;
  }

  <template>
    <input
      type={{this.type}}
      class="validator"
      required={{this.required}}
      placeholder={{@placeholder}}
      ...attributes
    />
    {{#if this.required}}
      <span class="label">Required</span>
    {{/if}}
  </template>
}
