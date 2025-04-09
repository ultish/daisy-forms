import Component from '@glimmer/component';
// import type { TOC } from '@ember/component/template-only';
// import FormGroupComponent from './group';
import { hash } from '@ember/helper';
// import type { ComponentLike } from '@glint/template';

import FormFieldsetInputComponent, {
  type FormFieldsetInputComponentSignature,
} from './input';

import FormFieldsetSelectComponent, {
  type FormFieldsetSelectComponentSignature,
} from './select';

import FormFieldsetCalendarComponent, {
  type FormFieldsetCalendarComponentSignature,
} from './calendar';

import type { ComponentLike } from '@glint/template';
interface Signature {
  Args: {
    title: string;
    colSpan?: number;
  };
  Blocks: {
    field: [
      {
        input: ComponentLike<FormFieldsetInputComponentSignature>;
        select: ComponentLike<FormFieldsetSelectComponentSignature>;
        multiSelect: ComponentLike<FormFieldsetSelectComponentSignature>;
        calendar: ComponentLike<FormFieldsetCalendarComponentSignature>;
      },
    ];
    validatorHint: [];
  };
}
export default class FormFieldSetComponent extends Component<Signature> {
  get test() {
    return '';
  }

  get colSpan() {
    return `col-span-${this.args.colSpan ?? 4}`;
  }

  get inputComponent() {
    return FormFieldsetInputComponent;
  }

  <template>
    <style>
      fieldset .validator-hint {
        visibility: hidden;
      }
      fieldset:has(.validator:user-valid) label.input,
      fieldset:has(.validator.custom-valid) label.input {
        &,
        &:focus,
        &:checked,
        &[aria-checked="true"],
        &:focus-within {
          --input-color: var(--color-success);
        }
      }

      fieldset:has(.validator:user-invalid) label.input,
      fieldset:has(.validator:user-invalid) .validator-hint,
      fieldset:has(.validator.custom-invalid) label.input,
      fieldset:has(.validator.custom-invalid) .validator-hint {
        color: var(--color-error);
        --input-color: var(--color-error);
      }
      fieldset:has(.validator:user-invalid) .validator-hint,
      fieldset:has(.validator.custom-invalid) .validator-hint {
        visibility: visible;
        display: block;
        color: var(--color-error);
      }
    </style>

    <fieldset class="fieldset form-control {{this.colSpan}}" ...attributes>
      <legend class="fieldset-legend">{{@title}}</legend>
      <label class="input w-full">
        {{yield
          (hash
            input=this.inputComponent
            select=FormFieldsetSelectComponent
            multiSelect=FormFieldsetSelectComponent
            calendar=FormFieldsetCalendarComponent
          )
          to="field"
        }}
      </label>
      <div class="validator-hint fieldset-label hidden">
        {{yield to="validatorHint"}}
      </div>
    </fieldset>
  </template>
}
