import Component from '@glimmer/component';

export interface InputFieldSignature {
  Args: {
    title: string;
    submitted?: boolean;
    type?: string;
    required?: boolean;
    placeholder?: string;
  };

  Blocks: {
    validatorHint: [];
  };
}
export default class InputField extends Component<InputFieldSignature> {
  get type() {
    return this.args.type ?? 'text';
  }

  get required() {
    return this.args.required === true;
  }

  <template>
    <fieldset class="fieldset form-control" ...attributes>
      <legend class="fieldset-legend">{{@title}}</legend>
      <label class="input w-full">
        <input
          type={{this.type}}
          class="validator"
          required={{this.required}}
          placeholder={{@placeholder}}
        />
        {{#if this.required}}
          <span class="label">Required</span>
        {{/if}}

      </label>
      <div class="validator-hint fieldset-label hidden">
        {{yield to="validatorHint"}}
      </div>
    </fieldset>
  </template>
}
