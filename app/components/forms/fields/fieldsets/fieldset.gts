import Component from '@glimmer/component';
// import type { TOC } from '@ember/component/template-only';
// import FormGroupComponent from './group';
import { hash } from '@ember/helper';
// import type { ComponentLike } from '@glint/template';

import FormFieldsetInputComponent, {
  type FormFieldsetInputComponentSignature,
} from './input';

import FormFieldsetSelectComponent, {
  type ChoiceAttributes,
  type FormFieldsetSelectComponentSignature,
} from './select';

import FormFieldsetCalendarComponent, {
  type FormFieldsetCalendarComponentSignature,
} from './calendar';

import type { ComponentLike } from '@glint/template';
// import type { ChoicesGroup } from 'ember-choices';

interface Signature<T extends ChoiceAttributes> {
  Args: {
    title: string;
    submitted?: boolean;
  };
  Blocks: {
    field: [
      {
        input: ComponentLike<FormFieldsetInputComponentSignature>;
        select: ComponentLike<FormFieldsetSelectComponentSignature<T>>;
        multiSelect: ComponentLike<FormFieldsetSelectComponentSignature<T>>;
        calendar: ComponentLike<FormFieldsetCalendarComponentSignature>;
      },
    ];
    validatorHint: [];
  };
}
export default class FormFieldSetComponent<
  T extends ChoiceAttributes,
> extends Component<Signature<T>> {
  <template>
    <style
    >
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

      label.input:has(.too-many-choices.is-open) {
        z-index: 5;
        {{! label.input has isolation:isolate when focused, so it resets stacking, causing z-index to be localized. this makes the dropdown sit under another fieldsets label.input }}
      }
    </style>

    <fieldset class="fieldset form-control" ...attributes>
      <legend class="fieldset-legend">{{@title}}</legend>
      <label class="input w-full">
        {{yield
          (hash
            input=FormFieldsetInputComponent
            select=(component FormFieldsetSelectComponent submitted=@submitted)
            multiSelect=(component FormFieldsetSelectComponent)
            calendar=(component
              FormFieldsetCalendarComponent submitted=@submitted
            )
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
