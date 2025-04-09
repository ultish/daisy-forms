import Component from '@glimmer/component';
// import type { TOC } from '@ember/component/template-only';
import FormGroupComponent, { type FormGroupComponentSignature } from './group';
import { hash } from '@ember/helper';
import type { ComponentLike } from '@glint/template';
import { on } from '@ember/modifier';
import { action } from '@ember/object';
import { tracked } from '@glimmer/tracking';

interface FormSignature {
  Args: {
    onSubmit?: (e: Event) => void;
  };
  Blocks: {
    form: [
      {
        group: ComponentLike<FormGroupComponentSignature>;
      },
    ];
    buttonBar: [
      {
        handleSubmit: (e: Event) => void;
      },
    ];
  };
}
export default class FormComponent extends Component<FormSignature> {
  @tracked submitted = false;

  @action
  handleSubmit(e: Event) {
    this.args.onSubmit?.(e);
    this.submitted = true;
  }

  <template>
    <form {{on "submit" this.handleSubmit}} class="hellop">
      <div
        class="border-b-[1px] pb-8 mb-8 border-base-content/ grid grid-cols-3 gap-4"
        ...attributes
      >
        {{yield
          (hash group=(component FormGroupComponent submitted=this.submitted))
          to="form"
        }}
      </div>
      <div class="mt-6 flex items-center justify-end gap-2">
        {{#if (has-block "buttonBar")}}
          {{yield (hash handleSubmit=this.handleSubmit) to="buttonBar"}}
        {{else}}
          {{! can provide a default button for you }}
          <button type="submit" class="btn btn-sm btn-primary">
            Save
          </button>
        {{/if}}
      </div>
    </form>
  </template>
}
